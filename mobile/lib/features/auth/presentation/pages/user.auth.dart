import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/features/common/presentation/widgets/auth.button.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

/// Sign in with google/apple page (for unauthenticated users)
class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  var _loading = false, _backgroundImage = Assets.imgWelcomeBg1;
  final _authCubit = AuthCubit(sl(), sl());

  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(4035.ms, (_) {
      if (!mounted) return;

      // select the next image one after the other
      switch (_backgroundImage) {
        case Assets.imgWelcomeBg1:
          _backgroundImage = Assets.imgWelcomeBg2;
          break;
        case Assets.imgWelcomeBg2:
          _backgroundImage = Assets.imgWelcomeBg3;
          break;
        case Assets.imgWelcomeBg3:
          _backgroundImage = Assets.imgWelcomeBg1;
          break;
      }

      // @todo -> remove this feature in production
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => LoadingIndicator(
        isLoading: _loading,
        loadingAnimIsAsset: true,
        lottieAnimResource: Assets.animLoading,
        child: BlocListener(
          bloc: _authCubit,
          listener: (context, state) {
            if (!mounted) return;

            setState(() => _loading = state is LoadingState);

            if (state is ErrorState<String>) {
              context.showMessageDialog(state.failure,
                  title: context.tr('auth_error_header'));
            }

            if (state is SuccessState<String>) {
              context.navigator.pushNamedAndRemoveUntil(
                  AppRouter.homeRoute, (route) => false);
            }
          },
          child: Scaffold(
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
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height)),
                    blendMode: BlendMode.dstOut,
                    child: RepaintBoundary(
                      child: _backgroundImage
                          .asAssetImage(
                            fit: BoxFit.cover,
                            width: context.width,
                            height: context.height,
                          )
                          .animate(
                              onPlay: (controller) => controller.repeat(
                                  reverse: true, period: 2.seconds))
                          .fadeIn(delay: 15.ms)
                          .scaleXY(end: 1.1),
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
                      RepaintBoundary(
                        child: tr('app_desc')
                            .subtitle2(context, alignment: TextAlign.center)
                            .animate()
                            .fadeIn(duration: 550.ms),
                      ).top(8).bottom(40),
                      AuthButton(
                          label: context.tr('auth_sign_in_with_apple'),
                          tint: context.colorScheme.onBackground,
                          outlined: false,
                          iconTint: context.colorScheme.background,
                          onPressed: _authCubit.signInWithApple,
                          brandIcon: Assets.brandBrandApple),
                      AuthButton(
                          label: context.tr('auth_sign_in_with_google'),
                          onPressed: _authCubit.signInWithGoogle,
                          brandIcon: Assets.brandBrandGoogle),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                              child: Divider(endIndent: 24, indent: 24)),
                          'or'.caption(context),
                          const Expanded(
                              child: Divider(endIndent: 24, indent: 24)),
                        ],
                      ).vertical(12),
                      TextButton.icon(
                        onPressed: () => context.navigator
                            .pushNamed(AppRouter.phoneVerificationRoute),
                        label: context
                            .tr('auth_sign_in_with_phone')
                            .button(context),
                        icon: HeroIcon(HeroIcons.phone,
                            color: context.colorScheme.onBackground),
                      ).bottom(20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
