/// base class for persistent storage repository
abstract class BasePersistentStorage {
  const BasePersistentStorage();

  /// Save user unique id to persistent storage
  Future<void> saveUserId(String userId);

  /// Get user unique id from persistent storage
  Future<String?> getUserId();

  /// Save user token to persistent storage
  Future<void> saveUserToken(String token);

  /// Get user token from persistent storage
  Future<String?> getUserToken();

  /// Clear all values from persistent storage
  Future<void> clear();
}
