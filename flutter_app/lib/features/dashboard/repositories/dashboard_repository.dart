import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final _client = ApiClient().dio;

  Future<DashboardData> getDashboard() async {
    try {
      final response = await _client.get('/dashboard');
      return DashboardData.fromJson(response.data['data']);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to load dashboard.';
      throw DashboardException(message: message);
    }
  }
}

class DashboardException implements Exception {
  final String message;
  const DashboardException({required this.message});
}
