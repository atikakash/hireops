import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_theme.dart';

/// Shown when go_router encounters an unmatched route.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '404',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 72,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'The screen you\'re looking for doesn\'t exist.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown inside screens when an async operation fails at the widget level.
class FullPageError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const FullPageError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off_outlined,
                    color: AppColors.error, size: 38),
              ),
              const SizedBox(height: 20),
              Text('Failed to load',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                    ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 28),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
