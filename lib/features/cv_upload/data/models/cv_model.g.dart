// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CvModelImpl _$$CvModelImplFromJson(Map<String, dynamic> json) =>
    _$CvModelImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      candidateId: json['candidateId'] as String?,
      uploadedAt: json['uploadedAt'] as String?,
    );

Map<String, dynamic> _$$CvModelImplToJson(_$CvModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'fileSizeBytes': instance.fileSizeBytes,
      'mimeType': instance.mimeType,
      'candidateId': instance.candidateId,
      'uploadedAt': instance.uploadedAt,
    };
