import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';
import 'package:mobile/features/auth/domain/repositories/auth.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:shared_utils/shared_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@Singleton(as: BaseAuthRepository)
final class FirebaseAuthRepository implements BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final BasePersistentStorage _persistentStorage;
  final Intercom _intercom;

  const FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn,
      this._persistentStorage, this._intercom);

  String get rawNonce {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    var nonce =
        List.generate(32, (_) => charset[random.nextInt(charset.length)])
            .join();
    final bytes = utf8.encode(nonce);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<Either<String, AuthResult>> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: AppleIDAuthorizationScopes.values);
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      var credential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      var user = credential.user;
      if (user == null) return left(tr('errors.auth_error_message'));
      await _persistentStorage.saveUserId(user.uid);

      String firstName = '', lastName = '';
      if (appleCredential.givenName != null) {
        firstName = appleCredential.givenName!;
      }

      if (appleCredential.familyName != null) {
        lastName = appleCredential.familyName!;
      }

      var result = AuthResult.create(
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      // register user with intercom
      await _registerWithIntercom(user.uid, user.email);

      return right(result);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return left(tr('errors.auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return left(kReleaseMode
          ? tr('errors.auth_error_message')
          : tr('under_dev_desc'));
    }
  }

  @override
  Future<Either<String, AuthResult>> signInWithGoogle() async {
    try {
      var account = await _googleSignIn.signIn();
      if (account == null) return left(tr('errors.auth_error_message'));

      var auth = await account.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      var userCredential = await _firebaseAuth.signInWithCredential(credential);
      var user = userCredential.user;
      if (user == null) return left(tr('errors.auth_error_message'));

      await _persistentStorage.saveUserId(user.uid);

      String firstName = '', lastName = '';
      if (user.displayName != null) {
        var names = user.displayName!.split(' ');
        firstName = names[0];
        if (names.length > 1) {
          lastName = names[1];
        }
      }

      var result = AuthResult.create(
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      // register user with intercom
      await _registerWithIntercom(user.uid, user.email);

      return right(result);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return left(tr('errors.auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return left(tr('errors.auth_error_message'));
    }
  }

  @override
  Future<Stream<PhoneAuthResponse>> signInWithPhoneNumber(String phoneNumber,
      [String? countryCode]) async {
    var response = StreamController<PhoneAuthResponse>.broadcast();
    try {
      countryCode = countryCode ?? '233'; // default to Ghana

      // handles errors that occur during the sign in process
      verificationFailed(FirebaseAuthException e) {
        logger.e(e.message);
        response.add(
            PhoneAuthResponseVerificationFailed(tr('errors.phone_auth_error')));
      }

      // handles successful sign in
      verificationCompleted(PhoneAuthCredential credential) async {
        var userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        var user = userCredential.user;
        if (user == null) return right(tr('errors.auth_error_message'));

        await _persistentStorage.saveUserId(user.uid);

        String firstName = '', lastName = '';
        if (user.displayName != null) {
          var names = user.displayName!.split(' ');
          firstName = names[0];
          if (names.length > 1) {
            lastName = names[1];
          }
        }

        var result = AuthResult.create(
          firstName: firstName,
          lastName: lastName,
          email: user.email,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
        );

        // register user with intercom
        await _registerWithIntercom(user.uid, user.email);

        response.add(PhoneAuthResponseVerificationCompleted(result));
      }

      // handles the code sent to the user's phone
      codeSent(String verificationId, int? resendToken) async {
        response.add(PhoneAuthResponseCodeSent(verificationId));
      }

      // handles the code sent to the user's phone
      codeAutoRetrievalTimeout(String verificationId) async {
        response.add(PhoneAuthResponseCodeAutoRetrievalTimeout(verificationId));
      }

      // get the last 9 digits of the phone number and append with country code
      phoneNumber = phoneNumber.substring(phoneNumber.length - 9);
      phoneNumber = '+$countryCode$phoneNumber';

      // send the code to the user's phone
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      response.add(
          PhoneAuthResponseVerificationFailed(tr('errors.phone_auth_error')));
    } on Exception catch (e) {
      logger.e(e);
      response.add(
          PhoneAuthResponseVerificationFailed(tr('errors.phone_auth_error')));
    }
    return response.stream;
  }

  @override
  Future<void> signOut() async {
    var account = _googleSignIn.currentUser;
    if (account != null) await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _persistentStorage.clear();
    await _intercom.logout();
  }

  @override
  Future<Either<String, AuthResult>> verifyPhoneNumber({
    required String verificationId,
    required String otp,
  }) async {
    try {
      var credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      var userCredential = await _firebaseAuth.signInWithCredential(credential);
      var user = userCredential.user;
      if (user == null) return left(tr('errors.auth_error_message'));

      await _persistentStorage.saveUserId(user.uid);

      String firstName = '', lastName = '';
      if (user.displayName != null) {
        var names = user.displayName!.split(' ');
        firstName = names[0];
        if (names.length > 1) {
          lastName = names[1];
        }
      }

      var result = AuthResult.create(
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      return right(result);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      if (e.code == 'invalid-verification-code') {
        return left('The OTP you entered is incorrect. Please try again.');
      }

      return left(tr('errors.auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return left(tr('errors.auth_error_message'));
    }
  }

  @override
  Future<Either<String, String>> updateUsername(String username) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(username);
      return left(tr('username_updated'));
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return right(tr('errors.auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return right(tr('errors.auth_error_message'));
    }
  }

  // register user with intercom
  Future<void> _registerWithIntercom(String uid, String? email) async {
    await _intercom.loginIdentifiedUser(
      userId: uid,
      // email: email,
      statusCallback: IntercomStatusCallback(
        onFailure: (error) => logger.e(error),
        onSuccess: () => logger.i('Intercom user hash updated'),
      ),
    );
  }
}
