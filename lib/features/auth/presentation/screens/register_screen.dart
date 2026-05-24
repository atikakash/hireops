import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameCtrl = useTextEditingController();
    final companyCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmCtrl = useTextEditingController();
    final otpCtrl = useTextEditingController();

    final authState = ref.watch(authNotifierProvider);

    Future<void> onRegister() async {
      if (!formKey.currentState!.validate()) return;
      FocusScope.of(context).unfocus();
      ref.read(authNotifierProvider.notifier).clearMessages();

      final success = await ref.read(authNotifierProvider.notifier).register(
            name: nameCtrl.text.trim(),
            email: emailCtrl.text.trim(),
            password: passwordCtrl.text,
            companyName: companyCtrl.text.trim(),
          );

      if (success && context.mounted) {
        context.go(AppRoutes.dashboard);
      }
    }

    Future<void> onVerifyEmail() async {
      final email = authState.pendingVerificationEmail;
      if (email == null) return;
      if (otpCtrl.text.trim().length != 6) {
        ref.read(authNotifierProvider.notifier).clearMessages();
        return;
      }

      FocusScope.of(context).unfocus();
      final success = await ref.read(authNotifierProvider.notifier).verifyEmail(
            email: email,
            otp: otpCtrl.text.trim(),
          );

      if (success && context.mounted) {
        context.go(AppRoutes.dashboard);
      }
    }

    Future<void> onResendVerification() async {
      final email = authState.pendingVerificationEmail;
      if (email == null) return;
      FocusScope.of(context).unfocus();
      await ref
          .read(authNotifierProvider.notifier)
          .resendVerification(email: email);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 24),

                const Center(child: AppLogo(size: 58)),
                const SizedBox(height: 28),

                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Set up your company workspace',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                ),
                const SizedBox(height: 28),

                if (authState.pendingVerificationEmail != null)
                  _VerifyEmailStep(
                    email: authState.pendingVerificationEmail!,
                    otpCtrl: otpCtrl,
                    isLoading: authState.isLoading,
                    errorMessage: authState.errorMessage,
                    successMessage: authState.successMessage,
                    onClearMessages: () =>
                        ref.read(authNotifierProvider.notifier).clearMessages(),
                    onVerify: onVerifyEmail,
                    onResend: onResendVerification,
                  )
                else ...[
                  // Error
                  if (authState.errorMessage != null)
                    ErrorBanner(
                      message: authState.errorMessage!,
                      onDismiss: () => ref
                          .read(authNotifierProvider.notifier)
                          .clearMessages(),
                    ),

                  // Step label
                  const _StepLabel(step: 1, label: 'Your details'),
                  const SizedBox(height: 12),

                  AppTextField(
                    label: AppStrings.fullName,
                    hint: 'Jane Smith',
                    controller: nameCtrl,
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    validator: (v) =>
                        AppValidators.required(v, label: 'Full name'),
                  ),
                  const SizedBox(height: 14),

                  AppTextField(
                    label: AppStrings.email,
                    hint: 'jane@company.com',
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.mail_outline, size: 20),
                    validator: AppValidators.email,
                  ),
                  const SizedBox(height: 20),

                  const _StepLabel(step: 2, label: 'Your company'),
                  const SizedBox(height: 12),

                  AppTextField(
                    label: AppStrings.companyName,
                    hint: 'Acme Corp',
                    controller: companyCtrl,
                    prefixIcon: const Icon(Icons.business_outlined, size: 20),
                    validator: (v) =>
                        AppValidators.required(v, label: 'Company name'),
                  ),
                  const SizedBox(height: 20),

                  const _StepLabel(step: 3, label: 'Secure your account'),
                  const SizedBox(height: 12),

                  AppTextField(
                    label: AppStrings.password,
                    controller: passwordCtrl,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    validator: AppValidators.password,
                  ),
                  const SizedBox(height: 14),

                  AppTextField(
                    label: AppStrings.confirmPassword,
                    controller: confirmCtrl,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onRegister(),
                    validator: (v) {
                      if (v != passwordCtrl.text) {
                        return AppStrings.passwordMismatch;
                      }
                      return AppValidators.required(v, label: 'Confirmation');
                    },
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: 'Create Account',
                    isLoading: authState.isLoading,
                    onPressed: onRegister,
                    icon: Icons.rocket_launch_outlined,
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppStrings.alreadyHaveAccount,
                            style: Theme.of(context).textTheme.bodyMedium),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            AppStrings.signIn,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Terms note
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'By creating an account you agree to our Terms of Service.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerifyEmailStep extends StatelessWidget {
  final String email;
  final TextEditingController otpCtrl;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final VoidCallback onClearMessages;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  const _VerifyEmailStep({
    required this.email,
    required this.otpCtrl,
    required this.isLoading,
    required this.errorMessage,
    required this.successMessage,
    required this.onClearMessages,
    required this.onVerify,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorMessage != null)
          ErrorBanner(message: errorMessage!, onDismiss: onClearMessages),
        if (successMessage != null) SuccessBanner(message: successMessage!),
        const _StepLabel(step: 4, label: 'Verify your email'),
        const SizedBox(height: 12),
        Text(
          'Enter the 6-digit code sent to $email.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.58),
              ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Verification Code',
          hint: '123456',
          controller: otpCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          prefixIcon: const Icon(Icons.pin_outlined, size: 20),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().length != 6) {
              return 'Enter the 6-digit code.';
            }
            return null;
          },
          onSubmitted: (_) => onVerify(),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Verify Email',
          isLoading: isLoading,
          onPressed: onVerify,
          icon: Icons.verified_outlined,
        ),
        const SizedBox(height: 14),
        Center(
          child: TextButton.icon(
            onPressed: isLoading ? null : onResend,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Resend code'),
          ),
        ),
      ],
    );
  }
}

class _StepLabel extends StatelessWidget {
  final int step;
  final String label;
  const _StepLabel({required this.step, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '$step',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
