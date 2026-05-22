import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/candidate_entity.dart';
import '../providers/candidate_providers.dart';
import '../widgets/stage_badge.dart';

class CandidateProfileScreen extends HookConsumerWidget {
  final String candidateId;

  const CandidateProfileScreen({super.key, required this.candidateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidateAsync = ref.watch(candidateDetailProvider(candidateId));
    final formState = ref.watch(candidateFormNotifierProvider);

    return Scaffold(
      body: candidateAsync.when(
        loading: () => const _ProfileShimmer(),
        error: (e, _) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(candidateDetailProvider(candidateId)),
        ),
        data: (candidate) => _ProfileBody(
          candidate: candidate,
          formState: formState,
          ref: ref,
        ),
      ),
    );
  }
}

// â”€â”€ Profile Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProfileBody extends HookWidget {
  final CandidateEntity candidate;
  final CandidateFormState formState;
  final WidgetRef ref;

  const _ProfileBody({
    required this.candidate,
    required this.formState,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final noteCtrl = useTextEditingController();
    final showNoteField = useState(false);

    Future<void> addNote() async {
      if (noteCtrl.text.trim().isEmpty) return;
      final ok = await ref
          .read(candidateFormNotifierProvider.notifier)
          .addNote(candidate.id, noteCtrl.text.trim());
      if (ok) {
        noteCtrl.clear();
        showNoteField.value = false;
      }
    }

    Future<void> deleteNote(String noteId) async {
      final confirmed = await _confirmDialog(
          context, 'Delete this note?', 'This cannot be undone.');
      if (!confirmed) return;
      await ref
          .read(candidateFormNotifierProvider.notifier)
          .deleteNote(candidate.id, noteId);
    }

    final initials = candidate.name
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w[0])
        .join()
        .toUpperCase();

    return CustomScrollView(
      slivers: [
        // â”€â”€ Hero App Bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: candidate.avatarUrl != null
                          ? NetworkImage(candidate.avatarUrl!)
                          : null,
                      child: candidate.avatarUrl == null
                          ? Text(
                              initials,
                              style: const TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      candidate.name,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    StageBadge(stage: candidate.currentStage, large: true),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: () => context.push('/candidates/${candidate.id}/edit'),
              tooltip: 'Edit',
            ),
            if (candidate.cvUrl != null)
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined,
                    color: Colors.white),
                tooltip: 'Preview CV',
                onPressed: () => context.push(
                  '${AppRoutes.cvPreview}?url=${Uri.encodeComponent(candidate.cvUrl!)}',
                ),
              ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error banner
                if (formState.errorMessage != null)
                  ErrorBanner(
                    message: formState.errorMessage!,
                    onDismiss: () => ref
                        .read(candidateFormNotifierProvider.notifier)
                        .clearError(),
                  ),

                // â”€â”€ Contact Details â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionCard(
                  title: 'Contact',
                  icon: Icons.contact_page_outlined,
                  child: Column(
                    children: [
                      _InfoRow(
                          icon: Icons.mail_outline,
                          label: 'Email',
                          value: candidate.email),
                      if (candidate.phone != null)
                        _InfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: candidate.phone!),
                      _InfoRow(
                          icon: Icons.work_history_outlined,
                          label: 'Experience',
                          value:
                              '${candidate.experienceYears} year${candidate.experienceYears == 1 ? '' : 's'}'),
                      if (candidate.jobTitle != null)
                        _InfoRow(
                            icon: Icons.business_center_outlined,
                            label: 'Applied Job',
                            value: candidate.jobTitle!),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // â”€â”€ Skills â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                if (candidate.skills.isNotEmpty)
                  _SectionCard(
                    title: 'Skills',
                    icon: Icons.psychology_outlined,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: candidate.skills
                          .map((s) => _SkillChip(skill: s))
                          .toList(),
                    ),
                  ),

                if (candidate.skills.isNotEmpty) const SizedBox(height: 12),

                // â”€â”€ Tags â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionCard(
                  title: 'Tags',
                  icon: Icons.label_outline,
                  child: candidate.tags.isEmpty
                      ? Text(
                          'No tags yet.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.45),
                                  ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: candidate.tags
                              .map((t) => _TagChip(tag: t))
                              .toList(),
                        ),
                ),

                const SizedBox(height: 12),

                // â”€â”€ CV Buttons â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                if (candidate.cvUrl != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text('Preview CV'),
                          onPressed: () => context.push(
                            '${AppRoutes.cvPreview}?url=${Uri.encodeComponent(candidate.cvUrl!)}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.download_outlined, size: 18),
                          label: const Text('Download CV'),
                          onPressed: () {/* trigger download */},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // â”€â”€ Notes â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionCard(
                  title: AppStrings.notes,
                  icon: Icons.sticky_note_2_outlined,
                  trailing: IconButton(
                    icon: Icon(
                      showNoteField.value ? Icons.close : Icons.add,
                      size: 20,
                    ),
                    onPressed: () => showNoteField.value = !showNoteField.value,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showNoteField.value) ...[
                        TextField(
                          controller: noteCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Write a note about this candidateâ€¦',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: formState.isLoading ? null : addNote,
                            child: formState.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Save Note'),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (candidate.notes.isEmpty && !showNoteField.value)
                        Text(
                          AppStrings.noNotes,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.45),
                                  ),
                        ),
                      ...candidate.notes.map(
                        (note) => _NoteCard(
                          note: note,
                          onDelete: () => deleteNote(note.id),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // â”€â”€ Stage History Timeline â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                if (candidate.stageHistory.isNotEmpty)
                  _SectionCard(
                    title: AppStrings.stageHistory,
                    icon: Icons.timeline_outlined,
                    child: Column(
                      children: candidate.stageHistory
                          .asMap()
                          .entries
                          .map((e) => _TimelineEntry(
                                entry: e.value,
                                isLast:
                                    e.key == candidate.stageHistory.length - 1,
                              ))
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

  Future<bool> _confirmDialog(
      BuildContext context, String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete')),
            ],
          ),
        ) ??
        false;
  }
}

// â”€â”€ Section Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

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
            children: [
              Icon(icon,
                  size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// â”€â”€ Info Row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4)),
          const SizedBox(width: 10),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Skill Chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _SkillChip extends StatelessWidget {
  final String skill;
  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

// â”€â”€ Tag Chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

// â”€â”€ Note Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _NoteCard extends StatelessWidget {
  final CandidateNote note;
  final VoidCallback onDelete;

  const _NoteCard({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.authorName,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Row(
                children: [
                  Text(
                    AppDateFormatter.timeAgo(note.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.4),
                        ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(note.content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// â”€â”€ Timeline Entry â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _TimelineEntry extends StatelessWidget {
  final StageHistoryEntry entry;
  final bool isLast;

  const _TimelineEntry({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = _stageColor(entry.stage);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line + dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.stage.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppDateFormatter.date(entry.movedAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by ${entry.movedByName}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                  ),
                  if (entry.note != null) ...[
                    const SizedBox(height: 4),
                    Text(entry.note!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _stageColor(PipelineStage s) => switch (s) {
        PipelineStage.applied => AppColors.stageApplied,
        PipelineStage.shortlisted => AppColors.stageShortlisted,
        PipelineStage.interview => AppColors.stageInterview,
        PipelineStage.hired => AppColors.stageHired,
        PipelineStage.rejected => AppColors.stageRejected,
      };
}

// â”€â”€ Profile Shimmer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(expandedHeight: 200, pinned: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ShimmerBox(height: 100),
                SizedBox(height: 12),
                ShimmerBox(height: 80),
                SizedBox(height: 12),
                ShimmerBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
