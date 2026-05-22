import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/auth/domain/entities/auth_entity.dart';

abstract interface class AuthRepository {
  Future<(AuthEntity?, Failure?)> login({
    required String email,
    required String password,
  });

  Future<(AuthEntity?, Failure?)> register({
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

  Future<(bool, Failure?)> logout();
}
