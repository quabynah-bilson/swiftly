import 'package:envied/envied.dart';

part 'env.g.dart';


// env class
@Envied(obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'GOOGLE_CLIENT_ID')
  static final String kGoogleClientID = _Env.kGoogleClientID;

  @EnviedField(varName: 'INTERCOM_APP_ID')
  static final String kIntercomAppId = _Env.kIntercomAppId;

  @EnviedField(varName: 'INTERCOM_IOS_API_KEY')
  static final String kIntercomIosApiKey = _Env.kIntercomIosApiKey;

  @EnviedField(varName: 'INTERCOM_ANDROID_API_KEY')
  static final String kIntercomAndroidApiKey = _Env.kIntercomAndroidApiKey;

  @EnviedField(varName: 'STRIPE_PUBLISHABLE_KEY')
  static final String kStripePublishableKey = _Env.kStripePublishableKey;

  @EnviedField(varName: 'STRIPE_SECRET_KEY')
  static final String kStripeSecretKey = _Env.kStripeSecretKey;
}
