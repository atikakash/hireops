import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hireops/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hireops/features/auth/domain/entities/auth_entity.dart';
import 'package:hireops/features/auth/domain/repositories/auth_repository.dart';
import 'package:hireops/features/auth/domain/usecases/auth_usecases.dart';
import 'package:hireops/shared/providers/auth_state_provider.dart';
import 'package:hireops/shared/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';
part 'auth_providers.freezed.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioClientProvider));
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    dataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
}

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase registerUseCase(Ref ref) =>
    RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
VerifyEmailUseCase verifyEmailUseCase(Ref ref) =>
    VerifyEmailUseCase(ref.watch(authRepositoryProvider));

@riverpod
ResendVerificationUseCase resendVerificationUseCase(Ref ref) =>
    ResendVerificationUseCase(ref.watch(authRepositoryProvider));

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) =>
    ForgotPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) =>
    ResetPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));

@freezed
class AuthFormState with _$AuthFormState {
  const factory AuthFormState({
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
    AuthEntity? user,
    String? pendingVerificationEmail,
    String? debugOtp,
  }) = _AuthFormState;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthFormState build() => const AuthFormState();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(loginUseCaseProvider);
      final (entity, failure) = await useCase(email: email, password: password);

      if (failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      }

      state = state.copyWith(isLoading: false, user: entity);
      await ref.read(authStateProvider.notifier).setAuthenticated(true);
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.login failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Sign in failed. Please try again.',
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String companyName,
    String? companyEmail,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(registerUseCaseProvider);
      final (result, failure) = await useCase(
        name: name,
        email: email,
        password: password,
        companyName: companyName,
        companyEmail: companyEmail,
      );

      if (failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      }

      if (result?.requiresEmailVerification == true) {
        final debugOtp = result?.debugOtp;
        state = state.copyWith(
          isLoading: false,
          pendingVerificationEmail: result?.verificationEmail ?? email,
          debugOtp: debugOtp,
          successMessage: debugOtp == null || debugOtp.isEmpty
              ? 'We sent a verification code to your email.'
              : 'Verification code ready. Demo OTP: $debugOtp',
        );
        return false;
      }

      state = state.copyWith(isLoading: false, user: result?.auth);
      await ref.read(authStateProvider.notifier).setAuthenticated(true);
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.register failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Account creation failed. Please try again.',
      );
      return false;
    }
  }

  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(verifyEmailUseCaseProvider);
      final (entity, failure) = await useCase(email: email, otp: otp);

      if (failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        user: entity,
        pendingVerificationEmail: null,
        debugOtp: null,
      );
      await ref.read(authStateProvider.notifier).setAuthenticated(true);
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.verifyEmail failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email verification failed. Please try again.',
      );
      return false;
    }
  }

  Future<bool> resendVerification({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(resendVerificationUseCaseProvider);
      final (message, failure) = await useCase(email: email);

      if (failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        successMessage: message ?? 'Verification code sent.',
      );
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.resendVerification failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not resend verification code.',
      );
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(forgotPasswordUseCaseProvider);
      final (message, failure) = await useCase(email: email);

      if (failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        successMessage: message ?? 'OTP sent to your email.',
      );
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.forgotPassword failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not start password reset. Please try again.',
      );
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(resetPasswordUseCaseProvider);
      final (message, failure) = await useCase(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      if (failure != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        successMessage: message ?? 'Password reset successfully.',
      );
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.resetPassword failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not reset the password. Please try again.',
      );
      return false;
    }
  }

  Future<bool> logout() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    try {
      final useCase = ref.read(logoutUseCaseProvider);
      final (_, failure) = await useCase();

      await ref.read(authStateProvider.notifier).logout();

      state = state.copyWith(
        isLoading: false,
        user: null,
        errorMessage: failure?.message,
      );
      return true;
    } on Object catch (error, stackTrace) {
      debugPrint('AuthNotifier.logout failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await ref.read(authStateProvider.notifier).logout();
      state = state.copyWith(
        isLoading: false,
        user: null,
        errorMessage: null,
      );
      return true;
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

extension FailureMessage on Failure {
  String get message => when(
        network: (msg, _) => msg,
        unauthorized: (msg) => msg,
        forbidden: (msg) => msg,
        notFound: (msg) => msg,
        validation: (msg, _) => msg,
        server: (msg) => msg,
        cache: (msg) => msg,
        fileValidation: (msg) => msg,
        noInternet: (msg) => msg,
        unknown: (msg) => msg,
      );
}
