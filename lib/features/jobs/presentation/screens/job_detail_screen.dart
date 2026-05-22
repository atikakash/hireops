import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../candidates/presentation/providers/candidate_providers.dart';
import '../../domain/entities/job_entity.dart';
import '../providers/job_providers.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobDetailProvider(jobId));
    final formState = ref.watch(jobFormNotifierProvider);

    return Scaffold(
      body: jobAsync.when(
        loading: () => const _DetailShimmer(),
        error: (e, _) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(jobDetailProvider(jobId)),
        ),
        data: (job) => _DetailBody(job: job, formState: formState, ref: ref),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final JobEntity job;
  final JobFormState formState;
  final WidgetRef ref;

  const _DetailBody(
      {required this.job, required this.formState, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isOpen = job.status == JobStatus.open;

    Future<void> toggle() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => _JobStatusDialog(isOpen: isOpen),
      );
      if (confirmed == true) {
        final ok = await ref
            .read(jobFormNotifierProvider.notifier)
            .toggleStatus(job.id);
        if (!context.mounted) return;

        final message = ok
            ? (isOpen ? 'Job closed.' : 'Job reopened.')
            : (ref.read(jobFormNotifierProvider).errorMessage ??
                'Could not update job status.');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isOpen
                      ? [AppColors.primaryDark, AppColors.primary]
                      : [const Color(0xFF475569), const Color(0xFF64748B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.department,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: () => context.push('/jobs/${job.id}/edit'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta row
                Row(
                  children: [
                    _MetaBadge(
                        icon: Icons.people_outline,
                        label: '${job.candidateCount} candidates'),
                    const SizedBox(width: 10),
                    _MetaBadge(
                        icon: Icons.calendar_today_outlined,
                        label: AppDateFormatter.date(job.openDate)),
                    const Spacer(),
                    // Status toggle
                    GestureDetector(
                      onTap: formState.isLoading ? null : toggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.errorContainer
                              : AppColors.successContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (formState.isLoading)
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              Icon(
                                isOpen
                                    ? Icons.lock_outline
                                    : Icons.lock_open_outlined,
                                size: 14,
                                color: isOpen
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                            const SizedBox(width: 6),
                            Text(
                              isOpen ? 'Close Job' : 'Reopen Job',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isOpen
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Description
                _Section(
                  title: 'Description',
                  child: Text(
                    job.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.75),
                        ),
                  ),
                ),

                const SizedBox(height: 16),

                // Candidates section
                _Section(
                  title: 'Assigned Candidates',
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.person_add_outlined, size: 16),
                    label: const Text('Assign'),
                    onPressed: () => _showAssignDialog(context, ref),
                  ),
                  child: job.assignedCandidateIds.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No candidates assigned yet.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.45),
                                    ),
                          ),
                        )
                      : Column(
                          children: job.assignedCandidateIds
                              .map((id) =>
                                  _AssignedCandidateTile(candidateId: id))
                              .toList(),
                        ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAssignDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssignCandidateSheet(jobId: job.id, ref: ref),
    );
  }
}

class _JobStatusDialog extends StatelessWidget {
  final bool isOpen;

  const _JobStatusDialog({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isClosing = isOpen;
    final actionColor = isClosing ? AppColors.error : AppColors.primary;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isClosing ? Icons.lock_outline : Icons.lock_open_outlined,
                    size: 20,
                    color: actionColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isClosing ? 'Close Job?' : 'Reopen Job?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isClosing
                    ? 'This job will no longer accept new candidates.'
                    : 'This job will be listed as open again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: actionColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(isClosing ? 'Close Job' : 'Reopen'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignedCandidateTile extends ConsumerWidget {
  final String candidateId;
  const _AssignedCandidateTile({required this.candidateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidateAsync = ref.watch(candidateDetailProvider(candidateId));
    return candidateAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: ShimmerBox(height: 48),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (c) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryContainer,
          child: Text(
            c.name[0].toUpperCase(),
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ),
        title:
            Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(c.email),
        trailing: Icon(Icons.chevron_right,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
        onTap: () => context.push('/candidates/$candidateId'),
      ),
    );
  }
}

class _AssignCandidateSheet extends ConsumerWidget {
  final String jobId;
  final WidgetRef ref;

  const _AssignCandidateSheet({required this.jobId, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidatesAsync = ref.watch(candidateListProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assign Candidate',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: candidatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorState(message: e.toString()),
              data: (candidates) => ListView.builder(
                itemCount: candidates.length,
                itemBuilder: (_, i) {
                  final c = candidates[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(c.name[0],
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ),
                    title: Text(c.name),
                    subtitle: Text(c.email),
                    onTap: () async {
                      final ok = await ref
                          .read(jobFormNotifierProvider.notifier)
                          .assignCandidate(jobId, c.id);
                      if (ok && context.mounted) {
                        Navigator.pop(context);
                      }
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
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 14,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 5),
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                )),
      ],
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();
  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(slivers: [
      SliverAppBar(expandedHeight: 160, pinned: true),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            ShimmerBox(height: 48),
            SizedBox(height: 12),
            ShimmerBox(height: 120),
            SizedBox(height: 12),
            ShimmerBox(height: 160),
          ]),
        ),
      ),
    ]);
  }
}
