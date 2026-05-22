// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cv_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CvEntity {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  String? get candidateId => throw _privateConstructorUsedError;
  DateTime? get uploadedAt => throw _privateConstructorUsedError;

  /// Create a copy of CvEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CvEntityCopyWith<CvEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CvEntityCopyWith<$Res> {
  factory $CvEntityCopyWith(CvEntity value, $Res Function(CvEntity) then) =
      _$CvEntityCopyWithImpl<$Res, CvEntity>;
  @useResult
  $Res call(
      {String id,
      String fileName,
      String fileUrl,
      int fileSizeBytes,
      String mimeType,
      String? candidateId,
      DateTime? uploadedAt});
}

/// @nodoc
class _$CvEntityCopyWithImpl<$Res, $Val extends CvEntity>
    implements $CvEntityCopyWith<$Res> {
  _$CvEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CvEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileSizeBytes = null,
    Object? mimeType = null,
    Object? candidateId = freezed,
    Object? uploadedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      candidateId: freezed == candidateId
          ? _value.candidateId
          : candidateId // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CvEntityImplCopyWith<$Res>
    implements $CvEntityCopyWith<$Res> {
  factory _$$CvEntityImplCopyWith(
          _$CvEntityImpl value, $Res Function(_$CvEntityImpl) then) =
      __$$CvEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fileName,
      String fileUrl,
      int fileSizeBytes,
      String mimeType,
      String? candidateId,
      DateTime? uploadedAt});
}

/// @nodoc
class __$$CvEntityImplCopyWithImpl<$Res>
    extends _$CvEntityCopyWithImpl<$Res, _$CvEntityImpl>
    implements _$$CvEntityImplCopyWith<$Res> {
  __$$CvEntityImplCopyWithImpl(
      _$CvEntityImpl _value, $Res Function(_$CvEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CvEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileSizeBytes = null,
    Object? mimeType = null,
    Object? candidateId = freezed,
    Object? uploadedAt = freezed,
  }) {
    return _then(_$CvEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      candidateId: freezed == candidateId
          ? _value.candidateId
          : candidateId // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CvEntityImpl implements _CvEntity {
  const _$CvEntityImpl(
      {required this.id,
      required this.fileName,
      required this.fileUrl,
      required this.fileSizeBytes,
      required this.mimeType,
      this.candidateId,
      this.uploadedAt});

  @override
  final String id;
  @override
  final String fileName;
  @override
  final String fileUrl;
  @override
  final int fileSizeBytes;
  @override
  final String mimeType;
  @override
  final String? candidateId;
  @override
  final DateTime? uploadedAt;

  @override
  String toString() {
    return 'CvEntity(id: $id, fileName: $fileName, fileUrl: $fileUrl, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, candidateId: $candidateId, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CvEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.candidateId, candidateId) ||
                other.candidateId == candidateId) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, fileName, fileUrl,
      fileSizeBytes, mimeType, candidateId, uploadedAt);

  /// Create a copy of CvEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CvEntityImplCopyWith<_$CvEntityImpl> get copyWith =>
      __$$CvEntityImplCopyWithImpl<_$CvEntityImpl>(this, _$identity);
}

abstract class _CvEntity implements CvEntity {
  const factory _CvEntity(
      {required final String id,
      required final String fileName,
      required final String fileUrl,
      required final int fileSizeBytes,
      required final String mimeType,
      final String? candidateId,
      final DateTime? uploadedAt}) = _$CvEntityImpl;

  @override
  String get id;
  @override
  String get fileName;
  @override
  String get fileUrl;
  @override
  int get fileSizeBytes;
  @override
  String get mimeType;
  @override
  String? get candidateId;
  @override
  DateTime? get uploadedAt;

  /// Create a copy of CvEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CvEntityImplCopyWith<_$CvEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
