import 'package:flutter/material.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

class OnboardingPager extends StatefulWidget {
  const OnboardingPager({super.key});

  @override
  State<OnboardingPager> createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<OnboardingPager> {
  final _images = [
        Assets.imgWelcomeBg1,
        Assets.imgWelcomeBg2,
        Assets.imgWelcomeBg3,
        Assets.imgWelcomeBg4,
      ];

  @override
  Widget build(BuildContext context) => PageView.builder(
        itemBuilder: (context, index) {
          var backgroundImage = _images[index];
          return ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                context.colorScheme.background,
              ],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
            blendMode: BlendMode.dstOut,
            child: RepaintBoundary(
              child: backgroundImage.asAssetImage(
                  fit: BoxFit.cover,
                  width: context.width,
                  height: context.height),
            ),
          );
        },
        itemCount: _images.length,
      );
}
