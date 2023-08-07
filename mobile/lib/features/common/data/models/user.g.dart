// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserModelCWProxy {
  UserModel id(String id);

  UserModel name(String name);

  UserModel email(String email);

  UserModel photoUrl(String photoUrl);

  UserModel phoneNumber(String phoneNumber);

  UserModel creditCardNumber(String creditCardNumber);

  UserModel creditCardExpiryDate(String creditCardExpiryDate);

  UserModel creditCardCvv(String creditCardCvv);

  UserModel zipCode(String zipCode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserModel call({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? creditCardNumber,
    String? creditCardExpiryDate,
    String? creditCardCvv,
    String? zipCode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserModel.copyWith.fieldName(...)`
class _$UserModelCWProxyImpl implements _$UserModelCWProxy {
  const _$UserModelCWProxyImpl(this._value);

  final UserModel _value;

  @override
  UserModel id(String id) => this(id: id);

  @override
  UserModel name(String name) => this(name: name);

  @override
  UserModel email(String email) => this(email: email);

  @override
  UserModel photoUrl(String photoUrl) => this(photoUrl: photoUrl);

  @override
  UserModel phoneNumber(String phoneNumber) => this(phoneNumber: phoneNumber);

  @override
  UserModel creditCardNumber(String creditCardNumber) =>
      this(creditCardNumber: creditCardNumber);

  @override
  UserModel creditCardExpiryDate(String creditCardExpiryDate) =>
      this(creditCardExpiryDate: creditCardExpiryDate);

  @override
  UserModel creditCardCvv(String creditCardCvv) =>
      this(creditCardCvv: creditCardCvv);

  @override
  UserModel zipCode(String zipCode) => this(zipCode: zipCode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? phoneNumber = const $CopyWithPlaceholder(),
    Object? creditCardNumber = const $CopyWithPlaceholder(),
    Object? creditCardExpiryDate = const $CopyWithPlaceholder(),
    Object? creditCardCvv = const $CopyWithPlaceholder(),
    Object? zipCode = const $CopyWithPlaceholder(),
  }) {
    return UserModel(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      email: email == const $CopyWithPlaceholder() || email == null
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder() || photoUrl == null
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String,
      phoneNumber:
          phoneNumber == const $CopyWithPlaceholder() || phoneNumber == null
              ? _value.phoneNumber
              // ignore: cast_nullable_to_non_nullable
              : phoneNumber as String,
      creditCardNumber: creditCardNumber == const $CopyWithPlaceholder() ||
              creditCardNumber == null
          ? _value.creditCardNumber
          // ignore: cast_nullable_to_non_nullable
          : creditCardNumber as String,
      creditCardExpiryDate:
          creditCardExpiryDate == const $CopyWithPlaceholder() ||
                  creditCardExpiryDate == null
              ? _value.creditCardExpiryDate
              // ignore: cast_nullable_to_non_nullable
              : creditCardExpiryDate as String,
      creditCardCvv:
          creditCardCvv == const $CopyWithPlaceholder() || creditCardCvv == null
              ? _value.creditCardCvv
              // ignore: cast_nullable_to_non_nullable
              : creditCardCvv as String,
      zipCode: zipCode == const $CopyWithPlaceholder() || zipCode == null
          ? _value.zipCode
          // ignore: cast_nullable_to_non_nullable
          : zipCode as String,
    );
  }
}

extension $UserModelCopyWith on UserModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserModel.copyWith(...)` or like so:`instanceOfUserModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserModelCWProxy get copyWith => _$UserModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String,
      phoneNumber: json['phone_number'] as String,
      creditCardNumber: json['credit_card_number'] as String? ?? '',
      creditCardExpiryDate: json['credit_card_expiry_date'] as String? ?? '',
      creditCardCvv: json['credit_card_cvv'] as String? ?? '',
      zipCode: json['zip_code'] as String? ?? '',
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo_url': instance.photoUrl,
      'phone_number': instance.phoneNumber,
      'credit_card_number': instance.creditCardNumber,
      'credit_card_expiry_date': instance.creditCardExpiryDate,
      'credit_card_cvv': instance.creditCardCvv,
      'zip_code': instance.zipCode,
    };
