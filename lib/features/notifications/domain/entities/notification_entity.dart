import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

enum NotificationType { cvUploaded, stageMoved, jobAssigned, system }

@freezed
class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required String title,
    required String body,
    required NotificationType type,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? candidateId,
    String? jobId,
  }) = _NotificationEntity;
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool cvUploadedEmail,
    @Default(true) bool stageMovedEmail,
    @Default(true) bool jobAssignedEmail,
    @Default(true) bool pushEnabled,
  }) = _NotificationSettings;
}
