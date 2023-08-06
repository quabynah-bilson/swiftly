import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/features/common/presentation/widgets/onboarding.pager.dart';
import 'package:shared_utils/shared_utils.dart';

/// Welcome page for authenticated users
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Container(
              width: context.width,
              padding: EdgeInsets.only(
                  top: context.mediaQuery.padding.top + 20, bottom: 20),
              decoration: BoxDecoration(
                color: context.colorScheme.background,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppLogo().animate().shimmer(duration: 850.ms),
                  tr('app_desc')
                      .subtitle2(context, alignment: TextAlign.center)
                      .horizontal(context.width * 0.1).top(8),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // background image
                  const Positioned.fill(child: OnboardingPager()),

                  // bottom content (logo, buttons, etc)
                  Positioned.fill(
                    bottom: context.mediaQuery.padding.bottom,
                    left: context.width * 0.1,
                    right: context.width * 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RepaintBoundary(
                          child: AppRoundedButton(
                            text: 'get_started'.tr(),
                            onTap: () => context.navigator
                                .pushNamedAndRemoveUntil(
                                    AppRouter.homeRoute, (route) => false),
                            icon: TablerIcons.arrow_right,
                            iconLocation: IconLocation.end,
                          )
                              .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: false))
                              .scaleXY(end: 1.1, duration: 850.ms)
                              .then(delay: 150.ms)
                              .scaleXY(end: 1 / 1.1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
