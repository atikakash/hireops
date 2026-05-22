import 'package:freezed_annotation/freezed_annotation.dart';

part 'cv_entity.freezed.dart';

@freezed
class CvEntity with _$CvEntity {
  const factory CvEntity({
    required String id,
    required String fileName,
    required String fileUrl,
    required int fileSizeBytes,
    required String mimeType,
    String? candidateId,
    DateTime? uploadedAt,
  }) = _CvEntity;
}
