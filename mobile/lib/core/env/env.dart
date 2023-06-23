import 'package:envied/envied.dart';

part 'env.g.dart';

// env class
@Envied(obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'INTERCOM_APP_ID')
  static final String kIntercomAppId = _Env.kIntercomAppId;

  @EnviedField(varName: 'INTERCOM_IOS_API_KEY')
  static final String kIntercomIosApiKey = _Env.kIntercomIosApiKey;

  @EnviedField(varName: 'INTERCOM_ANDROID_API_KEY')
  static final String kIntercomAndroidApiKey = _Env.kIntercomAndroidApiKey;
}
