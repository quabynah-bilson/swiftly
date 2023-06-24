import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/generated/assets.dart';
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
        body: Stack(
          children: [
            // background image
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    context.colorScheme.background,
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
                blendMode: BlendMode.dstOut,
                child: Assets.imgWelcomeBg1.asAssetImage(
                  fit: BoxFit.cover,
                  width: context.width,
                  height: context.height,
                ),
              ),
            ),

            // bottom content (logo, buttons, etc)
            Positioned.fill(
              bottom: context.mediaQuery.padding.bottom,
              left: context.width * 0.1,
              right: context.width * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const AppLogo().animate().shimmer(duration: 850.ms),
                  tr('app_desc')
                      .subtitle2(context, alignment: TextAlign.center)
                      .animate()
                      .fadeIn(duration: 550.ms)
                      .top(8)
                      .bottom(40),
                  RepaintBoundary(
                    child: AppRoundedButton(
                      text: context.tr('get_started'),
                      onTap: () => context.navigator.pushNamedAndRemoveUntil(
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
      );
}
