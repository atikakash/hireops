import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hireops/features/candidates/domain/entities/candidate_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../providers/candidate_providers.dart';

class AddEditCandidateScreen extends HookConsumerWidget {
  final String? candidateId;

  const AddEditCandidateScreen({super.key, this.candidateId});

  bool get isEdit => candidateId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final expCtrl = useTextEditingController();
    final skillCtrl = useTextEditingController();
    final skills = useState<List<String>>([]);
    final formState = ref.watch(candidateFormNotifierProvider);

    // Pre-fill if editing
    final candidateAsync =
        isEdit ? ref.watch(candidateDetailProvider(candidateId!)) : null;

    useEffect(() {
      if (candidateAsync?.valueOrNull != null) {
        final c = candidateAsync!.value!;
        nameCtrl.text = c.name;
        emailCtrl.text = c.email;
        phoneCtrl.text = c.phone ?? '';
        expCtrl.text = c.experienceYears.toString();
        skills.value = List.from(c.skills);
      }
      return null;
    }, [candidateAsync?.valueOrNull]);

    void addSkill(String skill) {
      final s = skill.trim();
      if (s.isEmpty || skills.value.contains(s)) return;
      skills.value = [...skills.value, s];
      skillCtrl.clear();
    }

    void removeSkill(String s) {
      skills.value = skills.value.where((e) => e != s).toList();
    }

    Future<void> onSubmit() async {
      if (!formKey.currentState!.validate()) return;
      FocusScope.of(context).unfocus();
      ref.read(candidateFormNotifierProvider.notifier).clearError();

      final notifier = ref.read(candidateFormNotifierProvider.notifier);
      CandidateEntity? result;

      if (isEdit) {
        result = await notifier.updateCandidate(
          id: candidateId!,
          name: nameCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
          experienceYears: int.tryParse(expCtrl.text),
          skills: skills.value,
        );
      } else {
        result = await notifier.createCandidate(
          name: nameCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
          experienceYears: int.tryParse(expCtrl.text),
          skills: skills.value,
        );
      }

      if (result != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit
                ? 'Candidate updated successfully!'
                : 'Candidate added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEdit ? AppStrings.editCandidate : AppStrings.addCandidate),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Error banner
              if (formState.errorMessage != null)
                ErrorBanner(
                  message: formState.errorMessage!,
                  onDismiss: () => ref
                      .read(candidateFormNotifierProvider.notifier)
                      .clearError(),
                ),

              _FormSection(
                title: 'Basic Information',
                children: [
                  AppTextField(
                    label: AppStrings.fullName,
                    hint: 'Jane Smith',
                    controller: nameCtrl,
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    validator: (v) => AppValidators.required(v, label: 'Name'),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: AppStrings.email,
                    hint: 'jane@example.com',
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.mail_outline, size: 20),
                    validator: AppValidators.email,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: AppStrings.phone,
                    hint: '+1 555 000 0000',
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    validator: AppValidators.phone,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _FormSection(
                title: 'Professional Details',
                children: [
                  AppTextField(
                    label: AppStrings.experienceYears,
                    hint: '3',
                    controller: expCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    prefixIcon: const Icon(Icons.timeline_outlined, size: 20),
                    validator: AppValidators.experience,
                  ),
                  const SizedBox(height: 14),

                  // Skills input
                  Text(AppStrings.skills,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: skillCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Type a skill and press Enter',
                            prefixIcon:
                                Icon(Icons.add_circle_outline, size: 20),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: addSkill,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => addSkill(skillCtrl.text),
                        icon: const Icon(Icons.add, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (skills.value.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: skills.value
                          .map(
                            (s) => Chip(
                              label: Text(s),
                              onDeleted: () => removeSkill(s),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              backgroundColor: AppColors.primaryContainer,
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                label: isEdit ? 'Save Changes' : 'Add Candidate',
                isLoading: formState.isLoading,
                onPressed: onSubmit,
                icon: isEdit ? Icons.save_outlined : Icons.person_add_outlined,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FormSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
