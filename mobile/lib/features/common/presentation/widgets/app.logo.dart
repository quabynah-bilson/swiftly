import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_utils/shared_utils.dart';

/// The app logo widget.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) => Text(
        context.tr('app_name'),
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: context.textTheme.headlineLarge?.fontSize,
            fontWeight: FontWeight.bold),
      );
}
