import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:mobile/core/env/env.dart';
import 'package:mobile/features/common/data/models/user.dart';
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
    if (kIsWeb) return messaging;

    var token = defaultTargetPlatform == TargetPlatform.iOS
        ? await messaging.getAPNSToken()
        : await messaging.getToken();
    logger.i('FirebaseMessaging token: $token');

    // handle background messages
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // pass token to intercom
    if (token != null) await Intercom.instance.sendTokenToIntercom(token);

    return messaging;
  }

  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(clientId: Env.kGoogleClientID);

  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}

@module
abstract class HiveModule {
  @singleton
  @preResolve
  Future<Box<UserModel>> get userBox async =>
      await Hive.openBox<UserModel>('users');
}

@module
abstract class MessengerModule {
  @singleton
  Intercom get intercom => Intercom.instance;
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
