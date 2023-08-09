import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/presentation/pages/phone.auth.dart';
import 'package:mobile/features/auth/presentation/pages/user.auth.dart';
import 'package:mobile/features/auth/presentation/pages/user.profile.dart';
import 'package:mobile/features/common/presentation/pages/splash.dart';
import 'package:mobile/features/cs/presentation/pages/home.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_utils/shared_utils.dart';

final class AppRouterConfig {
  static Route<dynamic>? setupRoutes(RouteSettings settings) {
    // traverse routes
    switch (settings.name) {
      case AppRouter.initialRoute:
        return MaterialWithModalsPageRoute(
            builder: (_) => const SplashPage(), settings: settings);

      /// onboarding
      case AppRouter.userAuthRoute:
        return MaterialWithModalsPageRoute(
            builder: (_) => const UserAuthPage(), settings: settings);
      case AppRouter.phoneVerificationRoute:
        return MaterialWithModalsPageRoute(
            builder: (_) => const PhoneAuthPage(), settings: settings);
      case AppRouter.userProfileRoute:
        return MaterialWithModalsPageRoute(
            builder: (_) =>
                UserProfilePage(authResult: settings.arguments as AuthResult),
            settings: settings);
      case AppRouter.homeRoute:
        return MaterialWithModalsPageRoute(
            builder: (_) => const HomePage(), settings: settings);
    }

    return MaterialWithModalsPageRoute(
      builder: (context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0, backgroundColor: context.colorScheme.background),
        body: EmptyContentPlaceholder(
            icon: TablerIcons.building_factory,
            title: context.tr('under_dev_title'),
            subtitle: context.tr('under_dev_desc')),
      ),
    );
  }
}

sealed class AppRouter {
  /// onboarding
  static const userAuthRoute = '/auth/user';
  static const phoneVerificationRoute = '/auth/phone';
  static const userProfileRoute = '/auth/user-profile';

  /// general
  static const initialRoute = '/';
  static const homeRoute = '/home'; // todo
}
