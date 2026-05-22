import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../bloc/notification_bloc.dart';
import '../models/notification_settings_model.dart';

class NotificationSettingsScreen extends StatelessWidget {
  /// Pass true if current user is admin (controls edit access)
  final bool isAdmin;

  const NotificationSettingsScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc()..add(NotificationSettingsRequested()),
      child: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSettingsSaved) {
            Fluttertoast.showToast(msg: 'Notification settings saved ✅');
          }
          if (state is NotificationError) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        builder: (context, state) {
          final isLoading  = state is NotificationLoading;
          final settings   = state is NotificationSettingsLoaded ? state.settings :
                             state is NotificationSettingsSaved  ? state.settings :
                             NotificationSettings.defaults();

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A73E8),
              foregroundColor: Colors.white,
              title: Text('Notifications', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      // ── Header info ─────────────────────────────────────────
                      _infoCard(),
                      const SizedBox(height: 24),

                      // ── Toggles ─────────────────────────────────────────────
                      Text('Email Notifications', style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF1A1A1A))),
                      const SizedBox(height: 4),
                      Text('Sent to all admin email addresses in your company.',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 14),

                      _settingsCard(context, settings),
                      const SizedBox(height: 24),

                      // ── Admin-only note ─────────────────────────────────────
                      if (!isAdmin)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.lock_outline, color: Colors.orange, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Only admins can change notification settings.',
                                style: GoogleFonts.poppins(fontSize: 13, color: Colors.orange.shade800),
                              ),
                            ),
                          ]),
                        ),
                    ]),
                  ),
          );
        },
      ),
    );
  }

  Widget _infoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(children: [
      const Icon(Icons.email_outlined, color: Colors.white, size: 36),
      const SizedBox(width: 16),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Email Notifications', style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(
            'HireOps sends automated emails to your admin team when important events happen.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
        ]),
      ),
    ]),
  );

  Widget _settingsCard(BuildContext context, NotificationSettings settings) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    child: Column(children: [

      // Task 20: CV Upload toggle
      _notificationTile(
        context: context,
        icon:     Icons.upload_file_outlined,
        iconColor: const Color(0xFF1A73E8),
        title:    'New CV Uploaded',
        subtitle: 'Get notified when a CV is uploaded to your workspace.',
        value:    settings.notifyCvUpload,
        onChanged: isAdmin ? (val) {
          context.read<NotificationBloc>().add(
            NotificationSettingsUpdated(settings.copyWith(notifyCvUpload: val)),
          );
        } : null,
      ),

      const Divider(height: 1, indent: 16, endIndent: 16),

      // Task 21: Stage change toggle
      _notificationTile(
        context: context,
        icon:     Icons.swap_horiz,
        iconColor: const Color(0xFF9C27B0),
        title:    'Pipeline Stage Change',
        subtitle: 'Get notified when a candidate moves to a new pipeline stage.',
        value:    settings.notifyStageChange,
        onChanged: isAdmin ? (val) {
          context.read<NotificationBloc>().add(
            NotificationSettingsUpdated(settings.copyWith(notifyStageChange: val)),
          );
        } : null,
      ),
    ]),
  );

  Widget _notificationTile({
    required BuildContext context,
    required IconData  icon,
    required Color     iconColor,
    required String    title,
    required String    subtitle,
    required bool      value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 3),
            Text(subtitle, style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            // Email preview badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.mail_outline, size: 12, color: Color(0xFF1A73E8)),
                const SizedBox(width: 4),
                Text('Sent to all admins', style: GoogleFonts.poppins(
                    fontSize: 10, color: const Color(0xFF1A73E8))),
              ]),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value:          value,
          onChanged:      onChanged,
          activeColor:    iconColor,
          inactiveThumbColor: Colors.grey.shade400,
        ),
      ]),
    );
  }
}
