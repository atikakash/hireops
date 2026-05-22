import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/auth/domain/entities/auth_entity.dart';
import 'package:hireops/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<(AuthEntity?, Failure?)> call({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);
}

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<(AuthEntity?, Failure?)> call({
    required String name,
    required String email,
    required String password,
    required String companyName,
    String? companyEmail,
  }) =>
      _repository.register(
        name: name,
        email: email,
        password: password,
        companyName: companyName,
        companyEmail: companyEmail,
      );
}

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  const ForgotPasswordUseCase(this._repository);

  Future<(String?, Failure?)> call({required String email}) =>
      _repository.forgotPassword(email: email);
}

class ResetPasswordUseCase {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);

  Future<(String?, Failure?)> call({
    required String email,
    required String otp,
    required String newPassword,
  }) =>
      _repository.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
}

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<(bool, Failure?)> call() => _repository.logout();
}
