import 'package:mobile/features/common/domain/entities/user.dart';

/// [AuthResult] is a class that is used to pass data between routes.
final class AuthResult {
  AuthResult._({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;

  factory AuthResult.create({
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? photoUrl,
  }) =>
      AuthResult._(
        uid: '',
        email: email,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        photoUrl: photoUrl,
      );

  factory AuthResult.fromUser(UserEntity user) => AuthResult._(
        uid: user.id,
        email: user.email,
        phoneNumber: user.phoneNumber,
        firstName: user.name.substring(0, user.name.indexOf(' ')),
        lastName: user.name.substring(user.name.indexOf(' ') + 1),
        photoUrl: user.photoUrl,
      );
}
