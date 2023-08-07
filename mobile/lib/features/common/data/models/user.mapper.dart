import 'package:mobile/features/common/data/models/user.dart';
import 'package:mobile/features/common/domain/entities/user.dart';

extension UserMapper on UserEntity {
  UserModel fromEntity() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      creditCardNumber: creditCardNumber,
      creditCardExpiryDate: creditCardExpiryDate,
      creditCardCvv: creditCardCvv,
      zipCode: zipCode,
    );
  }
}
