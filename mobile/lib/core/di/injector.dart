import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobile/core/di/injector.config.dart';
import 'package:mobile/core/env/env.dart';
import 'package:mobile/firebase_options.dart';

// service locator instance
GetIt sl = GetIt.instance;

// register all dependencies
@injectableInit
Future<void> configureDependencies() async {
  // initialize easy localization
  await EasyLocalization.ensureInitialized();

  // animate configuration
  Animate.restartOnHotReload = false;

  // initialize intercom
  await Intercom.instance.initialize(Env.kIntercomAppId,
      iosApiKey: Env.kIntercomIosApiKey,
      androidApiKey: Env.kIntercomAndroidApiKey);

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // initialize injectable
  sl.init();
}
