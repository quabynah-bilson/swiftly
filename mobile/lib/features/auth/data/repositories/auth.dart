import 'dart:async';

import 'package:api_utils/src/common/typedef.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/data/data_sources/local/local.dart';
import 'package:mobile/features/auth/data/data_sources/remote/remote.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/domain/entities/country.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';
import 'package:mobile/features/auth/domain/repositories/auth.dart';
import 'package:shared_utils/shared_utils.dart';

@Singleton(as: BaseAuthRepository)
final class FirebaseAuthRepository implements BaseAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const FirebaseAuthRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<String, AuthResult>> signInWithApple() async =>
      _remoteDataSource.signInWithApple();

  @override
  Future<Either<String, AuthResult>> signInWithGoogle() async =>
      _remoteDataSource.signInWithGoogle();

  @override
  Future<Stream<PhoneAuthResponse>> signInWithPhoneNumber(String phoneNumber,
          [String? dialCode]) async =>
      _remoteDataSource.signInWithPhoneNumber(phoneNumber, dialCode);

  @override
  Future<void> signOut() async => _remoteDataSource.signOut();

  @override
  Future<Either<String, AuthResult>> verifyPhoneNumber({
    required String verificationId,
    required String otp,
  }) async =>
      _remoteDataSource.verifyPhoneNumber(
          verificationId: verificationId, otp: otp);

  @override
  Future<Either<String, String>> updateUsername(String username) async =>
      _remoteDataSource.updateUsername(username);

  @override
  Future<bool> get isSignedIn async => _remoteDataSource.isSignedIn;

  @override
  FutureEither<String, List<Country>> get countries async {
    var countriesList = List<Country>.empty(growable: true);
    var either = await _remoteDataSource.countries;
    countriesList = either.fold((l) => List<Country>.empty(), (r) => r);
    if (countriesList.isEmpty) {
      either = await _localDataSource.countries;
      countriesList = either.fold((l) => List<Country>.empty(), (r) => r);
    }
    return right(countriesList);
  }
}
