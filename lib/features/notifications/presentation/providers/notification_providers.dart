import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hireops/core/constants/api_constants.dart';
import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/core/network/dio_client.dart';
import 'package:hireops/features/notifications/domain/entities/notification_entity.dart';
import 'package:hireops/shared/providers/core_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';
part 'notification_providers.freezed.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    @Default('system') String type,
    required String createdAt,
    @Default(false) bool isRead,
    String? candidateId,
    String? jobId,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelMapper on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        body: body,
        type: NotificationType.values.firstWhere(
          (item) => item.name == type,
          orElse: () => NotificationType.system,
        ),
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        isRead: isRead,
        candidateId: candidateId,
        jobId: jobId,
      );
}

class NotificationRemoteDataSource {
  final DioClient _client;

  const NotificationRemoteDataSource(this._client);

  Dio get _dio => _client.client;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(ApiConstants.notifications);
    return _extractNotificationList(response.data)
        .map(NotificationModel.fromJson)
        .toList();
  }

  Future<void> markRead(String id) async =>
      _dio.put('${ApiConstants.notifications}/$id/read');

  Future<void> markAllRead() async =>
      _dio.put('${ApiConstants.notifications}/read-all');

  Future<Map<String, dynamic>> getSettings() async {
    final response = await _dio.get(ApiConstants.notificationSettings);
    return _extractSettingsMap(response.data);
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async =>
      _dio.put(ApiConstants.notificationSettings, data: settings);

  List<Map<String, dynamic>> _extractNotificationList(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is List) {
      return data.map(_asMap).toList();
    }

    if (data is Map<String, dynamic>) {
      final notifications = data['notifications'] ?? data['items'];
      if (notifications is List) {
        return notifications.map(_asMap).toList();
      }
    }

    if (payload['notifications'] is List) {
      return (payload['notifications'] as List).map(_asMap).toList();
    }

    if (response is List) {
      return response.map(_asMap).toList();
    }

    return const [];
  }

  Map<String, dynamic> _extractSettingsMap(dynamic response) {
    final payload = _asMap(response);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      final settings = data['settings'];
      if (settings is Map<String, dynamic>) {
        return settings;
      }
      return data;
    }

    if (payload['settings'] is Map<String, dynamic>) {
      return payload['settings'] as Map<String, dynamic>;
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

@riverpod
NotificationRemoteDataSource notificationRemoteDataSource(Ref ref) =>
    NotificationRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
Future<List<NotificationEntity>> notificationList(Ref ref) async {
  final dataSource = ref.watch(notificationRemoteDataSourceProvider);
  try {
    final models = await dataSource.getNotifications();
    return models.map((model) => model.toEntity()).toList();
  } on AppException catch (e) {
    return Future.error(
      e is NoInternetException
          ? Failure.noInternet(message: e.message)
          : Failure.network(message: e.message),
      StackTrace.current,
    );
  } on Object catch (e) {
    final appException = extractAppException(e);
    if (appException != null) {
      return Future.error(
        appException is NoInternetException
            ? Failure.noInternet(message: appException.message)
            : Failure.network(message: appException.message),
        StackTrace.current,
      );
    }
    return Future.error(
      Failure.unknown(message: e.toString()),
      StackTrace.current,
    );
  }
}

@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  @override
  NotificationSettings build() => const NotificationSettings();

  Future<void> load() async {
    final dataSource = ref.read(notificationRemoteDataSourceProvider);
    try {
      final raw = await dataSource.getSettings();
      state = NotificationSettings(
        cvUploadedEmail: raw['cvUploadedEmail'] as bool? ?? true,
        stageMovedEmail: raw['stageMovedEmail'] as bool? ?? true,
        jobAssignedEmail: raw['jobAssignedEmail'] as bool? ?? true,
        pushEnabled: raw['pushEnabled'] as bool? ?? true,
      );
    } on Object {
      // Keep defaults when settings are unavailable.
    }
  }

  Future<void> toggle(String key, bool value) async {
    state = switch (key) {
      'cvUploadedEmail' => state.copyWith(cvUploadedEmail: value),
      'stageMovedEmail' => state.copyWith(stageMovedEmail: value),
      'jobAssignedEmail' => state.copyWith(jobAssignedEmail: value),
      'pushEnabled' => state.copyWith(pushEnabled: value),
      _ => state,
    };

    final dataSource = ref.read(notificationRemoteDataSourceProvider);
    try {
      await dataSource.updateSettings({
        'cvUploadedEmail': state.cvUploadedEmail,
        'stageMovedEmail': state.stageMovedEmail,
        'jobAssignedEmail': state.jobAssignedEmail,
        'pushEnabled': state.pushEnabled,
      });
    } on Object {
      // Leave optimistic state in place.
    }
  }

  Future<void> markAllRead() async {
    final dataSource = ref.read(notificationRemoteDataSourceProvider);
    try {
      await dataSource.markAllRead();
      ref.invalidate(notificationListProvider);
    } on Object {
      // No-op for now.
    }
  }

  Future<void> markRead(String id) async {
    final dataSource = ref.read(notificationRemoteDataSourceProvider);
    try {
      await dataSource.markRead(id);
      ref.invalidate(notificationListProvider);
    } on Object {
      // No-op for now.
    }
  }
}
