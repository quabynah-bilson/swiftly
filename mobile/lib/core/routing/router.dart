import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/generated/assets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_utils/shared_utils.dart';

final class AppRouterConfig {
  static Route<dynamic>? setupRoutes(RouteSettings settings) {
    // traverse routes
    switch (settings.name) {
      case AppRouter.initialRoute:
        return _initialRouteBuilder(settings);

      /// onboarding
      // case AppRouter.resetPasswordRoute:
      //   return MaterialWithModalsPageRoute(
      //       builder: (_) => const ResetPasswordPage(), settings: settings);
      // case AppRouter.signUpRoute:
      //   return MaterialWithModalsPageRoute(
      //       builder: (_) => const RegisterAccountPage(), settings: settings);
      // case AppRouter.signInRoute:
      //   return MaterialWithModalsPageRoute(
      //       builder: (_) => const LoginPage(), settings: settings);
    }

    return MaterialWithModalsPageRoute(
      builder: (context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0, backgroundColor: context.colorScheme.background),
        body: EmptyContentPlaceholder(
            icon: TablerIcons.building_factory,
            title: context.tr('under_dev_title'),
            subtitle: context.tr('under_dev_dev')),
      ),
    );
  }

  static Route<dynamic> _initialRouteBuilder(RouteSettings? settings) =>
      MaterialWithModalsPageRoute(
          builder: (context) {
            kUseDefaultOverlays(context,
                statusBarBrightness: context.theme.brightness);
            return Scaffold(
              body: Builder(
                builder: (context) => AnimatedColumn(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppLogo().bottom(40),
                    tr('loading_desc')
                        .bodyText2(context,
                            emphasis: kEmphasisMedium,
                            alignment: TextAlign.center)
                        .horizontal(context.width * 0.15),
                    Lottie.asset(Assets.animLoading,
                        height: context.height * 0.15, fit: BoxFit.cover),
                  ],
                ).centered(),
              ),
            );
          },
          settings: settings);
}

sealed class AppRouter {
  /// onboarding
  static const resetPasswordRoute = '/auth/sign-in/reset-password'; // todo
  static const phoneVerificationRoute = '/auth/phone-verification'; // todo

  /// general
  static const initialRoute = '/'; // todo
  static const homeRoute = '/home'; // todo
}
