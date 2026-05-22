// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'app_config_storage.dart';

class _WebAppConfigStore implements PlatformAppConfigStore {
  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    html.window.localStorage[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return html.window.localStorage[key];
  }

  @override
  Future<void> delete({required String key}) async {
    html.window.localStorage.remove(key);
  }
}

PlatformAppConfigStore createPlatformAppConfigStore() => _WebAppConfigStore();
