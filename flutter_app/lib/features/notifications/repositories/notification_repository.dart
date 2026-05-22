import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/notification_settings_model.dart';

class NotificationRepository {
  final _client = ApiClient().dio;

  Future<NotificationSettings> getSettings() async {
    try {
      final response = await _client.get('/notifications/settings');
      return NotificationSettings.fromJson(response.data['data']['settings']);
    } on DioException catch (e) {
      throw NotificationException(
          message: e.response?.data?['message'] ?? 'Failed to load settings.');
    }
  }

  Future<NotificationSettings> updateSettings(NotificationSettings settings) async {
    try {
      final response = await _client.put(
        '/notifications/settings',
        data: settings.toJson(),
      );
      return NotificationSettings.fromJson(response.data['data']['settings']);
    } on DioException catch (e) {
      throw NotificationException(
          message: e.response?.data?['message'] ?? 'Failed to update settings.');
    }
  }
}

class NotificationException implements Exception {
  final String message;
  const NotificationException({required this.message});
}
