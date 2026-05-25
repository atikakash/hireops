import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/cv_upload/domain/entities/cv_entity.dart';

abstract interface class CvRepository {
  Future<(CvEntity?, Failure?)> uploadCv({
    required List<int> bytes,
    required String fileName,
    required int fileSizeBytes,
    String? candidateName,
    String? candidateEmail,
    String? candidatePhone,
    String? experienceYears,
    String? skills,
    String? tags,
    void Function(double progress)? onProgress,
  });

  Future<(String?, Failure?)> getDownloadUrl(String cvId);
}
