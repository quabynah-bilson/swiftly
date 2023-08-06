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
  Widget build(BuildContext context) => Assets.imgAppLogo.asAssetImage(
    width:context.width * (isLargeText ? 0.3 : 0.18),
  );
}
