import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/auth/domain/entities/country.dart';

part 'country.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class CountryModel extends Country {
  CountryModel({
    required super.name,
    required super.code,
    required super.dialCode,
    required super.flag,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);

  @override
  String toString() => toJson().toString();
}
