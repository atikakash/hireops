import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../features/candidates/domain/entities/candidate_entity.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/pipeline_entity.dart';
import '../providers/pipeline_providers.dart';

class PipelineScreen extends ConsumerWidget {
  const PipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardAsync = ref.watch(pipelineBoardProvider);
    final moveState = ref.watch(pipelineMoveNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.pipeline),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () => ref.invalidate(pipelineBoardProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (moveState.errorMessage != null)
            Container(
              width: double.infinity,
              color: AppColors.errorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                moveState.errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),

          // Board
          Expanded(
            child: boardAsync.when(
              loading: () => const _BoardShimmer(),
              error: (e, _) => ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(pipelineBoardProvider),
              ),
              data: (stages) => _KanbanBoard(stages: stages),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Kanban Board â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _KanbanBoard extends StatelessWidget {
  final List<PipelineStageConfig> stages;

  const _KanbanBoard({required this.stages});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      itemCount: stages.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) => _KanbanColumn(
        config: stages[i],
        allStages: stages.map((s) => s.stage).toList(),
      ),
    );
  }
}

// â”€â”€ Kanban Column â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _KanbanColumn extends StatelessWidget {
  final PipelineStageConfig config;
  final List<PipelineStage> allStages;

  const _KanbanColumn({required this.config, required this.allStages});

  @override
  Widget build(BuildContext context) {
    final (headerColor, headerBg) = _columnColors(config.stage);

    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // â”€â”€ Column Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border.all(color: headerColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: headerColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    config.name,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: headerColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: headerColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${config.candidates.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: headerColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // â”€â”€ Cards â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.4),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(14)),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.15),
                ),
              ),
              child: config.candidates.isEmpty
                  ? Center(
                      child: Text(
                        'No candidates',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: config.candidates.length,
                      itemBuilder: (_, i) => _CandidateCard(
                        candidate: config.candidates[i],
                        currentStage: config.stage,
                        allStages: allStages,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _columnColors(PipelineStage stage) {
    return switch (stage) {
      PipelineStage.applied => (
          AppColors.stageApplied,
          AppColors.stageApplied.withValues(alpha: 0.08)
        ),
      PipelineStage.shortlisted => (
          AppColors.stageShortlisted,
          AppColors.stageShortlisted.withValues(alpha: 0.08)
        ),
      PipelineStage.interview => (
          AppColors.stageInterview,
          AppColors.stageInterview.withValues(alpha: 0.08)
        ),
      PipelineStage.hired => (
          AppColors.stageHired,
          AppColors.stageHired.withValues(alpha: 0.08)
        ),
      PipelineStage.rejected => (
          AppColors.stageRejected,
          AppColors.stageRejected.withValues(alpha: 0.08)
        ),
    };
  }
}

// â”€â”€ Candidate Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CandidateCard extends ConsumerWidget {
  final CandidateEntity candidate;
  final PipelineStage currentStage;
  final List<PipelineStage> allStages;

  const _CandidateCard({
    required this.candidate,
    required this.currentStage,
    required this.allStages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moveNotifier = ref.read(pipelineMoveNotifierProvider.notifier);
    final currentIdx = allStages.indexOf(currentStage);
    final canAdvance = currentIdx < allStages.length - 1;
    final canGoBack = currentIdx > 0;

    final initials = candidate.name
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w[0])
        .join()
        .toUpperCase();

    return GestureDetector(
      onTap: () => context.push('/candidates/${candidate.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    candidate.name,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Top skill
            if (candidate.skills.isNotEmpty)
              Text(
                candidate.skills.first,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),

            // Experience
            Text(
              '${candidate.experienceYears} yr${candidate.experienceYears == 1 ? '' : 's'} exp',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.45),
                  ),
            ),

            const SizedBox(height: 10),

            // Move buttons
            Row(
              children: [
                if (canGoBack)
                  _MoveButton(
                    icon: Icons.arrow_back_ios_new,
                    tooltip: 'Move back',
                    onTap: () => moveNotifier.move(
                      candidate.id,
                      allStages[currentIdx - 1],
                      context,
                    ),
                  ),
                const Spacer(),
                if (canAdvance)
                  _MoveButton(
                    icon: Icons.arrow_forward_ios,
                    tooltip: 'Move forward',
                    primary: true,
                    onTap: () => moveNotifier.move(
                      candidate.id,
                      allStages[currentIdx + 1],
                      context,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoveButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool primary;

  const _MoveButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primary
                ? AppColors.primary.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 12,
            color: primary
                ? AppColors.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Board Shimmer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _BoardShimmer extends StatelessWidget {
  const _BoardShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => SizedBox(
        width: 240,
        child: Column(
          children: [
            const ShimmerBox(height: 46, radius: 14),
            const SizedBox(height: 4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ShimmerBox(height: 100),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
