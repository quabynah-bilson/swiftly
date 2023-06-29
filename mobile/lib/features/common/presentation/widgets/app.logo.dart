import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

/// The app logo widget.
class AppLogo extends StatelessWidget {
  final bool isLargeText;

  const AppLogo({super.key, this.isLargeText = true});

  @override
  Widget build(BuildContext context) => Text(
        context.tr('app_name'),
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: (isLargeText
                    ? context.textTheme.headlineLarge
                    : context.textTheme.headlineSmall)
                ?.fontSize,
            fontWeight: FontWeight.bold),
      );

  // @override
  // Widget build(BuildContext context) => SvgPicture.asset(
  //       Assets.imgAppLogo,
  //       colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
  //       height: 40,
  //       width: context.width,
  //     );
}
