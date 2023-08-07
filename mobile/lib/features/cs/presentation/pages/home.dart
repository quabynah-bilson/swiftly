import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
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

  @override
  void initState() {
    super.initState();
    // start intercom messenger after a delay
    // doAfterDelay(Intercom.instance.displayMessenger);
  }

  @override
  Widget build(BuildContext context) => LoadingIndicator(
        loadingAnimIsAsset: true,
        lottieAnimResource: Assets.animLoading,
        isLoading: _loading,
        child: BlocListener(
          bloc: context.read<AuthCubit>(),
          listener: (context, state) {
            if (!mounted) return;

            setState(() => _loading = state is LoadingState);

            if (state is ErrorState) context.showMessageDialog(state.failure);

            if (state is SuccessState<String>) {
              context.navigator
                  .pushNamedAndRemoveUntil(state.data, (route) => false);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const AppLogo(isLargeText: false),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const HeroIcon(HeroIcons.informationCircle),
                  tooltip: context.tr('need_help'),
                  onPressed: context.showFeatureUnderDevSheet,
                ),
                IconButton(
                  icon: const HeroIcon(HeroIcons.userCircle),
                  tooltip: context.tr('sign_out_header'),
                  onPressed: () => context.showMessageDialog(
                    context.tr('sign_out_desc'),
                    animationAsset: Assets.animUserLeaving,
                    title: context.tr('confirm_sign_out'),
                    actionLabel: context.tr('sign_out'),
                    onTap: context.read<AuthCubit>().signOut,
                  ),
                ),
              ],
            ),
            body: EmptyContentPlaceholder(
                icon: TablerIcons.message_chatbot,
                title: tr('under_dev_title'),
                subtitle: tr('under_dev_desc')),
          ),
        ),
      );
}
