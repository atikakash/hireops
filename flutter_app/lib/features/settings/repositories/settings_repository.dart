import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/settings_model.dart';

class SettingsRepository {
  final _client = ApiClient().dio;

  /// GET /api/settings — all settings in one call
  Future<AllSettings> getAllSettings() async {
    try {
      final response = await _client.get('/settings');
      return AllSettings.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw SettingsException(e.response?.data?['message'] ?? 'Failed to load settings.');
    }
  }

  /// PUT /api/settings/company — Task 26
  Future<CompanySettings> updateCompany({
    required String name, required String email,
    String? phone, String? website, String? industry, String? address,
  }) async {
    try {
      final response = await _client.put('/settings/company', data: {
        'name': name, 'email': email,
        'phone': phone, 'website': website,
        'industry': industry, 'address': address,
      });
      return CompanySettings.fromJson(response.data['data']['company']);
    } on DioException catch (e) {
      final errors = e.response?.data?['errors'] as Map<String, dynamic>?;
      throw SettingsException(
        e.response?.data?['message'] ?? 'Failed to update company.',
        errors: errors,
      );
    }
  }

  /// PUT /api/settings/stages — Task 27
  Future<List<PipelineStageSetting>> renamePipelineStages(
      List<PipelineStageSetting> stages) async {
    try {
      final response = await _client.put('/settings/stages', data: {
        'stages': stages.map((s) => s.toJson()).toList(),
      });
      final List data = response.data['data']['stages'];
      return data.map((s) => PipelineStageSetting.fromJson(s)).toList();
    } on DioException catch (e) {
      throw SettingsException(e.response?.data?['message'] ?? 'Failed to update stages.');
    }
  }

  /// PUT /api/settings/notifications — Task 28
  Future<NotifSettings> updateNotifications(NotifSettings settings) async {
    try {
      final response = await _client.put('/settings/notifications',
          data: settings.toJson());
      return NotifSettings.fromJson(response.data['data']['notifications']);
    } on DioException catch (e) {
      throw SettingsException(e.response?.data?['message'] ?? 'Failed to update notifications.');
    }
  }
}

class SettingsException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  const SettingsException(this.message, {this.errors});
}
