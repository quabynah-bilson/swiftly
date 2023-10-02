import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/theme.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:shared_utils/shared_utils.dart';

/// The main app widget.
class SwiftlyApp extends StatefulWidget {
  const SwiftlyApp({super.key});

  @override
  State<SwiftlyApp> createState() => _SwiftlyAppState();
}

class _SwiftlyAppState extends State<SwiftlyApp> {
  final _authCubit = sl<AuthCubit>();

  @override
  Widget build(BuildContext context) => DevicePreview(
        enabled: false, // !kReleaseMode,
        builder: (_) => DismissKeyboard(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _authCubit),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Swiftly',
              theme: context.useLightTheme,
              darkTheme: context.useDarkTheme,
              themeMode: ThemeMode.light,
              onGenerateRoute: AppRouterConfig.setupRoutes,
              scrollBehavior: const CupertinoScrollBehavior(),
            ),
          ),
        ),
      );
}
