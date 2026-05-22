import '../../activity/models/activity_model.dart';

// ── Candidate Stats ────────────────────────────────────────────────────────────
class CandidateStats {
  final int total, newCount, active, hired, rejected, addedToday, addedThisWeek;
  const CandidateStats({
    required this.total, required this.newCount, required this.active,
    required this.hired, required this.rejected,
    required this.addedToday, required this.addedThisWeek,
  });
  factory CandidateStats.fromJson(Map<String, dynamic> j) => CandidateStats(
    total:          j['total']          ?? 0,
    newCount:       j['new']            ?? 0,
    active:         j['active']         ?? 0,
    hired:          j['hired']          ?? 0,
    rejected:       j['rejected']       ?? 0,
    addedToday:     j['added_today']    ?? 0,
    addedThisWeek:  j['added_this_week']?? 0,
  );
}

// ── Job Stats ─────────────────────────────────────────────────────────────────
class JobStats {
  final int total, open, closed;
  const JobStats({required this.total, required this.open, required this.closed});
  factory JobStats.fromJson(Map<String, dynamic> j) => JobStats(
    total:  j['total']  ?? 0,
    open:   j['open']   ?? 0,
    closed: j['closed'] ?? 0,
  );
}

// ── Pipeline Stage Stat ───────────────────────────────────────────────────────
class PipelineStageStat {
  final int    id, orderIndex, candidateCount;
  final String name, color;
  const PipelineStageStat({
    required this.id, required this.name, required this.color,
    required this.orderIndex, required this.candidateCount,
  });
  factory PipelineStageStat.fromJson(Map<String, dynamic> j) => PipelineStageStat(
    id:             j['id'],
    name:           j['name'],
    color:          j['color'] ?? '#1A73E8',
    orderIndex:     j['order_index']     ?? 0,
    candidateCount: j['candidate_count'] ?? 0,
  );
}

// ── CV Trend Point ────────────────────────────────────────────────────────────
class TrendPoint {
  final String date;
  final int    count;
  const TrendPoint({required this.date, required this.count});
  factory TrendPoint.fromJson(Map<String, dynamic> j) =>
      TrendPoint(date: j['date'], count: j['count'] ?? 0);

  String get shortDate {
    try {
      final parts = date.split('-');
      return '${parts[2]}/${parts[1]}';
    } catch (_) { return date; }
  }
}

// ── Recent Candidate ──────────────────────────────────────────────────────────
class RecentCandidate {
  final int    id;
  final String name, status;
  final String? currentTitle, cvName, createdAt;
  final int    experienceYears;
  const RecentCandidate({
    required this.id, required this.name, required this.status,
    this.currentTitle, this.cvName, this.createdAt,
    required this.experienceYears,
  });
  factory RecentCandidate.fromJson(Map<String, dynamic> j) => RecentCandidate(
    id:              j['id'],
    name:            j['name'],
    status:          j['status'] ?? 'new',
    currentTitle:    j['current_title'],
    cvName:          j['cv_name'],
    createdAt:       j['created_at'],
    experienceYears: j['experience_years'] ?? 0,
  );
}

// ── Dashboard Data ────────────────────────────────────────────────────────────
class DashboardData {
  final CandidateStats           candidates;
  final JobStats                 jobs;
  final List<PipelineStageStat>  pipelineStages;
  final List<ActivityModel>      recentActivity;
  final List<RecentCandidate>    recentCandidates;
  final List<TrendPoint>         cvTrend;

  const DashboardData({
    required this.candidates,
    required this.jobs,
    required this.pipelineStages,
    required this.recentActivity,
    required this.recentCandidates,
    required this.cvTrend,
  });

  factory DashboardData.fromJson(Map<String, dynamic> data) => DashboardData(
    candidates:      CandidateStats.fromJson(data['candidates']),
    jobs:            JobStats.fromJson(data['jobs']),
    pipelineStages:  (data['pipeline_stages'] as List)
                        .map((s) => PipelineStageStat.fromJson(s)).toList(),
    recentActivity:  (data['recent_activity'] as List)
                        .map((a) => ActivityModel.fromJson(a)).toList(),
    recentCandidates:(data['recent_candidates'] as List)
                        .map((c) => RecentCandidate.fromJson(c)).toList(),
    cvTrend:         (data['cv_trend'] as List)
                        .map((t) => TrendPoint.fromJson(t)).toList(),
  );
}
