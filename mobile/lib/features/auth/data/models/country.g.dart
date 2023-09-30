// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CountryModelCWProxy {
  CountryModel name(String name);

  CountryModel code(String code);

  CountryModel dialCode(String dialCode);

  CountryModel flag(String flag);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountryModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountryModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CountryModel call({
    String? name,
    String? code,
    String? dialCode,
    String? flag,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCountryModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCountryModel.copyWith.fieldName(...)`
class _$CountryModelCWProxyImpl implements _$CountryModelCWProxy {
  const _$CountryModelCWProxyImpl(this._value);

  final CountryModel _value;

  @override
  CountryModel name(String name) => this(name: name);

  @override
  CountryModel code(String code) => this(code: code);

  @override
  CountryModel dialCode(String dialCode) => this(dialCode: dialCode);

  @override
  CountryModel flag(String flag) => this(flag: flag);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CountryModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CountryModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CountryModel call({
    Object? name = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? dialCode = const $CopyWithPlaceholder(),
    Object? flag = const $CopyWithPlaceholder(),
  }) {
    return CountryModel(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      code: code == const $CopyWithPlaceholder() || code == null
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      dialCode: dialCode == const $CopyWithPlaceholder() || dialCode == null
          ? _value.dialCode
          // ignore: cast_nullable_to_non_nullable
          : dialCode as String,
      flag: flag == const $CopyWithPlaceholder() || flag == null
          ? _value.flag
          // ignore: cast_nullable_to_non_nullable
          : flag as String,
    );
  }
}

extension $CountryModelCopyWith on CountryModel {
  /// Returns a callable class that can be used as follows: `instanceOfCountryModel.copyWith(...)` or like so:`instanceOfCountryModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CountryModelCWProxy get copyWith => _$CountryModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
      name: json['name'] as String,
      code: json['code'] as String,
      dialCode: json['dial_code'] as String,
      flag: json['flag'] as String,
    );

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'dial_code': instance.dialCode,
      'flag': instance.flag,
    };
