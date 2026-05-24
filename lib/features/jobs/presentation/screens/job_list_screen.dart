import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/job_entity.dart';
import '../providers/job_providers.dart';

class JobListScreen extends HookConsumerWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final jobsAsync = ref.watch(jobListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.jobList),
        bottom: TabBar(
          controller: useTabController(initialLength: 2),
          onTap: (i) => tabIndex.value = i,
          tabs: const [Tab(text: 'All'), Tab(text: 'Open')],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(jobListProvider),
        child: jobsAsync.when(
          loading: () => ListView.builder(
            itemCount: 6,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ShimmerBox(height: 110),
            ),
          ),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(jobListProvider),
          ),
          data: (jobs) {
            final filtered = tabIndex.value == 1
                ? jobs.where((j) => j.status == JobStatus.open).toList()
                : jobs;

            if (filtered.isEmpty) {
              return EmptyState(
                icon: Icons.work_outline,
                title: AppStrings.noJobs,
                subtitle: 'Create your first job position to start hiring.',
                actionLabel: AppStrings.addJobPosition,
                onAction: () => context.push('/jobs/add'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: filtered.length,
              itemBuilder: (_, i) => _JobCard(job: filtered[i], ref: ref),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/jobs/add'),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addJobPosition),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobEntity job;
  final WidgetRef ref;

  const _JobCard({required this.job, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isOpen = job.status == JobStatus.open;

    return GestureDetector(
      onTap: () => context.push('/jobs/${job.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.outline.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Job icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOpen
                        ? AppColors.primaryContainer
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.work_outline,
                    color: isOpen
                        ? AppColors.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.35),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        job.department,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                _StatusBadge(status: job.status),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MetaItem(
                  icon: Icons.people_outline,
                  label:
                      '${job.candidateCount} candidate${job.candidateCount == 1 ? '' : 's'}',
                ),
                const SizedBox(width: 16),
                _MetaItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Opened ${AppDateFormatter.date(job.openDate)}',
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final JobStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status == JobStatus.open;
    final color = isOpen ? AppColors.success : AppColors.stageApplied;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            isOpen ? AppStrings.open : AppStrings.closed,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 13,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
        ),
      ],
    );
  }
}
