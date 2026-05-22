import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/banners.dart';
import '../../../../shared/widgets/buttons.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(companyProfileNotifierProvider);
    final notifSettings = ref.watch(notificationSettingsNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    useEffect(() {
      Future.microtask(
        () => ref.read(notificationSettingsNotifierProvider.notifier).load(),
      );
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: profileState.isLoading
          ? _SettingsShimmer()
          : ListView(
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                _SettingsSection(
                  title: AppStrings.companyProfile,
                  icon: Icons.business_outlined,
                  child: _CompanyProfileForm(profileState: profileState),
                ),
                _SettingsSection(
                  title: 'Appearance',
                  icon: Icons.palette_outlined,
                  child: _ToggleRow(
                    label: AppStrings.darkMode,
                    subtitle: 'Switch between light and dark theme',
                    icon: Icons.dark_mode_outlined,
                    value: isDark,
                    onChanged: (value) => ref
                        .read(themeModeProvider.notifier)
                        .setMode(value ? ThemeMode.dark : ThemeMode.light),
                  ),
                ),
                _SettingsSection(
                  title: AppStrings.emailNotifications,
                  icon: Icons.mail_outline,
                  child: Column(
                    children: [
                      _ToggleRow(
                        label: 'CV uploaded',
                        subtitle: 'Email when a new CV is uploaded',
                        icon: Icons.upload_file_outlined,
                        value: notifSettings.cvUploadedEmail,
                        onChanged: (value) => ref
                            .read(notificationSettingsNotifierProvider.notifier)
                            .toggle('cvUploadedEmail', value),
                      ),
                      const _Divider(),
                      _ToggleRow(
                        label: 'Stage changed',
                        subtitle: 'Email when a candidate moves stages',
                        icon: Icons.swap_horiz_rounded,
                        value: notifSettings.stageMovedEmail,
                        onChanged: (value) => ref
                            .read(notificationSettingsNotifierProvider.notifier)
                            .toggle('stageMovedEmail', value),
                      ),
                      const _Divider(),
                      _ToggleRow(
                        label: 'Job assigned',
                        subtitle: 'Email when a candidate is assigned a job',
                        icon: Icons.work_outline,
                        value: notifSettings.jobAssignedEmail,
                        onChanged: (value) => ref
                            .read(notificationSettingsNotifierProvider.notifier)
                            .toggle('jobAssignedEmail', value),
                      ),
                      const _Divider(),
                      _ToggleRow(
                        label: 'Push notifications',
                        subtitle: 'In-app push alerts for all events',
                        icon: Icons.notifications_outlined,
                        value: notifSettings.pushEnabled,
                        onChanged: (value) => ref
                            .read(notificationSettingsNotifierProvider.notifier)
                            .toggle('pushEnabled', value),
                      ),
                    ],
                  ),
                ),
                _SettingsSection(
                  title: AppStrings.teamMembers,
                  icon: Icons.group_outlined,
                  child: profileState.profile?.members.isEmpty ?? true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No team members yet.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.45),
                                    ),
                          ),
                        )
                      : Column(
                          children: (profileState.profile?.members ?? [])
                              .map((member) => _TeamMemberTile(member: member))
                              .toList(),
                        ),
                ),
                _SettingsSection(
                  title: 'Account',
                  icon: Icons.manage_accounts_outlined,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.notifications_active_outlined,
                          size: 20,
                        ),
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () => context.push('/notifications'),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.logout,
                          size: 20,
                          color: AppColors.error,
                        ),
                        title: const Text(
                          'Log out',
                          style: TextStyle(color: AppColors.error),
                        ),
                        onTap: () => _confirmLogout(context, ref),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'HireOps v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.3),
                          ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text(AppStrings.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (context.mounted) {
        context.replace(AppRoutes.login);
      }
    }
  }
}

class _CompanyProfileForm extends HookConsumerWidget {
  final CompanyProfileState profileState;

  const _CompanyProfileForm({required this.profileState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = profileState.profile;
    final isEditing = useState(false);

    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final websiteCtrl = useTextEditingController();
    final industryCtrl = useTextEditingController();
    final addressCtrl = useTextEditingController();

    useEffect(() {
      if (profile == null) {
        return null;
      }

      nameCtrl.text = profile.name;
      emailCtrl.text = profile.email;
      phoneCtrl.text = profile.phone ?? '';
      websiteCtrl.text = profile.website ?? '';
      industryCtrl.text = profile.industry ?? '';
      addressCtrl.text = profile.address ?? '';
      return null;
    }, [
      profile?.id,
      profile?.name,
      profile?.email,
      profile?.phone,
      profile?.website,
      profile?.industry,
      profile?.address,
    ]);

    useEffect(() {
      if (profileState.successMessage != null) {
        isEditing.value = false;
      }
      return null;
    }, [profileState.successMessage]);

    if (profile == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profileState.errorMessage != null)
            ErrorBanner(
              message: profileState.errorMessage!,
              onDismiss: () => ref
                  .read(companyProfileNotifierProvider.notifier)
                  .clearMessages(),
            ),
          Text(
            'Company profile is not available right now.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: AppStrings.retry,
            onPressed: () =>
                ref.read(companyProfileNotifierProvider.notifier).reload(),
            icon: Icons.refresh,
          ),
        ],
      );
    }

    final fieldErrors = profileState.fieldErrors ?? const <String, String>{};
    final createdAtLabel = profile.createdAt == null
        ? null
        : DateFormat.yMMMd().format(profile.createdAt!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profileState.errorMessage != null)
          ErrorBanner(
            message: profileState.errorMessage!,
            onDismiss: () => ref
                .read(companyProfileNotifierProvider.notifier)
                .clearMessages(),
          ),
        if (profileState.successMessage != null)
          SuccessBanner(message: profileState.successMessage!),
        _ProfileHero(
          profile: profile,
          isEditing: isEditing.value,
          onEditToggle: () {
            if (isEditing.value) {
              nameCtrl.text = profile.name;
              emailCtrl.text = profile.email;
              phoneCtrl.text = profile.phone ?? '';
              websiteCtrl.text = profile.website ?? '';
              industryCtrl.text = profile.industry ?? '';
              addressCtrl.text = profile.address ?? '';
              ref.read(companyProfileNotifierProvider.notifier).clearMessages();
            }

            isEditing.value = !isEditing.value;
          },
        ),
        const SizedBox(height: 20),
        _CompanyFormField(
          label: 'Company Name',
          controller: nameCtrl,
          icon: Icons.business_outlined,
          enabled: isEditing.value,
          errorText: fieldErrors['name'],
        ),
        const SizedBox(height: 12),
        _CompanyFormField(
          label: 'Company Email',
          controller: emailCtrl,
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          enabled: isEditing.value,
          errorText: fieldErrors['email'],
        ),
        const SizedBox(height: 12),
        _CompanyFormField(
          label: 'Phone',
          controller: phoneCtrl,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          enabled: isEditing.value,
          errorText: fieldErrors['phone'],
        ),
        const SizedBox(height: 12),
        _CompanyFormField(
          label: 'Website',
          controller: websiteCtrl,
          icon: Icons.language_outlined,
          keyboardType: TextInputType.url,
          enabled: isEditing.value,
          errorText: fieldErrors['website'],
        ),
        const SizedBox(height: 12),
        _CompanyFormField(
          label: 'Industry',
          controller: industryCtrl,
          icon: Icons.category_outlined,
          enabled: isEditing.value,
          errorText: fieldErrors['industry'],
        ),
        const SizedBox(height: 12),
        _CompanyFormField(
          label: 'Address',
          controller: addressCtrl,
          icon: Icons.location_on_outlined,
          maxLines: 3,
          enabled: isEditing.value,
          errorText: fieldErrors['address'],
        ),
        if (createdAtLabel != null || profile.slug.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (profile.slug.isNotEmpty)
                _MetaPill(
                  icon: Icons.alternate_email,
                  label: 'Slug',
                  value: profile.slug,
                ),
              if (createdAtLabel != null)
                _MetaPill(
                  icon: Icons.calendar_today_outlined,
                  label: 'Created',
                  value: createdAtLabel,
                ),
            ],
          ),
        ],
        if (isEditing.value) ...[
          const SizedBox(height: 16),
          PrimaryButton(
            label: AppStrings.saveChanges,
            isLoading: profileState.isSaving,
            onPressed: () async {
              final success =
                  await ref.read(companyProfileNotifierProvider.notifier).save(
                        name: nameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        phone: _normalizeOptional(phoneCtrl.text),
                        website: _normalizeOptional(websiteCtrl.text),
                        industry: _normalizeOptional(industryCtrl.text),
                        address: _normalizeOptional(addressCtrl.text),
                      );

              if (!success) {
                return;
              }

              isEditing.value = false;
            },
            icon: Icons.save_outlined,
          ),
        ],
      ],
    );
  }

  String? _normalizeOptional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _ProfileHero extends StatelessWidget {
  final CompanyProfile profile;
  final bool isEditing;
  final VoidCallback onEditToggle;

  const _ProfileHero({
    required this.profile,
    required this.isEditing,
    required this.onEditToggle,
  });

  @override
  Widget build(BuildContext context) {
    final initials = profile.name.isEmpty
        ? '?'
        : profile.name
            .split(' ')
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0])
            .join()
            .toUpperCase();

    final statusLabel = profile.isActive ? 'Active' : 'Inactive';
    final statusColor =
        profile.isActive ? AppColors.success : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: profile.logoUrl != null
                    ? NetworkImage(profile.logoUrl!)
                    : null,
                child: profile.logoUrl == null
                    ? Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 18),
                    ),
                    if (profile.slug.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        profile.slug,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onEditToggle,
                icon: Icon(isEditing ? Icons.close : Icons.edit_outlined),
                label: Text(isEditing ? AppStrings.cancel : AppStrings.edit),
              ),
            ],
          ),
          if (profile.industry?.isNotEmpty == true) ...[
            const SizedBox(height: 14),
            Text(
              profile.industry!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.72),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompanyFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool enabled;
  final TextInputType keyboardType;
  final int maxLines;
  final String? errorText;

  const _CompanyFormField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.enabled,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: Icon(
          icon,
          size: 18,
          color: enabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  final TeamMember member;

  const _TeamMemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    final initials = member.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join()
        .toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryContainer,
            backgroundImage: member.avatarUrl != null
                ? NetworkImage(member.avatarUrl!)
                : null,
            child: member.avatarUrl == null
                ? Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  member.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: member.role == 'admin'
                  ? AppColors.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              member.role,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: member.role == 'admin'
                    ? AppColors.primary
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.22),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.45),
                    ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Divider(
        height: 20,
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
      );
}

class _SettingsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerBox(height: 240),
        SizedBox(height: 20),
        ShimmerBox(height: 120),
        SizedBox(height: 20),
        ShimmerBox(height: 200),
      ],
    );
  }
}
