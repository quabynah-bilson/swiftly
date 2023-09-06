import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/core/utils/strings.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/domain/entities/user.dart';
import 'package:mobile/features/common/presentation/manager/user_cubit.dart';
import 'package:mobile/generated/assets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_utils/shared_utils.dart';

part 'tabs/home.dart';

part 'tabs/user_profile.dart';

/// Customer service home page.
/// Allows the user to interact with the customer service AI bot.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomNavIndex = 0;

  List<IconData> get iconList => <IconData>[
        TablerIcons.home_2, // home
        TablerIcons.user_circle, // user profile & settings
      ];

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: sl<AuthCubit>().isSignedIn,
      builder: (context, snapshot) {
        var loggedIn = snapshot.data ?? false;
        return Scaffold(
          body: IndexedStack(
            index: _bottomNavIndex,
            children: const [
              _HomeTab(),
              _UserProfileTab(),
            ],
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: iconList,
            activeIndex: _bottomNavIndex,
            gapLocation: loggedIn ? GapLocation.center : GapLocation.none,
            gapWidth: 40,
            notchSmoothness: NotchSmoothness.smoothEdge,
            onTap: (index) {
              context.withDefaultOverlays(
                  statusBarBrightness: context.theme.brightness);
              setState(() => _bottomNavIndex = index);
            },
            backgroundColor: context.colorScheme.onSecondary,
            activeColor: context.colorScheme.secondary,
            inactiveColor:
                context.colorScheme.onPrimary.withOpacity(kEmphasisMedium),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: loggedIn
              ? FloatingActionButton(
                  backgroundColor: context.colorScheme.secondary,
                  foregroundColor: context.colorScheme.onSecondary,
                  child: const Icon(TablerIcons.message_2_question),
                  onPressed: () async {
                    await sl<Intercom>().displayMessenger();
                  },
                )
              : null,
        );
      });
}
