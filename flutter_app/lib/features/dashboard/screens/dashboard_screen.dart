import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/dashboard_bloc.dart';
import '../models/dashboard_model.dart';
import '../../activity/models/activity_model.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  final String companyName;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(DashboardLoadRequested()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF0F4FF),
            body: RefreshIndicator(
              onRefresh: () async =>
                  context.read<DashboardBloc>().add(DashboardRefreshRequested()),
              color: const Color(0xFF1A73E8),
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context, companyName, userName),
                  if (state is DashboardLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8))),
                    )
                  else if (state is DashboardError)
                    SliverFillRemaining(child: _buildError(state.message))
                  else if (state is DashboardLoaded)
                    _buildContent(context, state.data)
                  else
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────
  SliverAppBar _buildAppBar(BuildContext context, String company, String user) {
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      backgroundColor: const Color(0xFF1A73E8),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('👋 Hello, ${user.split(' ').first}!',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 4),
            Text(company, style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Dashboard Overview', style: GoogleFonts.poppins(
                color: Colors.white60, fontSize: 12)),
          ]),
        ),
      ),
      actions: [
        Builder(builder: (ctx) => IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => ctx.read<DashboardBloc>().add(DashboardRefreshRequested()),
        )),
      ],
    );
  }

  // ── Main Content ─────────────────────────────────────────────────────────────
  SliverList _buildContent(BuildContext context, DashboardData data) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 20),

        // ── Stat cards ────────────────────────────────────────────────────
        _sectionLabel('Overview'),
        _buildStatCards(data),
        const SizedBox(height: 20),

        // ── Pipeline breakdown ────────────────────────────────────────────
        _sectionLabel('Pipeline Breakdown'),
        _buildPipelineBreakdown(data.pipelineStages),
        const SizedBox(height: 20),

        // ── CV trend chart ────────────────────────────────────────────────
        _sectionLabel('CVs Added — Last 7 Days'),
        _buildTrendChart(data.cvTrend),
        const SizedBox(height: 20),

        // ── Recent candidates ─────────────────────────────────────────────
        _sectionLabel('Recent Candidates'),
        _buildRecentCandidates(data.recentCandidates),
        const SizedBox(height: 20),

        // ── Recent activity ───────────────────────────────────────────────
        _sectionLabel('Recent Activity'),
        _buildRecentActivity(data.recentActivity),
        const SizedBox(height: 32),
      ]),
    );
  }

  // ── Stat Cards ────────────────────────────────────────────────────────────────
  Widget _buildStatCards(DashboardData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        Row(children: [
          _statCard('Total Candidates', '${data.candidates.total}',
              Icons.people_outline, const Color(0xFF1A73E8), '+${data.candidates.addedThisWeek} this week'),
          const SizedBox(width: 12),
          _statCard('Open Jobs', '${data.jobs.open}',
              Icons.work_outline, const Color(0xFF34A853), '${data.jobs.total} total'),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _statCard('Hired', '${data.candidates.hired}',
              Icons.celebration_outlined, const Color(0xFF0F9D58), 'Successful hires'),
          const SizedBox(width: 12),
          _statCard('Added Today', '${data.candidates.addedToday}',
              Icons.today_outlined, const Color(0xFFF9AB00), 'New CVs today'),
        ]),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF0)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.06),
              blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Text(value, style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          ]),
          const SizedBox(height: 10),
          Text(label, style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A))),
          const SizedBox(height: 2),
          Text(sub, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
        ]),
      ),
    );
  }

  // ── Pipeline Breakdown ────────────────────────────────────────────────────────
  Widget _buildPipelineBreakdown(List<PipelineStageStat> stages) {
    final total = stages.fold(0, (sum, s) => sum + s.candidateCount);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(children: [
        // Stacked bar
        if (total > 0) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 20,
              child: Row(
                children: stages.where((s) => s.candidateCount > 0).map((s) {
                  final pct = s.candidateCount / total;
                  return Expanded(
                    flex: (pct * 1000).round(),
                    child: Container(
                      color: _hexColor(s.color),
                      child: pct > 0.08 ? Center(
                        child: Text('${s.candidateCount}', style: const TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ) : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ] else
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('No candidates in pipeline yet.',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
          ),

        // Legend
        Wrap(
          spacing: 12, runSpacing: 8,
          children: stages.map((s) => Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 10, height: 10,
                decoration: BoxDecoration(color: _hexColor(s.color), shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text('${s.name} (${s.candidateCount})',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade700)),
          ])).toList(),
        ),
      ]),
    );
  }

  // ── CV Trend Chart (bar chart) ────────────────────────────────────────────────
  Widget _buildTrendChart(List<TrendPoint> trend) {
    final maxCount = trend.isEmpty ? 1 :
        trend.map((t) => t.count).reduce((a, b) => a > b ? a : b);
    final peak = maxCount < 1 ? 1 : maxCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(children: [
        // Bar chart
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: trend.map((t) {
              final heightPct = peak > 0 ? t.count / peak : 0.0;
              final barHeight = heightPct * 80 + (t.count > 0 ? 4 : 0);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (t.count > 0)
                        Text('${t.count}', style: GoogleFonts.poppins(
                            fontSize: 9, color: const Color(0xFF1A73E8),
                            fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: t.count > 0
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFFE8ECF0),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // X-axis labels
        const SizedBox(height: 8),
        Row(
          children: trend.map((t) => Expanded(
            child: Text(t.shortDate, textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey)),
          )).toList(),
        ),
      ]),
    );
  }

  // ── Recent Candidates ─────────────────────────────────────────────────────────
  Widget _buildRecentCandidates(List<RecentCandidate> candidates) {
    if (candidates.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF0)),
        ),
        child: Center(child: Text('No candidates yet.',
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13))),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        children: candidates.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          final statusColors = {
            'new': const Color(0xFF1A73E8), 'active': const Color(0xFF34A853),
            'hired': const Color(0xFF0F9D58), 'rejected': Colors.red,
          };
          final color = statusColors[c.status] ?? const Color(0xFF1A73E8);

          return Column(children: [
            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.12),
                  child: Text(c.name[0].toUpperCase(),
                      style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.name, style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 13)),
                  if (c.currentTitle != null)
                    Text(c.currentTitle!, style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(c.status, style: GoogleFonts.poppins(
                      fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  // ── Recent Activity ────────────────────────────────────────────────────────────
  Widget _buildRecentActivity(List<ActivityModel> activities) {
    if (activities.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF0)),
        ),
        child: Center(child: Text('No activity yet.',
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13))),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0)),
      ),
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final i = entry.key;
          final a = entry.value;
          return Column(children: [
            if (i > 0) const Divider(height: 1, indent: 56, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Color(a.colorHex).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(a.iconLabel,
                      style: const TextStyle(fontSize: 16))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.description, style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(a.timeAgo, style: GoogleFonts.poppins(
                      fontSize: 10, color: Colors.grey)),
                ])),
              ]),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
    child: Text(label, style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A))),
  );

  Widget _buildError(String message) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, size: 48, color: Colors.grey),
      const SizedBox(height: 12),
      Text(message, style: GoogleFonts.poppins(color: Colors.grey)),
    ]),
  );

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF1A73E8);
    }
  }
}
