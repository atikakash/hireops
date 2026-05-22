import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/cv_upload/data/models/cv_model.dart';
import 'package:hireops/features/cv_upload/domain/entities/cv_entity.dart';
import 'package:hireops/features/cv_upload/domain/repositories/cv_repository.dart';
import 'package:hireops/features/cv_upload/domain/usecases/upload_cv_usecase.dart';
import 'package:hireops/shared/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cv_providers.g.dart';
part 'cv_providers.freezed.dart';

@riverpod
CvRemoteDataSource cvRemoteDataSource(Ref ref) =>
    CvRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
CvRepository cvRepository(Ref ref) =>
    CvRepositoryImpl(ref.watch(cvRemoteDataSourceProvider));

@riverpod
UploadCvUseCase uploadCvUseCase(Ref ref) =>
    UploadCvUseCase(ref.watch(cvRepositoryProvider));

enum UploadStatus { idle, validating, uploading, success, error }

@freezed
class CvUploadState with _$CvUploadState {
  const factory CvUploadState({
    @Default(UploadStatus.idle) UploadStatus status,
    @Default(0.0) double progress,
    String? selectedFileName,
    int? selectedFileSizeBytes,
    String? errorMessage,
    CvEntity? uploadedCv,
  }) = _CvUploadState;
}

@riverpod
class CvUploadNotifier extends _$CvUploadNotifier {
  @override
  CvUploadState build() => const CvUploadState();

  void setSelectedFile(String name, int size) {
    state = state.copyWith(
      selectedFileName: name,
      selectedFileSizeBytes: size,
      errorMessage: null,
      status: UploadStatus.idle,
      uploadedCv: null,
    );
  }

  Future<CvEntity?> upload({
    required List<int> bytes,
    required String fileName,
    required int fileSizeBytes,
  }) async {
    state = state.copyWith(
      selectedFileName: fileName,
      selectedFileSizeBytes: fileSizeBytes,
      status: UploadStatus.validating,
      progress: 0,
      errorMessage: null,
    );

    final useCase = ref.read(uploadCvUseCaseProvider);
    final (entity, failure) = await useCase(
      bytes: bytes,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      onProgress: (progress) => state = state.copyWith(
        status: UploadStatus.uploading,
        progress: progress,
      ),
    );

    if (failure != null) {
      state = state.copyWith(
        status: UploadStatus.error,
        errorMessage: failure.message,
      );
      return null;
    }

    state = state.copyWith(
      status: UploadStatus.success,
      progress: 1.0,
      uploadedCv: entity,
    );
    return entity;
  }

  void reset() => state = const CvUploadState();
}

extension FailureMsgCv on Failure {
  String get message => when(
        network: (msg, _) => msg,
        unauthorized: (msg) => msg,
        forbidden: (msg) => msg,
        notFound: (msg) => msg,
        validation: (msg, _) => msg,
        server: (msg) => msg,
        cache: (msg) => msg,
        fileValidation: (msg) => msg,
        noInternet: (msg) => msg,
        unknown: (msg) => msg,
      );
}
