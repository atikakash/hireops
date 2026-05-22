class NotificationSettings {
  final bool notifyCvUpload;
  final bool notifyStageChange;

  const NotificationSettings({
    required this.notifyCvUpload,
    required this.notifyStageChange,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        notifyCvUpload:    json['notify_cv_upload']    == true || json['notify_cv_upload']    == 1,
        notifyStageChange: json['notify_stage_change'] == true || json['notify_stage_change'] == 1,
      );

  factory NotificationSettings.defaults() => const NotificationSettings(
    notifyCvUpload:    true,
    notifyStageChange: true,
  );

  NotificationSettings copyWith({bool? notifyCvUpload, bool? notifyStageChange}) =>
      NotificationSettings(
        notifyCvUpload:    notifyCvUpload    ?? this.notifyCvUpload,
        notifyStageChange: notifyStageChange ?? this.notifyStageChange,
      );

  Map<String, dynamic> toJson() => {
    'notify_cv_upload':    notifyCvUpload,
    'notify_stage_change': notifyStageChange,
  };
}
