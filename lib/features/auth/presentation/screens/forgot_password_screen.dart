import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../providers/auth_providers.dart';

enum _ForgotStep { email, reset, done }

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(_ForgotStep.email);
    final emailCtrl = useTextEditingController();
    final otpCtrl = useTextEditingController();
    final newPasswordCtrl = useTextEditingController();
    final confirmCtrl = useTextEditingController();

    final emailFormKey = useMemoized(() => GlobalKey<FormState>());
    final resetFormKey = useMemoized(() => GlobalKey<FormState>());

    final authState = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    Future<void> onSendOtp() async {
      if (!emailFormKey.currentState!.validate()) {
        return;
      }

      FocusScope.of(context).unfocus();
      notifier.clearMessages();

      final ok = await notifier.forgotPassword(email: emailCtrl.text.trim());
      if (ok) {
        step.value = _ForgotStep.reset;
      }
    }

    Future<void> onResetPassword() async {
      if (!resetFormKey.currentState!.validate()) {
        return;
      }

      FocusScope.of(context).unfocus();
      notifier.clearMessages();

      final ok = await notifier.resetPassword(
        email: emailCtrl.text.trim(),
        otp: otpCtrl.text.trim(),
        newPassword: newPasswordCtrl.text,
      );

      if (ok) {
        step.value = _ForgotStep.done;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            if (step.value == _ForgotStep.email) {
              context.pop();
            } else if (step.value == _ForgotStep.reset) {
              step.value = _ForgotStep.email;
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
        title: const Text(AppStrings.resetPassword),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (step.value) {
              _ForgotStep.email => _EmailStep(
                  key: const ValueKey('email-step'),
                  formKey: emailFormKey,
                  emailCtrl: emailCtrl,
                  isLoading: authState.isLoading,
                  errorMessage: authState.errorMessage,
                  successMessage: authState.successMessage,
                  onClearMessages: notifier.clearMessages,
                  onNext: onSendOtp,
                ),
              _ForgotStep.reset => _ResetStep(
                  key: const ValueKey('reset-step'),
                  email: emailCtrl.text.trim(),
                  formKey: resetFormKey,
                  otpCtrl: otpCtrl,
                  newPasswordCtrl: newPasswordCtrl,
                  confirmCtrl: confirmCtrl,
                  isLoading: authState.isLoading,
                  errorMessage: authState.errorMessage,
                  successMessage: authState.successMessage,
                  onClearMessages: notifier.clearMessages,
                  onReset: onResetPassword,
                  onResend: onSendOtp,
                ),
              _ForgotStep.done => _DoneStep(
                  key: const ValueKey('done-step'),
                  successMessage: authState.successMessage,
                  onGoToLogin: () => context.go(AppRoutes.login),
                ),
            },
          ),
        ),
      ),
    );
  }
}

class _EmailStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final VoidCallback onClearMessages;
  final VoidCallback onNext;

  const _EmailStep({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.isLoading,
    required this.errorMessage,
    required this.successMessage,
    required this.onClearMessages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepIcon(
              icon: Icons.mail_lock_outlined, color: AppColors.primary),
          const SizedBox(height: 24),
          Text(
            'Forgot your password?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your email and we'll send you a 6-digit OTP.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 28),
          if (errorMessage != null)
            ErrorBanner(message: errorMessage!, onDismiss: onClearMessages),
          if (successMessage != null) SuccessBanner(message: successMessage!),
          AppTextField(
            label: AppStrings.email,
            hint: 'you@company.com',
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline, size: 20),
            validator: AppValidators.email,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onNext(),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: AppStrings.sendOtp,
            isLoading: isLoading,
            onPressed: onNext,
            icon: Icons.send_outlined,
          ),
        ],
      ),
    );
  }
}

class _ResetStep extends StatelessWidget {
  final String email;
  final GlobalKey<FormState> formKey;
  final TextEditingController otpCtrl;
  final TextEditingController newPasswordCtrl;
  final TextEditingController confirmCtrl;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final VoidCallback onClearMessages;
  final VoidCallback onReset;
  final VoidCallback onResend;

  const _ResetStep({
    super.key,
    required this.email,
    required this.formKey,
    required this.otpCtrl,
    required this.newPasswordCtrl,
    required this.confirmCtrl,
    required this.isLoading,
    required this.errorMessage,
    required this.successMessage,
    required this.onClearMessages,
    required this.onReset,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepIcon(
              icon: Icons.lock_reset_outlined, color: AppColors.warning),
          const SizedBox(height: 24),
          Text(
            'Enter OTP and new password',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Use the OTP sent to $email to reset your password.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 28),
          if (errorMessage != null)
            ErrorBanner(message: errorMessage!, onDismiss: onClearMessages),
          if (successMessage != null) SuccessBanner(message: successMessage!),
          AppTextField(
            label: '6-Digit OTP',
            hint: '123456',
            controller: otpCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            prefixIcon: const Icon(Icons.pin_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().length != 6) {
                return 'Enter the 6-digit OTP.';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'New Password',
            controller: newPasswordCtrl,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            validator: AppValidators.password,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Confirm New Password',
            controller: confirmCtrl,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value != newPasswordCtrl.text) {
                return AppStrings.passwordMismatch;
              }
              return AppValidators.required(value, label: 'Confirmation');
            },
            onSubmitted: (_) => onReset(),
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: AppStrings.resetPassword,
            isLoading: isLoading,
            onPressed: onReset,
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Resend OTP'),
              onPressed: isLoading ? null : onResend,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  final String? successMessage;
  final VoidCallback onGoToLogin;

  const _DoneStep({
    super.key,
    required this.successMessage,
    required this.onGoToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.successContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Password reset!',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          successMessage ??
              'Your password has been updated. You can now sign in with your new password.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.55),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        PrimaryButton(
          label: 'Back to Sign In',
          onPressed: onGoToLogin,
          icon: Icons.login_rounded,
        ),
      ],
    );
  }
}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _StepIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
