import 'dart:convert';

import 'package:api_utils/api_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/data/models/country.dart';
import 'package:mobile/features/auth/domain/entities/country.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

@lazySingleton
final class AuthLocalDataSource {
  FutureEither<String, List<Country>> get countries async {
    try {
      var response = await rootBundle.loadString(Assets.dataCountries);
      var countries = (jsonDecode(response) as List)
          .map((e) => CountryModel.fromJson(e))
          .toList();
      return right(countries);
    } on Exception catch (e) {
      logger.e(e);
      return left(tr('errors.countries_error_message'));
    }
  }
}
