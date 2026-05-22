import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/providers/core_providers.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final emailFocus = useFocusNode();
    final passwordFocus = useFocusNode();

    final authState = ref.watch(authNotifierProvider);

    Future<void> onLogin() async {
      if (!formKey.currentState!.validate()) return;
      FocusScope.of(context).unfocus();
      ref.read(authNotifierProvider.notifier).clearMessages();

      final success = await ref.read(authNotifierProvider.notifier).login(
            email: emailCtrl.text.trim(),
            password: passwordCtrl.text,
          );

      if (success && context.mounted) {
        context.go(AppRoutes.dashboard);
      }
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
                const SizedBox(height: 56),
                const Center(child: AppLogo(size: 52, showTagline: true)),
                const SizedBox(height: 48),

                // Heading
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to your HireOps account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                ),
                const SizedBox(height: 32),

                // Error Banner
                if (authState.errorMessage != null)
                  ErrorBanner(
                    message: authState.errorMessage!,
                    onDismiss: () =>
                        ref.read(authNotifierProvider.notifier).clearMessages(),
                  ),

                // Email
                AppTextField(
                  label: AppStrings.email,
                  hint: 'you@company.com',
                  controller: emailCtrl,
                  focusNode: emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline, size: 20),
                  validator: AppValidators.email,
                  onSubmitted: (_) => passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 16),

                // Password
                AppTextField(
                  label: AppStrings.password,
                  controller: passwordCtrl,
                  focusNode: passwordFocus,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  validator: AppValidators.password,
                  onSubmitted: (_) => onLogin(),
                ),
                const SizedBox(height: 8),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Button
                PrimaryButton(
                  label: AppStrings.signIn,
                  isLoading: authState.isLoading,
                  onPressed: onLogin,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4),
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Register prompt
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.register),
                        child: Text(
                          AppStrings.signUp,
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
                const SizedBox(height: 32),

                // Demo hint
                _DemoCard(onTap: () {
                  emailCtrl.text = 'admin@hireops.io';
                  passwordCtrl.text = 'password123';
                }),
                const SizedBox(height: 16),
                const _ServerConfigCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final VoidCallback onTap;

  const _DemoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, color: AppColors.primaryDark),
                  children: [
                    TextSpan(text: 'Demo: '),
                    TextSpan(
                      text: 'admin@hireops.io',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' / '),
                    TextSpan(
                      text: 'password123',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: '  - tap to fill'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerConfigCard extends ConsumerWidget {
  const _ServerConfigCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiBaseUrl = ref.watch(apiBaseUrlProvider);

    Future<void> openServerDialog() async {
      final notifier = ref.read(apiBaseUrlProvider.notifier);
      final controller = TextEditingController(text: apiBaseUrl);
      var validationMessage = '';

      try {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) {
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text('Server URL'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter the backend URL your device should use. Example: http://192.168.1.104:3000',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.url,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'API base URL',
                        hintText: 'http://192.168.1.104:3000',
                        errorText: validationMessage.isEmpty
                            ? null
                            : validationMessage,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await notifier.reset();
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: const Text('Reset'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (!notifier.isValid(controller.text)) {
                        setState(() {
                          validationMessage =
                              'Use a full http:// or https:// URL.';
                        });
                        return;
                      }

                      await notifier.save(controller.text);
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      } finally {
        controller.dispose();
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.router_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Server URL',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              TextButton(
                onPressed: openServerDialog,
                child: const Text('Edit'),
              ),
            ],
          ),
          Text(
            apiBaseUrl,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'For a phone APK, use your PC LAN IP instead of localhost.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.58),
                ),
          ),
        ],
      ),
    );
  }
}
