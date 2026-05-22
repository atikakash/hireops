import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/dashboard_entity.dart';

class ActivityFeedItem extends StatelessWidget {
  final RecentActivityItem item;

  const ActivityFeedItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconAndColor(item.type);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: item.actorName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${item.action}'),
                      if (item.targetName != null)
                        TextSpan(
                          text: ' ${item.targetName}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  AppDateFormatter.timeAgo(item.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.45),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _iconAndColor(ActivityType type) => switch (type) {
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
}
