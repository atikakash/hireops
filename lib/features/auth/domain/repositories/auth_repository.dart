import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/auth/domain/entities/auth_entity.dart';

abstract interface class AuthRepository {
  Future<(AuthEntity?, Failure?)> login({
    required String email,
    required String password,
  });

  Future<(AuthRegistrationResult?, Failure?)> register({
    required String name,
    required String email,
    required String password,
    required String companyName,
    String? companyEmail,
  });

  Future<(String?, Failure?)> forgotPassword({required String email});

  Future<(String?, Failure?)> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<(AuthEntity?, Failure?)> verifyEmail({
    required String email,
    required String otp,
  });

  Future<(String?, Failure?)> resendVerification({required String email});

  Future<(bool, Failure?)> logout();
}
