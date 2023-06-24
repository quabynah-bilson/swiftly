import 'package:injectable/injectable.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPrefsPersistentStorage keys
const _kUserId = 'userId';
const _kToken = 'token';

/// An implementation of [BasePersistentStorage] using [SharedPreferences]
@Singleton(as: BasePersistentStorage)
final class SharedPrefsPersistentStorage extends BasePersistentStorage {
  const SharedPrefsPersistentStorage(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<void> clear() async {
    await prefs.remove(_kUserId);
    await prefs.remove(_kToken);
  }

  @override
  Future<String?> getUserId() async => prefs.getString(_kUserId);

  @override
  Future<String?> getUserToken() async => prefs.getString(_kToken);

  @override
  Future<void> saveUserId(String userId) async =>
      prefs.setString(_kUserId, userId);

  @override
  Future<void> saveUserToken(String token) async =>
      prefs.setString(_kToken, token);
}
