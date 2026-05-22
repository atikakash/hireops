import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/candidate_entity.dart';

class StageBadge extends StatelessWidget {
  final PipelineStage stage;
  final bool large;

  const StageBadge({super.key, required this.stage, this.large = false});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _stageInfo(stage);
    final fs = large ? 12.0 : 10.0;
    final px = large ? 10.0 : 7.0;
    final py = large ? 5.0 : 3.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: large ? 6 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fs,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static (String, Color) _stageInfo(PipelineStage stage) => switch (stage) {
        PipelineStage.applied => ('Applied', AppColors.stageApplied),
        PipelineStage.shortlisted => (
            'Shortlisted',
            AppColors.stageShortlisted
          ),
        PipelineStage.interview => ('Interview', AppColors.stageInterview),
        PipelineStage.hired => ('Hired', AppColors.stageHired),
        PipelineStage.rejected => ('Rejected', AppColors.stageRejected),
      };
}
