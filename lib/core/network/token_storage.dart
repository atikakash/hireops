import 'token_storage_impl_stub.dart'
    if (dart.library.io) 'token_storage_native_impl.dart'
    if (dart.library.html) 'token_storage_web_impl.dart';

abstract class PlatformTokenStore {
  Future<void> write({
    required String key,
    required String value,
  });

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

/// Persists JWT access + refresh tokens using a platform-appropriate store.
///
/// Web uses `localStorage` for predictable localhost behavior in demo mode,
/// while native platforms keep using secure storage.
class TokenStorage {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  final PlatformTokenStore _store;

  TokenStorage({PlatformTokenStore? store})
      : _store = store ?? createPlatformTokenStore();

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final writes = <Future<void>>[
      _store.write(key: _kAccessToken, value: accessToken),
    ];

    if (refreshToken == null || refreshToken.isEmpty) {
      writes.add(_store.delete(key: _kRefreshToken));
    } else {
      writes.add(_store.write(key: _kRefreshToken, value: refreshToken));
    }

    await Future.wait(writes);
  }

  Future<String?> getAccessToken() => _store.read(key: _kAccessToken);

  Future<String?> getRefreshToken() => _store.read(key: _kRefreshToken);

  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _store.delete(key: _kAccessToken),
      _store.delete(key: _kRefreshToken),
    ]);
  }
}
