import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/app_config_storage.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/token_storage.dart';

part 'core_providers.g.dart';

final appConfigStorageProvider = Provider<AppConfigStorage>(
  (ref) => AppConfigStorage(),
);

class ApiBaseUrlNotifier extends Notifier<String> {
  @override
  String build() {
    unawaited(_loadStoredValue());
    return ApiConstants.baseUrl;
  }

  Future<void> save(String rawValue) async {
    final normalized = normalize(rawValue);
    await ref.read(appConfigStorageProvider).saveApiBaseUrl(normalized);
    state = normalized;
  }

  Future<void> reset() async {
    await ref.read(appConfigStorageProvider).clearApiBaseUrl();
    state = ApiConstants.baseUrl;
  }

  String normalize(String rawValue) {
    var normalized = rawValue.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  bool isValid(String rawValue) {
    if (rawValue.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(normalize(rawValue));
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.hasAuthority;
  }

  Future<void> _loadStoredValue() async {
    final stored = await ref.read(appConfigStorageProvider).getApiBaseUrl();
    if (stored == null || stored == state) {
      return;
    }

    if (ApiConstants.isLocalBaseUrl(stored) &&
        !ApiConstants.isLocalBaseUrl(ApiConstants.baseUrl)) {
      await ref.read(appConfigStorageProvider).clearApiBaseUrl();
      return;
    }

    state = stored;
  }
}

final apiBaseUrlProvider = NotifierProvider<ApiBaseUrlNotifier, String>(
  ApiBaseUrlNotifier.new,
);

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => TokenStorage();

@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  final storage = ref.watch(tokenStorageProvider);
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return DioClient(tokenStorage: storage, baseUrl: baseUrl);
}
