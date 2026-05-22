import 'app_config_storage.dart';

class _InMemoryAppConfigStore implements PlatformAppConfigStore {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    _values[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return _values[key];
  }

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }
}

PlatformAppConfigStore createPlatformAppConfigStore() =>
    _InMemoryAppConfigStore();
