import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/features/common/presentation/widgets/auth.button.dart';
import 'package:mobile/features/common/presentation/widgets/onboarding.pager.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

/// Sign in with google/apple page (for unauthenticated users)
class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  var _loading = false;
  final _authCubit = AuthCubit();

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
                  title: 'auth_error_header'.tr());
            }

            if (state is SuccessState<AuthResult>) {
              context.navigator.pushNamedAndRemoveUntil(
                  AppRouter.userProfileRoute, (route) => false,
                  arguments: state.data);
            }
          },
          child: Scaffold(
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
                          .horizontal(context.width * 0.1)
                          .top(8),
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
                            AuthButton(
                                label: 'auth_sign_in_with_apple'.tr(),
                                backgroundColor: context.colorScheme.background,
                                outlined: false,
                                textColor: context.colorScheme.onBackground,
                                iconColor: context.colorScheme.onBackground,
                                onPressed: _authCubit.signInWithApple,
                                brandIcon: Assets.brandBrandApple),
                            AuthButton(
                                label: 'auth_sign_in_with_google'.tr(),
                                onPressed: _authCubit.signInWithGoogle,
                                backgroundColor: context.colorScheme.background,
                                outlined: false,
                                textColor: context.colorScheme.onBackground,
                                brandIcon: Assets.brandBrandGoogle),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                    child: Divider(endIndent: 24, indent: 24)),
                                'or'.tr().caption(context),
                                const Expanded(
                                    child: Divider(endIndent: 24, indent: 24)),
                              ],
                            ).vertical(12),
                            TextButton(
                                    onPressed: () => context.navigator
                                        .pushNamed(
                                            AppRouter.phoneVerificationRoute),
                                    child: tr('auth_sign_in_with_phone')
                                        .button(context))
                                .bottom(20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
