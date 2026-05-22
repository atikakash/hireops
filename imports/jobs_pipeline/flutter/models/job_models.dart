// ── Job Model ─────────────────────────────────────────────────────────────────
class JobModel {
  final int     id;
  final String  title;
  final String? department;
  final String? location;
  final String  type;
  final String? description;
  final String? requirements;
  final bool    isOpen;
  final int     candidateCount;
  final String? createdByName;
  final String? createdAt;

  const JobModel({
    required this.id,
    required this.title,
    this.department,
    this.location,
    required this.type,
    this.description,
    this.requirements,
    required this.isOpen,
    required this.candidateCount,
    this.createdByName,
    this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
    id:             json['id'],
    title:          json['title'],
    department:     json['department'],
    location:       json['location'],
    type:           json['type'] ?? 'full_time',
    description:    json['description'],
    requirements:   json['requirements'],
    isOpen:         json['is_open'] == 1 || json['is_open'] == true,
    candidateCount: json['candidate_count'] ?? 0,
    createdByName:  json['created_by_name'],
    createdAt:      json['created_at'],
  );

  String get typeLabel {
    switch (type) {
      case 'full_time':  return 'Full Time';
      case 'part_time':  return 'Part Time';
      case 'contract':   return 'Contract';
      case 'internship': return 'Internship';
      default:           return 'Full Time';
    }
  }
}

// ── Pipeline Stage Model ──────────────────────────────────────────────────────
class PipelineStageModel {
  final int    id;
  final String name;
  final int    orderIndex;
  final String color;
  final List<PipelineCandidateModel> candidates;

  const PipelineStageModel({
    required this.id,
    required this.name,
    required this.orderIndex,
    required this.color,
    required this.candidates,
  });

  factory PipelineStageModel.fromJson(Map<String, dynamic> json) {
    final stageData  = json['stage'] as Map<String, dynamic>;
    final candList   = json['candidates'] as List? ?? [];
    return PipelineStageModel(
      id:         stageData['id'],
      name:       stageData['name'],
      orderIndex: stageData['order_index'] ?? 0,
      color:      stageData['color'] ?? '#1A73E8',
      candidates: candList.map((c) => PipelineCandidateModel.fromJson(c)).toList(),
    );
  }
}

// ── Pipeline Candidate Model ──────────────────────────────────────────────────
class PipelineCandidateModel {
  final int     assignmentId;
  final int     candidateId;
  final String  name;
  final String? email;
  final String? currentTitle;
  final int     experienceYears;
  final List<String> skills;
  final List<String> tags;
  final String? cvName;
  final String? notes;
  final String? movedAt;

  const PipelineCandidateModel({
    required this.assignmentId,
    required this.candidateId,
    required this.name,
    this.email,
    this.currentTitle,
    required this.experienceYears,
    required this.skills,
    required this.tags,
    this.cvName,
    this.notes,
    this.movedAt,
  });

  factory PipelineCandidateModel.fromJson(Map<String, dynamic> json) {
    List<String> parseList(dynamic val) {
      if (val == null) return [];
      if (val is List) return val.map((e) => e.toString()).toList();
      return [];
    }
    return PipelineCandidateModel(
      assignmentId:    json['assignment_id'],
      candidateId:     json['candidate_id'],
      name:            json['name'],
      email:           json['email'],
      currentTitle:    json['current_title'],
      experienceYears: json['experience_years'] ?? 0,
      skills:          parseList(json['skills']),
      tags:            parseList(json['tags']),
      cvName:          json['cv_name'],
      notes:           json['notes'],
      movedAt:         json['moved_at'],
    );
  }
}
