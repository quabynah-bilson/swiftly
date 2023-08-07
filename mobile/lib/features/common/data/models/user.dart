import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/common/domain/entities/user.dart';

part 'user.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
final class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.photoUrl,
    required super.phoneNumber,
    super.creditCardNumber = '',
    super.creditCardExpiryDate = '',
    super.creditCardCvv = '',
    super.zipCode = '',
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => _$UserModelFromJson(
        json.map((key, value) => MapEntry(key.toString(), value)),
      );

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() => toJson().toString();
}
