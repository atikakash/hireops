import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../features/dashboard/domain/entities/dashboard_entity.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../providers/activity_providers.dart';

class ActivityLogScreen extends HookConsumerWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = useState<ActivityType?>(null);
    final activityAsync = ref.watch(activityLogProvider);

    final filters = [
      (null, 'All', Icons.list_outlined),
      (ActivityType.cvUploaded, 'CV Upload', Icons.upload_file_outlined),
      (ActivityType.stageMoved, 'Stage Move', Icons.swap_horiz_rounded),
      (ActivityType.noteAdded, 'Notes', Icons.sticky_note_2_outlined),
      (ActivityType.candidateAdded, 'New Candidate', Icons.person_add_outlined),
      (ActivityType.jobCreated, 'Jobs', Icons.add_business_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.activityLog),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.invalidate(activityLogProvider),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // â”€â”€ Filter Chips â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (type, label, icon) = filters[i];
                final isSelected = selectedType.value == type;
                return FilterChip(
                  avatar: Icon(icon, size: 14),
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => selectedType.value = type,
                  selectedColor: AppColors.primaryContainer,
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.primary : null,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              },
            ),
          ),

          // â”€â”€ Timeline â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(activityLogProvider),
              child: activityAsync.when(
                loading: () => ListView.builder(
                  itemCount: 8,
                  itemBuilder: (_, __) => const ShimmerListTile(),
                ),
                error: (e, _) => ErrorState(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(activityLogProvider),
                ),
                data: (items) {
                  final filtered = selectedType.value == null
                      ? items
                      : items
                          .where((a) => a.type == selectedType.value)
                          .toList();

                  if (filtered.isEmpty) {
                    return const EmptyState(
                      icon: Icons.history_toggle_off_outlined,
                      title: AppStrings.noActivity,
                      subtitle: 'No activity matches the selected filter.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      final isLast = i == filtered.length - 1;
                      final showDate = i == 0 ||
                          !_sameDay(filtered[i - 1].createdAt, item.createdAt);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date separator
                          if (showDate)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    _dayLabel(item.createdAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.4),
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Divider(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Timeline item
                          _TimelineActivityItem(
                            item: item,
                            isLast: isLast,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dayLabel(DateTime dt) {
    final now = DateTime.now();
    if (_sameDay(dt, now)) return 'TODAY';
    if (_sameDay(dt, now.subtract(const Duration(days: 1)))) {
      return 'YESTERDAY';
    }
    return AppDateFormatter.date(dt).toUpperCase();
  }
}

// â”€â”€ Timeline Activity Item â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TimelineActivityItem extends StatelessWidget {
  final RecentActivityItem item;
  final bool isLast;

  const _TimelineActivityItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _activityMeta(item.type);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline spine
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.15),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: item.actorName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: '  ${item.action}'),
                          if (item.targetName != null)
                            TextSpan(
                              text: '  ${item.targetName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _typeLabel(item.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          AppDateFormatter.timeAgo(item.createdAt),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _activityMeta(ActivityType type) => switch (type) {
        ActivityType.cvUploaded => (
            Icons.upload_file_outlined,
            AppColors.primary
          ),
        ActivityType.stageMoved => (
            Icons.swap_horiz_rounded,
            AppColors.warning
          ),
        ActivityType.noteAdded => (
            Icons.sticky_note_2_outlined,
            AppColors.secondary
          ),
        ActivityType.jobAssigned => (
            Icons.work_outline,
            AppColors.primaryLight
          ),
        ActivityType.candidateAdded => (
            Icons.person_add_outlined,
            AppColors.success
          ),
        ActivityType.jobCreated => (
            Icons.add_business_outlined,
            AppColors.stageInterview
          ),
      };

  String _typeLabel(ActivityType type) => switch (type) {
        ActivityType.cvUploaded => 'CV Upload',
        ActivityType.stageMoved => 'Stage Move',
        ActivityType.noteAdded => 'Note',
        ActivityType.jobAssigned => 'Job Assigned',
        ActivityType.candidateAdded => 'New Candidate',
        ActivityType.jobCreated => 'New Job',
      };
}
