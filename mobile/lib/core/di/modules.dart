import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_utils/shared_utils.dart';
// import 'package:intercom_flutter/intercom_flutter.dart';

@module
abstract class SecureStorageModule {
  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPrefs async =>
      SharedPreferences.getInstance();
}

@module
abstract class FirebaseModule {
  @singleton
  @preResolve
  Future<FirebaseMessaging> get firebaseMessaging async {
    var messaging = FirebaseMessaging.instance;
    var token = await messaging.getToken();
    logger.i('FirebaseMessaging token: $token');

    // handle background messages
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // @todo - uncomment this when intercom is ready
    // if (token != null) Intercom.instance.sendTokenToIntercom(token);

    return messaging;
  }

  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
}

// background message handler for firebase messaging
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  final data = message.data;
  logger.d('Handling a background message: $data');

  // @todo - uncomment this when intercom is ready
  // if (await Intercom.isIntercomPush(data)) {
  //   await Intercom.handlePush(data);
  //   return;
  // }

  // Here you can handle your own background messages
}
