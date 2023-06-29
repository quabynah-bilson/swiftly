import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_utils/shared_utils.dart';

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
    var token = Platform.isIOS
        ? await messaging.getAPNSToken()
        : await messaging.getToken();
    logger.i('FirebaseMessaging token: $token');

    // handle background messages
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // pass token to intercom
    if (token != null) Intercom.instance.sendTokenToIntercom(token);

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

  // handle intercom push notifications
  if (await Intercom.instance.isIntercomPush(data)) {
    await Intercom.instance.handlePush(data);
    return;
  }

  // @todo -> Here you can handle your own background messages
}
