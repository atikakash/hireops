import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hireops/core/constants/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../providers/job_providers.dart';

class AddEditJobScreen extends HookConsumerWidget {
  final String? jobId;
  const AddEditJobScreen({super.key, this.jobId});
  bool get isEdit => jobId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleCtrl = useTextEditingController();
    final deptCtrl = useTextEditingController();
    final descCtrl = useTextEditingController();
    final formState = ref.watch(jobFormNotifierProvider);

    // Pre-fill
    final jobAsync = isEdit ? ref.watch(jobDetailProvider(jobId!)) : null;
    useEffect(() {
      if (jobAsync?.valueOrNull != null) {
        final j = jobAsync!.value!;
        titleCtrl.text = j.title;
        deptCtrl.text = j.department;
        descCtrl.text = j.description;
      }
      return null;
    }, [jobAsync?.valueOrNull]);

    Future<void> onSubmit() async {
      if (!formKey.currentState!.validate()) return;
      FocusScope.of(context).unfocus();

      final notifier = ref.read(jobFormNotifierProvider.notifier);
      final result = isEdit
          ? await notifier.update(
              id: jobId!,
              title: titleCtrl.text.trim(),
              department: deptCtrl.text.trim(),
              description: descCtrl.text.trim(),
            )
          : await notifier.create(
              title: titleCtrl.text.trim(),
              department: deptCtrl.text.trim(),
              description: descCtrl.text.trim(),
            );

      if (result != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isEdit
              ? 'Job updated successfully!'
              : 'Job created successfully!'),
          backgroundColor: AppColors.success,
        ));
        context.pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editJob : AppStrings.addJobPosition),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              if (formState.errorMessage != null)
                ErrorBanner(
                  message: formState.errorMessage!,
                  onDismiss: () =>
                      ref.read(jobFormNotifierProvider.notifier).clearError(),
                ),
              AppTextField(
                label: AppStrings.jobTitle,
                hint: 'e.g. Senior Flutter Developer',
                controller: titleCtrl,
                prefixIcon: const Icon(Icons.work_outline, size: 20),
                validator: (v) => AppValidators.required(v, label: 'Job title'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: AppStrings.department,
                hint: 'e.g. Engineering',
                controller: deptCtrl,
                prefixIcon: const Icon(Icons.business_outlined, size: 20),
                validator: (v) =>
                    AppValidators.required(v, label: 'Department'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: AppStrings.description,
                hint: 'Describe the role, responsibilities and requirements…',
                controller: descCtrl,
                maxLines: 6,
                prefixIcon: const Icon(Icons.description_outlined, size: 20),
                validator: (v) =>
                    AppValidators.required(v, label: 'Description'),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: isEdit ? 'Save Changes' : 'Create Job',
                isLoading: formState.isLoading,
                onPressed: onSubmit,
                icon:
                    isEdit ? Icons.save_outlined : Icons.add_business_outlined,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
