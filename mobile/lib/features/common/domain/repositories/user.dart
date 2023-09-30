import 'package:dartz/dartz.dart';
import 'package:mobile/features/common/domain/entities/user.dart';

abstract interface class BaseUserRepository {
  const BaseUserRepository._();

  Future<Either<String, Stream<UserEntity>>> get currentUser;

  Future<Either<void, String>> createUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    String? creditCardNumber,
    String? creditCardExpiryDate,
    String? creditCardCvv,
    String? zipCode,
    String? photoUrl,
  });

  Future<void> updateUser(UserEntity user);

  Future<void> deleteUser(String id);
}
