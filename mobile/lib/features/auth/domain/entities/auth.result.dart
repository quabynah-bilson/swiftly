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
    required String uid,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? photoUrl,
  }) =>
      AuthResult._(
        uid: uid,
        email: email,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        photoUrl: photoUrl,
      );
}
