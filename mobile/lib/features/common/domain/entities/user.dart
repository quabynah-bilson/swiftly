class UserEntity {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String phoneNumber;
  final String creditCardNumber;
  final String creditCardExpiryDate;
  final String creditCardCvv;
  final String zipCode;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.phoneNumber,
    this.creditCardNumber = '',
    this.creditCardExpiryDate = '',
    this.creditCardCvv = '',
    this.zipCode = '',
  });
}
