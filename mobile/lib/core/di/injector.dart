import 'package:easy_localization/easy_localization.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobile/core/di/injector.config.dart';
import 'package:mobile/core/env/env.dart';
import 'package:mobile/features/common/data/data_sources/local/adapters.dart';
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
  String appId, androidKey, iOSKey;
  if (kIsWeb) {
    appId = Env.kIntercomAppId;
    androidKey = Env.kIntercomAndroidApiKey;
    iOSKey = Env.kIntercomIosApiKey;
  } else {
    appId = String.fromEnvironment("INTERCOM_APP_ID",
        defaultValue: Env.kIntercomAppId);
    androidKey = String.fromEnvironment("INTERCOM_ANDROID_KEY",
        defaultValue: Env.kIntercomAndroidApiKey);
    iOSKey = String.fromEnvironment("INTERCOM_IOS_KEY",
        defaultValue: Env.kIntercomIosApiKey);
  }
  await Intercom.instance
      .initialize(appId, iosApiKey: iOSKey, androidApiKey: androidKey);

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  // initialize fast cached image
  await FastCachedImageConfig.init();

  // initialize injectable
  await sl.init();
}
