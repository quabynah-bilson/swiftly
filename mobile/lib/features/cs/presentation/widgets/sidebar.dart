import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

/// A sidebar widget.
class Sidebar extends StatefulWidget {
  final Widget child;
  final Function(int) onPageSelected;

  const Sidebar({super.key, required this.child, required this.onPageSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  var _isSidebarOpen = false, _showMenuBar = false;

  @override
  Widget build(BuildContext context) {
    context.withDefaultOverlays(
      statusBarColor: _isSidebarOpen
          ? context.colorScheme.secondary
          : context.colorScheme.error,
      statusBarBrightness: _isSidebarOpen ? Brightness.dark : Brightness.light,
      statusBarIconBrightness:
          _isSidebarOpen ? Brightness.dark : Brightness.light,
    );
    return Scaffold(
      backgroundColor: _isSidebarOpen
          ? context.colorScheme.secondary
          : context.colorScheme.background,
      appBar: AppBar(
        title: const AppLogo(isLargeText: false),
        backgroundColor: _isSidebarOpen
            ? context.colorScheme.secondary
            : context.colorScheme.background,
        // secondary
        centerTitle: true,
        leading: IconButton(
          onPressed: _toggleSidebar,
          icon: const HeroIcon(HeroIcons.bars3BottomLeft),
        ),
      ),
      body: Stack(
        children: [
          DecoratedBox(
              decoration: BoxDecoration(
                  color: context.colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                        color:
                            context.colorScheme.onBackground.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ]),
              child: widget.child),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            onEnd: () => setState(() => _showMenuBar = true),
            top: 0,
            bottom: 0,
            left: 0,
            width: _isSidebarOpen ? context.width * 0.65 : 0,
            // right: _isSidebarOpen ? context.width * 0.45 : context.width,
            child: Container(
              width: context.width * 0.45,
              height: context.height,
              decoration: BoxDecoration(color: context.colorScheme.secondary),
              child: _showMenuBar
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: kToolbarHeight),
                      clipBehavior: Clip.antiAlias,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // @todo -> show menu bar
                        children: [
                          // ListTile(
                          //   leading: Icon(TablerIcons.car,
                          //       color: context.colorScheme.onSecondary),
                          //   title: Text('Vehicles',
                          //       style: context.textTheme.titleLarge?.copyWith(
                          //           color: context.colorScheme.onSecondary)),
                          //   onTap: () {}, // @todo implement page
                          // ),
                          // ListTile(
                          //   leading: Icon(TablerIcons.car,
                          //       color: context.colorScheme.onSecondary),
                          //   title: Text('Documents',
                          //       style: context.textTheme.titleLarge?.copyWith(
                          //           color: context.colorScheme.onSecondary)),
                          //   onTap: () {}, // @todo implement page
                          // ),
                          // ListTile(
                          //   leading: Icon(TablerIcons.credit_card,
                          //       color: context.colorScheme.onSecondary),
                          //   title: Text('Payments',
                          //       style: context.textTheme.titleLarge?.copyWith(
                          //           color: context.colorScheme.onSecondary)),
                          //   onTap: () {}, // @todo implement page
                          // ),
                          // ListTile(
                          //   leading: Icon(TablerIcons.bookmark,
                          //       color: context.colorScheme.onSecondary),
                          //   title: Text('My Orders',
                          //       style: context.textTheme.titleLarge?.copyWith(
                          //           color: context.colorScheme.onSecondary)),
                          //   onTap: () {}, // @todo implement page
                          // ),
                          // ListTile(
                          //   leading: HeroIcon(HeroIcons.user,
                          //       color: context.colorScheme.onSecondary),
                          //   title: Text('Edit Account',
                          //       style: context.textTheme.titleLarge?.copyWith(
                          //           color: context.colorScheme.onSecondary)),
                          //   onTap: () {}, // @todo implement page
                          // ),
                          // ListTile(
                          //   leading: HeroIcon(HeroIcons.informationCircle,
                          //       color: context.colorScheme.onSecondary),
                          //   title: Text('About',
                          //       style: context.textTheme.titleLarge?.copyWith(
                          //           color: context.colorScheme.onSecondary)),
                          //   onTap: () {}, // @todo implement page
                          // ),
                        ],
                      ),
                    ).fillMaxWidth(context, 0.45)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// Toggles the sidebar.
  void _toggleSidebar() => setState(() => _isSidebarOpen = !_isSidebarOpen);

  void _signOut() => context.showMessageDialog(
        context.tr('sign_out_desc'),
        animationAsset: Assets.animUserLeaving,
        title: context.tr('confirm_sign_out'),
        actionLabel: context.tr('sign_out'),
        onTap: context.read<AuthCubit>().signOut,
      );
}
