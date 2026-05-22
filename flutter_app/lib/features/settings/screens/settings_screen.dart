import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../bloc/settings_bloc.dart';
import '../models/settings_model.dart';

class SettingsScreen extends StatelessWidget {
  final bool isAdmin;
  const SettingsScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(SettingsLoadRequested()),
      child: DefaultTabController(
        length: 3,
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsSaveSuccess) {
              Fluttertoast.showToast(msg: state.message);
            } else if (state is SettingsError) {
              Fluttertoast.showToast(msg: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is SettingsLoading;
            final settings  = state is SettingsLoaded       ? state.settings :
                              state is SettingsSaving        ? state.settings :
                              state is SettingsSaveSuccess   ? state.settings : null;
            final isSaving  = state is SettingsSaving;

            return Scaffold(
              backgroundColor: const Color(0xFFF8F9FA),
              appBar: AppBar(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                title: Text('Settings', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                  unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(icon: Icon(Icons.business_outlined, size: 18), text: 'Company'),
                    Tab(icon: Icon(Icons.view_kanban_outlined, size: 18), text: 'Pipeline'),
                    Tab(icon: Icon(Icons.notifications_outlined, size: 18), text: 'Alerts'),
                  ],
                ),
              ),
              body: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
                  : settings == null
                      ? _buildError(context)
                      : TabBarView(children: [
                          // Task 26: Company info
                          _CompanyTab(
                              settings: settings.company,
                              isAdmin: isAdmin,
                              isSaving: isSaving),

                          // Task 27: Pipeline stages
                          _PipelineTab(
                              stages: settings.stages,
                              isAdmin: isAdmin,
                              isSaving: isSaving),

                          // Task 28: Notification toggles
                          _NotificationsTab(
                              notifications: settings.notifications,
                              isAdmin: isAdmin),
                        ]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, size: 48, color: Colors.grey),
      const SizedBox(height: 12),
      Text('Failed to load settings.', style: GoogleFonts.poppins(color: Colors.grey)),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () => context.read<SettingsBloc>().add(SettingsLoadRequested()),
        child: const Text('Retry'),
      ),
    ]),
  );
}

// ── Tab 1: Company Info ───────────────────────────────────────────────────────
class _CompanyTab extends StatefulWidget {
  final CompanySettings settings;
  final bool isAdmin, isSaving;
  const _CompanyTab({required this.settings, required this.isAdmin, required this.isSaving});
  @override State<_CompanyTab> createState() => _CompanyTabState();
}

class _CompanyTabState extends State<_CompanyTab> {
  late final TextEditingController _nameCtrl, _emailCtrl, _phoneCtrl,
      _websiteCtrl, _industryCtrl, _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.settings.name);
    _emailCtrl    = TextEditingController(text: widget.settings.email);
    _phoneCtrl    = TextEditingController(text: widget.settings.phone    ?? '');
    _websiteCtrl  = TextEditingController(text: widget.settings.website  ?? '');
    _industryCtrl = TextEditingController(text: widget.settings.industry ?? '');
    _addressCtrl  = TextEditingController(text: widget.settings.address  ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _websiteCtrl.dispose(); _industryCtrl.dispose(); _addressCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Company name and email are required.');
      return;
    }
    context.read<SettingsBloc>().add(CompanySettingsUpdateSubmitted(
      name:     _nameCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      phone:    _phoneCtrl.text.trim().isEmpty    ? null : _phoneCtrl.text.trim(),
      website:  _websiteCtrl.text.trim().isEmpty  ? null : _websiteCtrl.text.trim(),
      industry: _industryCtrl.text.trim().isEmpty ? null : _industryCtrl.text.trim(),
      address:  _addressCtrl.text.trim().isEmpty  ? null : _addressCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _adminOnlyBanner(widget.isAdmin),
        _card(Column(children: [
          _field('Company Name *', _nameCtrl, Icons.business_outlined,  enabled: widget.isAdmin),
          const SizedBox(height: 12),
          _field('Company Email *', _emailCtrl, Icons.email_outlined,    enabled: widget.isAdmin),
          const SizedBox(height: 12),
          _field('Phone',    _phoneCtrl,    Icons.phone_outlined,        enabled: widget.isAdmin),
          const SizedBox(height: 12),
          _field('Website',  _websiteCtrl,  Icons.language_outlined,     enabled: widget.isAdmin),
          const SizedBox(height: 12),
          _field('Industry', _industryCtrl, Icons.category_outlined,     enabled: widget.isAdmin),
          const SizedBox(height: 12),
          _field('Address',  _addressCtrl,  Icons.location_on_outlined,  enabled: widget.isAdmin, maxLines: 3),
        ])),
        if (widget.isAdmin) ...[
          const SizedBox(height: 20),
          _saveButton(context, 'Save Company Info', widget.isSaving, _save),
        ],
      ]),
    );
  }
}

// ── Tab 2: Pipeline Stages ────────────────────────────────────────────────────
class _PipelineTab extends StatefulWidget {
  final List<PipelineStageSetting> stages;
  final bool isAdmin, isSaving;
  const _PipelineTab({required this.stages, required this.isAdmin, required this.isSaving});
  @override State<_PipelineTab> createState() => _PipelineTabState();
}

class _PipelineTabState extends State<_PipelineTab> {
  late List<PipelineStageSetting> _stages;
  late List<TextEditingController> _ctrls;

  final List<String> _colorOptions = [
    '#8E8E93', '#1A73E8', '#F9AB00', '#9C27B0',
    '#34A853', '#EA4335', '#FF6D00', '#00BCD4',
  ];

  @override
  void initState() {
    super.initState();
    _stages = List.from(widget.stages);
    _ctrls  = _stages.map((s) => TextEditingController(text: s.name)).toList();
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final updated = _stages.asMap().entries.map((e) =>
        e.value.copyWith(name: _ctrls[e.key].text.trim())).toList();
    context.read<SettingsBloc>().add(PipelineStagesUpdateSubmitted(updated));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _adminOnlyBanner(widget.isAdmin),
        _card(Column(
          children: _stages.asMap().entries.map((entry) {
            final i     = entry.key;
            final stage = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(children: [
                // Color dot / picker
                GestureDetector(
                  onTap: widget.isAdmin ? () => _showColorPicker(context, i) : null,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _hexColor(stage.color),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: widget.isAdmin
                        ? const Icon(Icons.colorize, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // Stage name field
                Expanded(
                  child: TextField(
                    controller: _ctrls[i],
                    enabled: widget.isAdmin,
                    onChanged: (v) => setState(() {
                      _stages[i] = stage.copyWith(name: v);
                    }),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: widget.isAdmin ? Colors.white : const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF1A73E8))),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                ),

                // Order badge
                const SizedBox(width: 10),
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('${i + 1}', style: GoogleFonts.poppins(
                        fontSize: 11, color: const Color(0xFF1A73E8),
                        fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            );
          }).toList(),
        )),
        if (widget.isAdmin) ...[
          const SizedBox(height: 20),
          _saveButton(context, 'Save Pipeline Stages', widget.isSaving, _save),
        ],
      ]),
    );
  }

  void _showColorPicker(BuildContext context, int stageIndex) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Pick Stage Color', style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          Wrap(spacing: 12, runSpacing: 12, children: _colorOptions.map((hex) {
            final isSelected = _stages[stageIndex].color == hex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _stages[stageIndex] = _stages[stageIndex].copyWith(color: hex);
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: _hexColor(hex), shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent, width: 3),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
              ),
            );
          }).toList()),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Color _hexColor(String hex) {
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); }
    catch (_) { return const Color(0xFF1A73E8); }
  }
}

// ── Tab 3: Notifications ──────────────────────────────────────────────────────
class _NotificationsTab extends StatelessWidget {
  final NotifSettings notifications;
  final bool isAdmin;
  const _NotificationsTab({required this.notifications, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _adminOnlyBanner(isAdmin),
        _card(Column(children: [
          _notifTile(
            context: context,
            icon:     Icons.upload_file_outlined,
            color:    const Color(0xFF1A73E8),
            title:    'New CV Uploaded',
            subtitle: 'Email admins when a new CV is uploaded.',
            value:    notifications.notifyCvUpload,
            onChanged: isAdmin ? (val) {
              context.read<SettingsBloc>().add(
                NotificationSettingsUpdateSubmitted(
                    notifications.copyWith(notifyCvUpload: val)));
            } : null,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _notifTile(
            context: context,
            icon:     Icons.swap_horiz,
            color:    const Color(0xFF9C27B0),
            title:    'Stage Changed',
            subtitle: 'Email admins when a candidate moves to a new stage.',
            value:    notifications.notifyStageChange,
            onChanged: isAdmin ? (val) {
              context.read<SettingsBloc>().add(
                NotificationSettingsUpdateSubmitted(
                    notifications.copyWith(notifyStageChange: val)));
            } : null,
          ),
        ])),
      ]),
    );
  }

  Widget _notifTile({
    required BuildContext context,
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required bool value, required ValueChanged<bool>? onChanged,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 22),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 2),
        Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
      ])),
      Switch.adaptive(
        value: value, onChanged: onChanged, activeColor: color,
      ),
    ]),
  );
}

// ── Shared helpers ────────────────────────────────────────────────────────────
Widget _adminOnlyBanner(bool isAdmin) {
  if (isAdmin) return const SizedBox.shrink();
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.orange.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.orange.withOpacity(0.3)),
    ),
    child: Row(children: [
      const Icon(Icons.lock_outline, color: Colors.orange, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text('View only — only admins can change settings.',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange.shade800))),
    ]),
  );
}

Widget _card(Widget child) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFE0E0E0)),
  ),
  child: child,
);

Widget _field(String label, TextEditingController ctrl, IconData icon,
    {bool enabled = true, int maxLines = 1}) =>
  TextField(
    controller: ctrl, enabled: enabled, maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1A73E8), size: 20),
      filled: true,
      fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A73E8))),
      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    ),
  );

Widget _saveButton(BuildContext context, String label, bool isSaving,
    void Function(BuildContext) onSave) =>
  SizedBox(
    width: double.infinity, height: 50,
    child: ElevatedButton(
      onPressed: isSaving ? null : () => onSave(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A73E8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isSaving
          ? const SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(label, style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
    ),
  );
