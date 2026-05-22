import 'package:dio/dio.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/auth/data/models/auth_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
    required String companyName,
    required String companyEmail,
    String? companyPhone,
    String? companyWebsite,
    String? companyIndustry,
    String? companyAddress,
  });
  Future<Map<String, dynamic>> forgotPassword({required String email});
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSourceImpl(this._dioClient);

  Dio get _dio => _dioClient.client;

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    return AuthModel.fromApiJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
    required String companyName,
    required String companyEmail,
    String? companyPhone,
    String? companyWebsite,
    String? companyIndustry,
    String? companyAddress,
  }) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'company_name': companyName,
        'company_email': companyEmail,
        'company_phone': companyPhone,
        'company_website': companyWebsite,
        'company_industry': companyIndustry,
        'company_address': companyAddress,
      },
    );

    return AuthModel.fromApiJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final response = await _dio.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      ApiConstants.resetPassword,
      data: {'email': email, 'otp': otp, 'password': newPassword},
    );

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }
}
