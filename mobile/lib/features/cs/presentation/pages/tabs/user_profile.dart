part of '../home.dart';

class _UserProfileTab extends StatefulWidget {
  const _UserProfileTab({super.key});

  @override
  State<_UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<_UserProfileTab> {
  final _userCubit = sl<UserCubit>(), _authCubit = sl<AuthCubit>();
  Stream<UserEntity>? _userStream;
  var _loading = false;

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
            BlocListener(
              bloc: _authCubit,
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
          ],
          child: StreamBuilder(
              stream: _userStream,
              builder: (context, snapshot) => snapshot.hasData
                  ? _buildCurrentUserUI(snapshot.data as UserEntity)
                  : const SizedBox.shrink()),
        ).vertical(12),
      );

  Widget _buildCurrentUserUI(UserEntity user) => AnimatedListView(
        padding: EdgeInsets.only(top: context.padding.top + 12),
        children: [
          _buildAvatar(user.photoUrl).bottom(24),
          AppRoundedButton(
            text: 'Update my profile',
            outlined: true,
            icon: TablerIcons.eye_edit,
            onTap: () => context.navigator.pushNamed(
              AppRouter.userProfileRoute,
              arguments: AuthResult.fromUser(user),
            ),
          ).centered().bottom(40),
          _buildListTile(
            icon: TablerIcons.user_circle,
            label: user.name,
            subtitle: 'Your name',
            onTap: () => context.navigator.pushNamed(
              AppRouter.userProfileRoute,
              arguments: AuthResult.fromUser(user),
            ),
          ),
          if (!user.email.isNullOrEmpty()) ...{
            _buildListTile(
              icon: TablerIcons.mail_cog,
              label: user.email,
              subtitle: 'Your email address',
              onTap: () => context.navigator.pushNamed(
                AppRouter.userProfileRoute,
                arguments: AuthResult.fromUser(user),
              ),
            ),
          },
          if (!user.phoneNumber.isNullOrEmpty()) ...{
            _buildListTile(
              icon: TablerIcons.phone_call,
              label: user.phoneNumber,
              subtitle: 'Your phone number',
              onTap: () => context.navigator.pushNamed(
                AppRouter.userProfileRoute,
                arguments: AuthResult.fromUser(user),
              ),
            ),
          },
          _buildListTile(
            icon: TablerIcons.credit_card,
            label: hashCreditCardNumber(user.creditCardNumber),
            subtitle: 'Linked Credit Card Number',
            onTap: () => context.navigator.pushNamed(
              AppRouter.userProfileRoute,
              arguments: AuthResult.fromUser(user),
            ),
          ),
          AppRoundedButton(
            text: 'Sign out',
            backgroundColor: context.colorScheme.error,
            textColor: context.colorScheme.onError,
            icon: TablerIcons.shield_lock,
            onTap: () => context.showMessageDialog('Do you wish to sign out?',
                onTap: _authCubit.signOut),
          ).centered().top(40),
        ],
      );

  Widget _buildAvatar(String? avatarUrl) => avatarUrl.isNullOrEmpty()
      ? Assets.imgAppstore
          .avatar(size: context.height * 0.12, circular: true, fromAsset: true)
          .centered()
      : Stack(
          clipBehavior: Clip.none,
          children: [
            Assets.imgAppstore.avatar(
                size: context.height * 0.13, circular: true, fromAsset: true),
            Positioned(
              bottom: -1,
              right: -8,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: context.colorScheme.background, width: 4),
                  ),
                  child: avatarUrl.avatar(size: 64, circular: true)),
            ),
          ],
        ).centered();

  Widget _buildListTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
    Color? color,
    Color? backgroundColor,
    String? subtitle,
  }) =>
      DecoratedBox(
        decoration: BoxDecoration(
            color: backgroundColor ?? context.colorScheme.surface),
        child: ListTile(
          leading: Icon(icon, color: color ?? context.colorScheme.onSurface),
          title: label.bodyText2(context,
              color: color ?? context.colorScheme.onSurface),
          subtitle: subtitle?.caption(context,
              emphasis: kEmphasisMedium,
              color: color ?? context.colorScheme.onSurface),
          trailing: trailing ??
              Icon(TablerIcons.chevron_right,
                  color: color ?? context.colorScheme.onSurface),
          onTap: onTap,
        ),
      ).bottom(8);
}
