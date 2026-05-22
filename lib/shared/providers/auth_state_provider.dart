import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core_providers.dart';

part 'auth_state_provider.g.dart';

/// Emits [true] if a valid access token exists, [false] otherwise.
/// The router watches this to redirect between auth and app routes.
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  Future<bool> build() async {
    final storage = ref.read(tokenStorageProvider);
    return storage.hasToken();
  }

  Future<void> setAuthenticated(bool value) async {
    state = AsyncData(value);
  }

  Future<void> logout() async {
    final storage = ref.read(tokenStorageProvider);
    await storage.clearTokens();
    state = const AsyncData(false);
  }
}
