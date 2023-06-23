import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/theme.dart';
import 'package:shared_utils/shared_utils.dart';

/// The main app widget.
class SwiftlyApp extends StatefulWidget {
  const SwiftlyApp({super.key});

  @override
  State<SwiftlyApp> createState() => _SwiftlyAppState();
}

class _SwiftlyAppState extends State<SwiftlyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => DevicePreview(
        enabled: !kReleaseMode,
        builder: (_) => DismissKeyboard(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: tr('app_name'),
            theme: context.useLightTheme,
            darkTheme: context.useDarkTheme,
            themeMode: ThemeMode.system,
            onGenerateRoute: AppRouterConfig.setupRoutes,
            navigatorKey: _navigatorKey,
            scrollBehavior: const CupertinoScrollBehavior(),
          ),
        ),
      );
}
