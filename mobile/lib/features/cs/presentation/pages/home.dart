import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/domain/entities/user.dart';
import 'package:mobile/features/common/presentation/manager/user_cubit.dart';
import 'package:mobile/features/cs/presentation/widgets/sidebar.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

/// Customer service home page.
/// Allows the user to interact with the customer service AI bot.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _loading = false;
  final _userCubit = sl<UserCubit>();
  Stream<UserEntity>? _userStream;

  @override
  void initState() {
    super.initState();
    doAfterDelay(_userCubit.currentUser);
  }

  @override
  Widget build(BuildContext context) => LoadingIndicator(
        loadingAnimIsAsset: true,
        lottieAnimResource: Assets.animLoading,
        isLoading: _loading,
        child: MultiBlocListener(
          listeners: [
            BlocListener(
              bloc: context.read<AuthCubit>(),
              listener: (context, state) {
                if (!mounted) return;

                setState(() => _loading = state is LoadingState);

                if (state is ErrorState) {
                  context.showMessageDialog(state.failure);
                }

                if (state is SuccessState<String>) {
                  context.navigator
                      .pushNamedAndRemoveUntil(state.data, (route) => false);
                }
              },
            ),
            BlocListener(
              bloc: _userCubit,
              listener: (context, state) {
                if (!mounted) return;

                setState(() => _loading = state is LoadingState);

                if (state is ErrorState) {
                  context.showMessageDialog(state.failure);
                }

                if (state is SuccessState<Stream<UserEntity>>) {
                  setState(() => _userStream = state.data);
                }
              },
            ),
          ],
          child: Sidebar(
            // @todo -> switch to the correct page
            onPageSelected: (page) => context.showFeatureUnderDevSheet(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(Assets.animUnderDev,
                    height: context.height * 0.15),
                EmptyContentPlaceholder(
                    title: tr('under_dev_title'),
                    subtitle: tr('under_dev_desc')),
                StreamBuilder(
                    stream: _userStream,
                    builder: (context, snapshot) => snapshot.hasData
                        ? Text(snapshot.data!.name)
                        : const SizedBox.shrink()).vertical(12),
                AppRoundedButton(
                  text: 'Open Intercom',
                  onTap: () async {
                    // messenger will load the messages only if the user is registered in Intercom.
                    // either identified or unidentified.
                    await sl<Intercom>().displayMessenger();
                  },
                ).top(24),
              ],
            ).centered(),
          ),
        ),
      );
}
