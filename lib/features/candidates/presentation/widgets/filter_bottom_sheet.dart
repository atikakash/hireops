import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/candidate_entity.dart';
import '../providers/candidate_providers.dart';

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.read(candidateFilterNotifierProvider);
    final selectedStage = useState<PipelineStage?>(filter.stage);
    final minExp = useState<int?>(filter.minExperience);
    final maxExp = useState<int?>(filter.maxExperience);

    const stages = PipelineStage.values;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter Candidates',
                  style: Theme.of(context).textTheme.headlineMedium),
              TextButton(
                onPressed: () {
                  selectedStage.value = null;
                  minExp.value = null;
                  maxExp.value = null;
                },
                child: const Text('Clear all'),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Text('Pipeline Stage', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),

          // Stage chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: stages.map((s) {
              final isSelected = selectedStage.value == s;
              final (label, color) = _stageLabel(s);
              return FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (v) => selectedStage.value = v ? s : null,
                selectedColor: color.withValues(alpha: 0.18),
                checkmarkColor: color,
                labelStyle: TextStyle(
                  color: isSelected ? color : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                side: BorderSide(
                  color: isSelected
                      ? color.withValues(alpha: 0.4)
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          Text('Experience (years)',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),

          Row(
            children: [
              _ExpField(
                label: 'Min',
                value: minExp.value,
                onChanged: (v) => minExp.value = v,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child:
                    Text('to', style: Theme.of(context).textTheme.bodyMedium),
              ),
              _ExpField(
                label: 'Max',
                value: maxExp.value,
                onChanged: (v) => maxExp.value = v,
              ),
            ],
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(candidateFilterNotifierProvider.notifier)
                    .setStage(selectedStage.value);
                ref
                    .read(candidateFilterNotifierProvider.notifier)
                    .setExperience(minExp.value, maxExp.value);
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  (String, Color) _stageLabel(PipelineStage s) => switch (s) {
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

class _ExpField extends StatelessWidget {
  final String label;
  final int? value;
  final void Function(int?) onChanged;

  const _ExpField(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        initialValue: value?.toString() ?? '',
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(int.tryParse(v)),
      ),
    );
  }
}
