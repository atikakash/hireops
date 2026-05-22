import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../providers/cv_providers.dart';

class CvUploadScreen extends HookConsumerWidget {
  const CvUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(cvUploadNotifierProvider);
    final notifier = ref.read(cvUploadNotifierProvider.notifier);
    final selectedFile = useState<PlatformFile?>(null);

    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ApiConstants.allowedCvExtensions,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final picked = result.files.first;
      if (picked.bytes == null || picked.bytes!.isEmpty) {
        return;
      }

      selectedFile.value = picked;
      notifier.setSelectedFile(picked.name, picked.size);
    }

    Future<void> upload() async {
      final file = selectedFile.value;
      if (file == null || file.bytes == null) {
        return;
      }

      final entity = await notifier.upload(
        bytes: file.bytes!,
        fileName: file.name,
        fileSizeBytes: file.size,
      );

      if (entity != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.cvUploadSuccess),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Upload CV')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.uploadYourCv,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.cvUploadSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: uploadState.status == UploadStatus.uploading
                    ? null
                    : pickFile,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: uploadState.selectedFileName != null
                        ? AppColors.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: uploadState.selectedFileName != null
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        uploadState.selectedFileName != null
                            ? _fileIcon(uploadState.selectedFileName!)
                            : Icons.upload_file_outlined,
                        size: 52,
                        color: uploadState.selectedFileName != null
                            ? AppColors.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 12),
                      if (uploadState.selectedFileName != null) ...[
                        Text(
                          uploadState.selectedFileName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        if (uploadState.selectedFileSizeBytes != null)
                          Text(
                            AppFileHelper.formatBytes(
                              uploadState.selectedFileSizeBytes!,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                      ] else ...[
                        Text(
                          'Tap to browse files',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.45),
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PDF, DOC, DOCX up to 5 MB',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.3),
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (uploadState.errorMessage != null)
                ErrorBanner(
                  message: uploadState.errorMessage!,
                  onDismiss: notifier.reset,
                ),
              if (uploadState.status == UploadStatus.success)
                const SuccessBanner(message: AppStrings.cvUploadSuccess),
              if (uploadState.status == UploadStatus.uploading ||
                  uploadState.status == UploadStatus.validating) ...[
                const SizedBox(height: 8),
                _ProgressSection(
                  progress: uploadState.progress,
                  label: uploadState.status == UploadStatus.validating
                      ? 'Validating...'
                      : 'Uploading... ${(uploadState.progress * 100).toStringAsFixed(0)}%',
                ),
              ],
              const Spacer(),
              const _FileTypeLegend(),
              const SizedBox(height: 20),
              if (uploadState.status == UploadStatus.success) ...[
                PrimaryButton(
                  label: 'Upload Another',
                  onPressed: () {
                    selectedFile.value = null;
                    notifier.reset();
                  },
                  icon: Icons.upload_file_outlined,
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Go to Candidates',
                  onPressed: () => context.go('/candidates'),
                  icon: Icons.people_outline,
                ),
              ] else ...[
                if (uploadState.selectedFileName == null)
                  PrimaryButton(
                    label: AppStrings.browseFile,
                    onPressed: pickFile,
                    icon: Icons.folder_open_outlined,
                  )
                else
                  Column(
                    children: [
                      PrimaryButton(
                        label: 'Upload CV',
                        isLoading:
                            uploadState.status == UploadStatus.uploading ||
                                uploadState.status == UploadStatus.validating,
                        onPressed: upload,
                        icon: Icons.cloud_upload_outlined,
                      ),
                      const SizedBox(height: 12),
                      SecondaryButton(
                        label: 'Choose Different File',
                        onPressed: pickFile,
                        icon: Icons.swap_horiz,
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _fileIcon(String name) {
    final ext = name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => Icons.picture_as_pdf_outlined,
      'doc' || 'docx' => Icons.description_outlined,
      _ => Icons.insert_drive_file_outlined,
    };
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final String label;

  const _ProgressSection({required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress == 0 ? null : progress,
            minHeight: 8,
            backgroundColor:
                Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _FileTypeLegend extends StatelessWidget {
  const _FileTypeLegend();

  @override
  Widget build(BuildContext context) {
    final types = [
      (Icons.picture_as_pdf_outlined, 'PDF', AppColors.error),
      (Icons.description_outlined, 'DOC', AppColors.primary),
      (Icons.description_outlined, 'DOCX', AppColors.stageShortlisted),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types
          .map(
            (type) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(type.$1, size: 16, color: type.$3),
                  const SizedBox(width: 4),
                  Text(
                    type.$2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: type.$3,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
