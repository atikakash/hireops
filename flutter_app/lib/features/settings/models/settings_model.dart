// ── Pipeline Stage Setting ────────────────────────────────────────────────────
class PipelineStageSetting {
  final int    id;
  final String name;
  final String color;
  final int    orderIndex;

  const PipelineStageSetting({
    required this.id,
    required this.name,
    required this.color,
    required this.orderIndex,
  });

  factory PipelineStageSetting.fromJson(Map<String, dynamic> j) =>
      PipelineStageSetting(
        id:         j['id'],
        name:       j['name'],
        color:      j['color'] ?? '#1A73E8',
        orderIndex: j['order_index'] ?? 0,
      );

  PipelineStageSetting copyWith({String? name, String? color}) =>
      PipelineStageSetting(
        id: id, orderIndex: orderIndex,
        name:  name  ?? this.name,
        color: color ?? this.color,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};
}

// ── Notification Settings ─────────────────────────────────────────────────────
class NotifSettings {
  final bool notifyCvUpload;
  final bool notifyStageChange;
  final bool emailNotifications;

  const NotifSettings({
    required this.notifyCvUpload,
    required this.notifyStageChange,
    required this.emailNotifications,
  });

  factory NotifSettings.fromJson(Map<String, dynamic> j) => NotifSettings(
    notifyCvUpload:    j['notify_cv_upload']    == true || j['notify_cv_upload']    == 1,
    notifyStageChange: j['notify_stage_change'] == true || j['notify_stage_change'] == 1,
    emailNotifications:j['email_notifications'] == true || j['email_notifications'] == 1,
  );

  NotifSettings copyWith({bool? notifyCvUpload, bool? notifyStageChange, bool? emailNotifications}) =>
      NotifSettings(
        notifyCvUpload:     notifyCvUpload     ?? this.notifyCvUpload,
        notifyStageChange:  notifyStageChange  ?? this.notifyStageChange,
        emailNotifications: emailNotifications ?? this.emailNotifications,
      );

  Map<String, dynamic> toJson() => {
    'notify_cv_upload':    notifyCvUpload,
    'notify_stage_change': notifyStageChange,
  };
}

// ── Company Settings ──────────────────────────────────────────────────────────
class CompanySettings {
  final int     id;
  final String  name;
  final String  slug;
  final String  email;
  final String? phone;
  final String? website;
  final String? industry;
  final String? address;

  const CompanySettings({
    required this.id, required this.name, required this.slug,
    required this.email, this.phone, this.website, this.industry, this.address,
  });

  factory CompanySettings.fromJson(Map<String, dynamic> j) => CompanySettings(
    id:       j['id'],
    name:     j['name'],
    slug:     j['slug'],
    email:    j['email'],
    phone:    j['phone'],
    website:  j['website'],
    industry: j['industry'],
    address:  j['address'],
  );
}

// ── All Settings (unified) ────────────────────────────────────────────────────
class AllSettings {
  final CompanySettings          company;
  final List<PipelineStageSetting> stages;
  final NotifSettings            notifications;

  const AllSettings({
    required this.company,
    required this.stages,
    required this.notifications,
  });

  factory AllSettings.fromJson(Map<String, dynamic> data) => AllSettings(
    company: CompanySettings.fromJson(data['company']),
    stages:  (data['pipeline_stages'] as List)
                .map((s) => PipelineStageSetting.fromJson(s)).toList(),
    notifications: NotifSettings.fromJson(data['notifications']),
  );

  AllSettings copyWith({
    CompanySettings? company,
    List<PipelineStageSetting>? stages,
    NotifSettings? notifications,
  }) => AllSettings(
    company:       company       ?? this.company,
    stages:        stages        ?? this.stages,
    notifications: notifications ?? this.notifications,
  );
}
