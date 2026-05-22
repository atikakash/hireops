import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/utils/helpers.dart';
import 'package:hireops/features/cv_upload/domain/entities/cv_entity.dart';
import 'package:hireops/features/cv_upload/domain/repositories/cv_repository.dart';

class UploadCvUseCase {
  final CvRepository _repo;

  const UploadCvUseCase(this._repo);

  Future<(CvEntity?, Failure?)> call({
    required List<int> bytes,
    required String fileName,
    required int fileSizeBytes,
    void Function(double progress)? onProgress,
  }) async {
    final extensionError = AppValidators.cvExtension(fileName);
    if (extensionError != null) {
      return (null, Failure.fileValidation(message: extensionError));
    }

    final sizeError = AppValidators.cvSize(fileSizeBytes);
    if (sizeError != null) {
      return (null, Failure.fileValidation(message: sizeError));
    }

    return _repo.uploadCv(
      bytes: bytes,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      onProgress: onProgress,
    );
  }
}
