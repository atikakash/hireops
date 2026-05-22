import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notification_providers.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);
    final settingsNotifier =
        ref.read(notificationSettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: [
          TextButton(
            onPressed: () => settingsNotifier.markAllRead(),
            child: const Text('Mark all read', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationListProvider),
        child: notificationsAsync.when(
          loading: () => ListView.builder(
            itemCount: 6,
            itemBuilder: (_, __) => const ShimmerListTile(),
          ),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(notificationListProvider),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return const EmptyState(
                icon: Icons.notifications_none_outlined,
                title: AppStrings.noNotifications,
                subtitle: 'You\'re up to date â€” no new alerts.',
              );
            }

            final unread = notifications.where((n) => !n.isRead).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (unread > 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$unread unread',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: notifications.length,
                    itemBuilder: (_, i) =>
                        _NotificationTile(notification: notifications[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconAndColor(notification.type);
    final container = ProviderScope.containerOf(context, listen: false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Theme.of(context).colorScheme.surface
            : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notification.isRead
              ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          notification.title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight:
                    notification.isRead ? FontWeight.w500 : FontWeight.w700,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              notification.body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              AppDateFormatter.timeAgo(notification.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.35),
                    fontSize: 10,
                  ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          if (!notification.isRead) {
            container
                .read(notificationSettingsNotifierProvider.notifier)
                .markRead(notification.id);
          }
          if (notification.candidateId != null) {
            context.push('/candidates/${notification.candidateId}');
          } else if (notification.jobId != null) {
            context.push('/jobs/${notification.jobId}');
          }
        },
      ),
    );
  }

  (IconData, Color) _iconAndColor(NotificationType type) => switch (type) {
        NotificationType.cvUploaded => (
            Icons.upload_file_outlined,
            AppColors.primary
          ),
        NotificationType.stageMoved => (
            Icons.swap_horiz_rounded,
            AppColors.warning
          ),
        NotificationType.jobAssigned => (
            Icons.work_outline,
            AppColors.stageShortlisted
          ),
        NotificationType.system => (Icons.info_outline, AppColors.stageApplied),
      };
}
