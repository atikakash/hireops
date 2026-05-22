import 'token_storage.dart';

class _InMemoryTokenStore implements PlatformTokenStore {
  final Map<String, String> _storage = <String, String>{};

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    _storage[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => _storage[key];

  @override
  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }
}

PlatformTokenStore createPlatformTokenStore() => _InMemoryTokenStore();
