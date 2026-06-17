import 'app_config_storage_impl_stub.dart'
    if (dart.library.io) 'app_config_storage_native_impl.dart'
    if (dart.library.html) 'app_config_storage_web_impl.dart';

abstract class PlatformAppConfigStore {
  Future<void> write({
    required String key,
    required String value,
  });

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

class AppConfigStorage {
  static const _kApiBaseUrl = 'api_base_url';
  static const _kDashboardStats = 'dashboard_stats_cache';
  static const _kDashboardActivity = 'dashboard_activity_cache';

  final PlatformAppConfigStore _store;

  AppConfigStorage({PlatformAppConfigStore? store})
      : _store = store ?? createPlatformAppConfigStore();

  Future<void> saveApiBaseUrl(String value) {
    return _store.write(key: _kApiBaseUrl, value: value.trim());
  }

  Future<String?> getApiBaseUrl() async {
    final value = await _store.read(key: _kApiBaseUrl);
    if (value == null) {
      return null;
    }

    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  Future<void> clearApiBaseUrl() {
    return _store.delete(key: _kApiBaseUrl);
  }

  Future<void> saveDashboardStats(String value) {
    return _store.write(key: _kDashboardStats, value: value);
  }

  Future<String?> getDashboardStats() {
    return _store.read(key: _kDashboardStats);
  }

  Future<void> saveDashboardActivity(String value) {
    return _store.write(key: _kDashboardActivity, value: value);
  }

  Future<String?> getDashboardActivity() {
    return _store.read(key: _kDashboardActivity);
  }
}
