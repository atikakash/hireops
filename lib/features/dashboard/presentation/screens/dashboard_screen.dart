import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/activity_feed_item.dart';
import '../widgets/pipeline_bar_chart.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final activityAsync = ref.watch(recentActivityFeedProvider);
    final showCombinedError = statsAsync.hasError && activityAsync.hasError;
    final combinedError =
        statsAsync.asError?.error ?? activityAsync.asError?.error;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardStatsProvider);
          ref.invalidate(recentActivityFeedProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    _greeting(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push(AppRoutes.notifications),
                  tooltip: AppStrings.notifications,
                ),
                const SizedBox(width: 4),
              ],
            ),
            if (showCombinedError)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorState(
                  message: combinedError.toString(),
                  onRetry: () {
                    ref.invalidate(dashboardStatsProvider);
                    ref.invalidate(recentActivityFeedProvider);
                  },
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      statsAsync.when(
                        loading: () => const _StatsShimmer(),
                        error: (e, _) => ErrorState(
                          message: e.toString(),
                          onRetry: () => ref.invalidate(dashboardStatsProvider),
                        ),
                        data: (stats) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.4,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                StatCard(
                                  label: AppStrings.totalCandidates,
                                  value: '${stats.totalCandidates}',
                                  icon: Icons.people_outline,
                                  color: AppColors.primary,
                                  trend: '+12%',
                                  onTap: () => context.go(AppRoutes.candidates),
                                ),
                                StatCard(
                                  label: AppStrings.activeJobs,
                                  value: '${stats.activeJobs}',
                                  icon: Icons.work_outline,
                                  color: AppColors.stageInterview,
                                  trend: '+3',
                                  onTap: () => context.go(AppRoutes.jobs),
                                ),
                                StatCard(
                                  label: 'Total Hired',
                                  value: '${stats.totalHired}',
                                  icon: Icons.check_circle_outline,
                                  color: AppColors.success,
                                ),
                                StatCard(
                                  label: 'Rejected',
                                  value: '${stats.totalRejected}',
                                  icon: Icons.cancel_outlined,
                                  color: AppColors.stageRejected,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const _SectionHeader(
                              title: AppStrings.candidatesPerStage,
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.pipeline),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: PipelineBarChart(
                                  data: stats.candidatesPerStage,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const _SectionHeader(
                              title: AppStrings.quickActions,
                            ),
                            const SizedBox(height: 12),
                            _QuickActionsRow(),
                            const SizedBox(height: 24),
                            _SectionHeader(
                              title: AppStrings.recentActivity,
                              actionLabel: 'See all',
                              onAction: () => context.go(AppRoutes.activity),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              activityAsync.when(
                loading: () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const ShimmerListTile(),
                    childCount: 5,
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: ErrorState(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(recentActivityFeedProvider),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.history_outlined,
                        title: AppStrings.noActivity,
                        subtitle:
                            'Actions will appear here as your team works.',
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == items.length) {
                          return const SizedBox(height: 24);
                        }
                        return ActivityFeedItem(item: items[index]);
                      },
                      childCount: items.length + 1,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 🌙';
  }
}

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        icon: Icons.upload_file_outlined,
        label: AppStrings.uploadCv,
        color: AppColors.primary,
        route: AppRoutes.cvUpload,
      ),
      (
        icon: Icons.add_business_outlined,
        label: AppStrings.addJob,
        color: AppColors.stageInterview,
        route: '/jobs/add',
      ),
      (
        icon: Icons.people_outline,
        label: AppStrings.viewCandidates,
        color: AppColors.success,
        route: AppRoutes.candidates,
      ),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: GestureDetector(
            onTap: () => context.push(a.route),
            child: Container(
              margin: EdgeInsets.only(
                right: actions.indexOf(a) < actions.length - 1 ? 10 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: a.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: a.color.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Icon(a.icon, color: a.color, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    a.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: a.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13)),
          ),
      ],
    );
  }
}

class _StatsShimmer extends StatelessWidget {
  const _StatsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(4, (_) => const ShimmerStatCard()),
        ),
      ],
    );
  }
}
