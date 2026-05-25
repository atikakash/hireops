import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/cv_upload/domain/entities/cv_entity.dart';
import 'package:hireops/features/cv_upload/domain/repositories/cv_repository.dart';

part 'cv_model.freezed.dart';
part 'cv_model.g.dart';

@freezed
class CvModel with _$CvModel {
  const factory CvModel({
    required String id,
    required String fileName,
    required String fileUrl,
    required int fileSizeBytes,
    required String mimeType,
    String? candidateId,
    String? uploadedAt,
  }) = _CvModel;

  factory CvModel.fromJson(Map<String, dynamic> json) =>
      _$CvModelFromJson(json);
}

extension CvModelMapper on CvModel {
  CvEntity toEntity() => CvEntity(
        id: id,
        fileName: fileName,
        fileUrl: fileUrl,
        fileSizeBytes: fileSizeBytes,
        mimeType: mimeType,
        candidateId: candidateId,
        uploadedAt: uploadedAt != null ? DateTime.tryParse(uploadedAt!) : null,
      );
}

class CvRemoteDataSource {
  final DioClient _dioClient;

  const CvRemoteDataSource(this._dioClient);

  Dio get _dio => _dioClient.client;

  Future<CvModel> uploadCv({
    required List<int> bytes,
    required String fileName,
    String? candidateName,
    String? candidateEmail,
    String? candidatePhone,
    String? experienceYears,
    String? skills,
    String? tags,
    void Function(double progress)? onProgress,
  }) async {
    final fields = <String, dynamic>{
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    };

    void addIfPresent(String key, String? value) {
      final normalized = value?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        fields[key] = normalized;
      }
    }

    addIfPresent('name', candidateName);
    addIfPresent('email', candidateEmail);
    addIfPresent('phone', candidatePhone);
    addIfPresent('experienceYears', experienceYears);
    addIfPresent('skills', skills);
    addIfPresent('tags', tags);

    final formData = FormData.fromMap(fields);

    final response = await _dio.post(
      ApiConstants.cvUpload,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
      onSendProgress: (sent, total) {
        if (total > 0) {
          onProgress?.call(sent / total);
        }
      },
    );

    return CvModel.fromJson(_extractCvMap(response.data));
  }

  Future<String> getDownloadUrl(String cvId) async {
    final response = await _dio.get(ApiConstants.cvDownload(cvId));
    final payload = _asMap(response.data);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      return '${data['url'] ?? ''}';
    }

    return '${payload['url'] ?? ''}';
  }

  Map<String, dynamic> _extractCvMap(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      final cv = data['cv'];
      if (cv is Map<String, dynamic>) {
        return cv;
      }
      return data;
    }

    if (payload['cv'] is Map<String, dynamic>) {
      return payload['cv'] as Map<String, dynamic>;
    }

    return payload;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }

    return const <String, dynamic>{};
  }
}

class CvRepositoryImpl implements CvRepository {
  final CvRemoteDataSource _ds;

  const CvRepositoryImpl(this._ds);

  @override
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
  }) async {
    try {
      final model = await _ds.uploadCv(
        bytes: bytes,
        fileName: fileName,
        candidateName: candidateName,
        candidateEmail: candidateEmail,
        candidatePhone: candidatePhone,
        experienceYears: experienceYears,
        skills: skills,
        tags: tags,
        onProgress: onProgress,
      );
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (
        null,
        e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (
          null,
          appException is NoInternetException
              ? Failure.noInternet(message: appException.message)
              : Failure.network(message: appException.message),
        );
      }
      return (null, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(String?, Failure?)> getDownloadUrl(String cvId) async {
    try {
      final url = await _ds.getDownloadUrl(cvId);
      return (url, null);
    } on AppException catch (e) {
      return (
        null,
        e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      );
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (
          null,
          appException is NoInternetException
              ? Failure.noInternet(message: appException.message)
              : Failure.network(message: appException.message),
        );
      }
      return (null, Failure.unknown(message: e.toString()));
    }
  }
}
