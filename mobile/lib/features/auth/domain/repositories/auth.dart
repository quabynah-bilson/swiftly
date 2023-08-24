import 'package:dartz/dartz.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';

abstract interface class BaseAuthRepository {
  const BaseAuthRepository._();

  Future<Either<String, AuthResult>> signInWithApple();

  Future<Either<String, AuthResult>> signInWithGoogle();

  Future<Either<String, AuthResult>> verifyPhoneNumber(
      {required String verificationId, required String otp});

  Future<Either<String, String>> updateUsername(String username);

  Future<Stream<PhoneAuthResponse>> signInWithPhoneNumber(String phoneNumber,
      [String? countryCode]);

  Future<void> signOut();
}
