import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/candidate_entity.dart';
import 'stage_badge.dart';

class CandidateListTile extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateListTile({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/candidates/${candidate.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            // Avatar
            _CandidateAvatar(
              name: candidate.name,
              avatarUrl: candidate.avatarUrl,
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          candidate.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StageBadge(stage: candidate.currentStage),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    candidate.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (candidate.skills.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _SkillsRow(skills: candidate.skills),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),
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
      ),
    );
  }
}

class _CandidateAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const _CandidateAvatar({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(' ').take(2).map((w) => w[0]).join();
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppColors.secondaryContainer,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _SkillsRow extends StatelessWidget {
  final List<String> skills;
  const _SkillsRow({required this.skills});

  @override
  Widget build(BuildContext context) {
    final visible = skills.take(3).toList();
    final extra = skills.length - visible.length;
    return Row(
      children: [
        ...visible.map((s) => Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoftLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )),
        if (extra > 0)
          Text(
            '+$extra',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}
