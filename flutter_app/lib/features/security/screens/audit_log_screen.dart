import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/audit_log_model.dart';
import '../repositories/audit_repository.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});
  @override State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  final _repo    = AuditRepository();
  List<AuditLogModel> _logs      = [];
  bool                _isLoading = true;
  String?             _filterType;
  int                 _page      = 1;
  bool                _hasMore   = true;

  final _filters = [
    {'label': 'All',       'value': null},
    {'label': 'Auth',      'value': 'auth'},
    {'label': 'Users',     'value': 'user'},
    {'label': 'Candidates','value': 'candidate'},
    {'label': 'Jobs',      'value': 'job'},
    {'label': 'Pipeline',  'value': 'pipeline'},
    {'label': 'Settings',  'value': 'settings'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      setState(() { _logs = []; _page = 1; _hasMore = true; });
    }
    setState(() => _isLoading = true);
    try {
      final result = await _repo.getAuditLog(
        action:     _filterType != null ? '$_filterType.' : null,
        page:       _page,
      );
      final newLogs = result['logs'] as List<AuditLogModel>;
      final pagination = result['pagination'] as Map<String, dynamic>;
      setState(() {
        _logs    = reset ? newLogs : [..._logs, ...newLogs];
        _hasMore = _page < (pagination['pages'] ?? 1);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _applyFilter(String? value) {
    setState(() => _filterType = value);
    _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Audit Log', style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 16)),
          Text('Security & compliance trail', style: GoogleFonts.poppins(
              fontSize: 11, color: Colors.white70)),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _load(reset: true),
          ),
        ],
      ),
      body: Column(children: [
        // Security summary banner
        _buildSecurityBanner(),

        // Filter chips
        _buildFilterRow(),

        // Log list
        Expanded(
          child: _isLoading && _logs.isEmpty
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
              : _logs.isEmpty
                  ? _buildEmpty()
                  : _buildList(),
        ),
      ]),
    );
  }

  Widget _buildSecurityBanner() => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(children: [
      const Icon(Icons.security, color: Colors.white, size: 28),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Security Audit Trail', style: GoogleFonts.poppins(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text('All sensitive actions are logged with user, IP, and timestamp.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('${_logs.length} entries', style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
      ),
    ]),
  );

  Widget _buildFilterRow() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    child: Row(
      children: _filters.map((f) {
        final selected = _filterType == f['value'];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => _applyFilter(f['value'] as String?),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color:  selected ? const Color(0xFF1A73E8) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: selected ? const Color(0xFF1A73E8) : Colors.grey.shade300),
              ),
              child: Text(f['label'] as String, style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.grey.shade700,
              )),
            ),
          ),
        );
      }).toList(),
    ),
  );

  Widget _buildEmpty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.policy_outlined, size: 64, color: Colors.grey),
      const SizedBox(height: 16),
      Text('No audit entries yet', style: GoogleFonts.poppins(
          fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Text('Actions will be logged as your team uses HireOps.',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
    ]),
  );

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _logs.length + (_hasMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == _logs.length) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed: () { _page++; _load(); },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A73E8)),
                child: Text('Load more', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ),
          );
        }
        return _auditCard(_logs[i]);
      },
    );
  }

  Widget _auditCard(AuditLogModel log) {
    final color = Color(log.colorHex);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Icon
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text(log.iconLabel,
                style: const TextStyle(fontSize: 17))),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Action badge
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(log.actionLabel.toUpperCase(),
                      style: GoogleFonts.poppins(
                          fontSize: 9, color: color, fontWeight: FontWeight.w700,
                          letterSpacing: 0.3)),
                ),
              ]),
              const SizedBox(height: 5),

              // Description
              Text(log.description, style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),

              // Meta row: user, IP, time
              Wrap(spacing: 10, runSpacing: 4, children: [
                if (log.userName != null)
                  _metaChip(Icons.person_outline, log.userName!),
                if (log.ipAddress != null)
                  _metaChip(Icons.router_outlined, log.ipAddress!),
                _metaChip(Icons.access_time, log.timeAgo),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 11, color: Colors.grey.shade500),
      const SizedBox(width: 3),
      Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade600)),
    ],
  );
}
