// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cv_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CvUploadState {
  UploadStatus get status => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String? get selectedFileName => throw _privateConstructorUsedError;
  int? get selectedFileSizeBytes => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  CvEntity? get uploadedCv => throw _privateConstructorUsedError;

  /// Create a copy of CvUploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CvUploadStateCopyWith<CvUploadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CvUploadStateCopyWith<$Res> {
  factory $CvUploadStateCopyWith(
          CvUploadState value, $Res Function(CvUploadState) then) =
      _$CvUploadStateCopyWithImpl<$Res, CvUploadState>;
  @useResult
  $Res call(
      {UploadStatus status,
      double progress,
      String? selectedFileName,
      int? selectedFileSizeBytes,
      String? errorMessage,
      CvEntity? uploadedCv});

  $CvEntityCopyWith<$Res>? get uploadedCv;
}

/// @nodoc
class _$CvUploadStateCopyWithImpl<$Res, $Val extends CvUploadState>
    implements $CvUploadStateCopyWith<$Res> {
  _$CvUploadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CvUploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? progress = null,
    Object? selectedFileName = freezed,
    Object? selectedFileSizeBytes = freezed,
    Object? errorMessage = freezed,
    Object? uploadedCv = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UploadStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      selectedFileName: freezed == selectedFileName
          ? _value.selectedFileName
          : selectedFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFileSizeBytes: freezed == selectedFileSizeBytes
          ? _value.selectedFileSizeBytes
          : selectedFileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedCv: freezed == uploadedCv
          ? _value.uploadedCv
          : uploadedCv // ignore: cast_nullable_to_non_nullable
              as CvEntity?,
    ) as $Val);
  }

  /// Create a copy of CvUploadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CvEntityCopyWith<$Res>? get uploadedCv {
    if (_value.uploadedCv == null) {
      return null;
    }

    return $CvEntityCopyWith<$Res>(_value.uploadedCv!, (value) {
      return _then(_value.copyWith(uploadedCv: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CvUploadStateImplCopyWith<$Res>
    implements $CvUploadStateCopyWith<$Res> {
  factory _$$CvUploadStateImplCopyWith(
          _$CvUploadStateImpl value, $Res Function(_$CvUploadStateImpl) then) =
      __$$CvUploadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UploadStatus status,
      double progress,
      String? selectedFileName,
      int? selectedFileSizeBytes,
      String? errorMessage,
      CvEntity? uploadedCv});

  @override
  $CvEntityCopyWith<$Res>? get uploadedCv;
}

/// @nodoc
class __$$CvUploadStateImplCopyWithImpl<$Res>
    extends _$CvUploadStateCopyWithImpl<$Res, _$CvUploadStateImpl>
    implements _$$CvUploadStateImplCopyWith<$Res> {
  __$$CvUploadStateImplCopyWithImpl(
      _$CvUploadStateImpl _value, $Res Function(_$CvUploadStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CvUploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? progress = null,
    Object? selectedFileName = freezed,
    Object? selectedFileSizeBytes = freezed,
    Object? errorMessage = freezed,
    Object? uploadedCv = freezed,
  }) {
    return _then(_$CvUploadStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UploadStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      selectedFileName: freezed == selectedFileName
          ? _value.selectedFileName
          : selectedFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFileSizeBytes: freezed == selectedFileSizeBytes
          ? _value.selectedFileSizeBytes
          : selectedFileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedCv: freezed == uploadedCv
          ? _value.uploadedCv
          : uploadedCv // ignore: cast_nullable_to_non_nullable
              as CvEntity?,
    ));
  }
}

/// @nodoc

class _$CvUploadStateImpl implements _CvUploadState {
  const _$CvUploadStateImpl(
      {this.status = UploadStatus.idle,
      this.progress = 0.0,
      this.selectedFileName,
      this.selectedFileSizeBytes,
      this.errorMessage,
      this.uploadedCv});

  @override
  @JsonKey()
  final UploadStatus status;
  @override
  @JsonKey()
  final double progress;
  @override
  final String? selectedFileName;
  @override
  final int? selectedFileSizeBytes;
  @override
  final String? errorMessage;
  @override
  final CvEntity? uploadedCv;

  @override
  String toString() {
    return 'CvUploadState(status: $status, progress: $progress, selectedFileName: $selectedFileName, selectedFileSizeBytes: $selectedFileSizeBytes, errorMessage: $errorMessage, uploadedCv: $uploadedCv)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CvUploadStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.selectedFileName, selectedFileName) ||
                other.selectedFileName == selectedFileName) &&
            (identical(other.selectedFileSizeBytes, selectedFileSizeBytes) ||
                other.selectedFileSizeBytes == selectedFileSizeBytes) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.uploadedCv, uploadedCv) ||
                other.uploadedCv == uploadedCv));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, progress,
      selectedFileName, selectedFileSizeBytes, errorMessage, uploadedCv);

  /// Create a copy of CvUploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CvUploadStateImplCopyWith<_$CvUploadStateImpl> get copyWith =>
      __$$CvUploadStateImplCopyWithImpl<_$CvUploadStateImpl>(this, _$identity);
}

abstract class _CvUploadState implements CvUploadState {
  const factory _CvUploadState(
      {final UploadStatus status,
      final double progress,
      final String? selectedFileName,
      final int? selectedFileSizeBytes,
      final String? errorMessage,
      final CvEntity? uploadedCv}) = _$CvUploadStateImpl;

  @override
  UploadStatus get status;
  @override
  double get progress;
  @override
  String? get selectedFileName;
  @override
  int? get selectedFileSizeBytes;
  @override
  String? get errorMessage;
  @override
  CvEntity? get uploadedCv;

  /// Create a copy of CvUploadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CvUploadStateImplCopyWith<_$CvUploadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
