import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
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

  const FirebaseAuthRepository(
      this._firebaseAuth, this._googleSignIn, this._persistentStorage);

  @override
  Future<Either<String, String>> signInWithApple() async {
    try {
      final response = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      var appleCredential =
          AppleAuthProvider.credential(response.authorizationCode);
      var credential =
          await _firebaseAuth.signInWithCredential(appleCredential);
      var user = credential.user;
      if (user == null) return right('Sign in aborted by user');
      await _persistentStorage.saveUserId(user.uid);
      return left(
          tr('signed_in_as', namedArgs: {'name': user.displayName ?? ''}));
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return right(tr('auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return right(
          kReleaseMode ? tr('auth_error_message') : tr('under_dev_desc'));
    }
  }

  @override
  Future<Either<String, String>> signInWithGoogle() async {
    try {
      var account = await _googleSignIn.signIn();
      if (account == null) return right('Sign in aborted by user');

      var auth = await account.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      var userCredential = await _firebaseAuth.signInWithCredential(credential);
      var user = userCredential.user;
      if (user == null) return right('Sign in aborted by user');

      await _persistentStorage.saveUserId(user.uid);
      return left(
          tr('signed_in_as', namedArgs: {'name': user.displayName ?? ''}));
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return right(tr('auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return right(tr('auth_error_message'));
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
        response
            .add(PhoneAuthResponseVerificationFailed(tr('phone_auth_error')));
      }

      // handles successful sign in
      verificationCompleted(PhoneAuthCredential credential) async {
        var userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        var user = userCredential.user;
        if (user == null) return right(tr('auth_error_message'));

        await _persistentStorage.saveUserId(user.uid);
        response.add(PhoneAuthResponseVerificationCompleted(
            _firebaseAuth.currentUser?.displayName));
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
      response.add(PhoneAuthResponseVerificationFailed(tr('phone_auth_error')));
    } on Exception catch (e) {
      logger.e(e);
      response.add(PhoneAuthResponseVerificationFailed(tr('phone_auth_error')));
    }
    return response.stream;
  }

  @override
  Future<void> signOut() async {
    var account = _googleSignIn.currentUser;
    if (account != null) await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _persistentStorage.clear();
  }

  @override
  Future<Either<bool, String>> verifyPhoneNumber({
    required String verificationId,
    required String otp,
  }) async {
    try {
      var credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      var userCredential = await _firebaseAuth.signInWithCredential(credential);
      var user = userCredential.user;
      if (user == null) return right('Sign in aborted by user');

      await _persistentStorage.saveUserId(user.uid);
      return left(user.displayName.isNullOrEmpty());
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      if (e.code == 'invalid-verification-code') {
        return right('The OTP you entered is incorrect. Please try again.');
      }

      return right(tr('auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return right(tr('auth_error_message'));
    }
  }

  @override
  Future<Either<String, String>> updateUsername(String username) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(username);
      return left(tr('username_updated'));
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      return right(tr('auth_error_message'));
    } on Exception catch (e) {
      logger.e(e);
      return right(tr('auth_error_message'));
    }
  }
}
