import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final _authCubit = context.read<AuthCubit>();

  @override
  void initState() {
    super.initState();
    _authCubit.checkAuthState();
  }

  @override
  Widget build(BuildContext context) => BlocListener(
        bloc: _authCubit,
        listener: (context, state) {
          if (!mounted) return;

          if (state is SuccessState<String>) {
            context.navigator
                .pushNamedAndRemoveUntil(state.data, (route) => false);
          }
        },
        child: Scaffold(
          body: AnimatedColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppLogo().bottom(40),
              'loading_desc'.tr()
                  .bodyText2(context,
                      emphasis: kEmphasisMedium, alignment: TextAlign.center)
                  .horizontal(context.width * 0.15),
              Lottie.asset(Assets.animLoading,
                  height: context.height * 0.15, fit: BoxFit.cover),
            ],
          ).centered(),
        ),
      );
}
