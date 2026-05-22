import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/job_bloc.dart';
import '../models/job_models.dart';

class PipelineScreen extends StatelessWidget {
  final JobModel job;
  const PipelineScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobBloc, JobState>(
      listener: (context, state) {
        if (state is JobActionSuccess) {
          Fluttertoast.showToast(msg: state.message);
          // Reload pipeline after move
          if (state.board != null) return;
          context.read<JobBloc>().add(PipelineLoadRequested(job.id));
        }
        if (state is JobError) Fluttertoast.showToast(msg: state.message);
      },
      builder: (context, state) {
        final board = state is PipelineLoaded     ? state.board :
                      state is JobActionSuccess    ? (state.board ?? <PipelineStageModel>[])
                      : <PipelineStageModel>[];
        final isLoading = state is JobLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(job.title, style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16)),
              Text('Pipeline Board', style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.white70)),
            ]),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<JobBloc>().add(PipelineLoadRequested(job.id)),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
              : board.isEmpty
                  ? _buildEmpty()
                  : _buildBoard(context, board),
        );
      },
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.view_kanban_outlined, size: 72, color: Colors.grey),
      const SizedBox(height: 16),
      Text('No candidates in pipeline', style: GoogleFonts.poppins(
          fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Text('Assign candidates to this job to see the pipeline.',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
    ]),
  );

  Widget _buildBoard(BuildContext context, List<PipelineStageModel> board) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      itemCount: board.length,
      itemBuilder: (_, i) => _stageColumn(context, board[i], board),
    );
  }

  Widget _stageColumn(BuildContext context, PipelineStageModel stage,
      List<PipelineStageModel> allStages) {
    final stageColor = _hexColor(stage.color);

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Stage header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: stageColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(children: [
            Expanded(
              child: Text(stage.name, style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${stage.candidates.length}',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),

        // Candidate cards
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: stage.candidates.isEmpty
                ? Center(
                    child: Text('No candidates', style: GoogleFonts.poppins(
                        color: Colors.grey.shade400, fontSize: 12)))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stage.candidates.length,
                    itemBuilder: (_, i) =>
                        _candidateCard(context, stage.candidates[i], stage, allStages),
                  ),
          ),
        ),
      ]),
    );
  }

  Widget _candidateCard(BuildContext context, PipelineCandidateModel c,
      PipelineStageModel currentStage, List<PipelineStageModel> allStages) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Name + menu
          Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1A73E8).withValues(alpha: 0.12),
              child: Text(c.name[0].toUpperCase(),
                  style: const TextStyle(color: Color(0xFF1A73E8),
                      fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(c.name, style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 12),
                overflow: TextOverflow.ellipsis),
            ),
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert, size: 16, color: Colors.grey),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onSelected: (stageId) {
                context.read<JobBloc>().add(CandidateStageMoveRequested(
                  jobId:       job.id,
                  candidateId: c.candidateId,
                  stageId:     stageId,
                ));
              },
              itemBuilder: (_) => [
                const PopupMenuItem(enabled: false,
                  child: Text('Move to stage', style: TextStyle(
                      fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600))),
                ...allStages
                  .where((s) => s.id != currentStage.id)
                  .map((s) => PopupMenuItem<int>(
                    value: s.id,
                    child: Row(children: [
                      Container(width: 10, height: 10,
                          decoration: BoxDecoration(
                              color: _hexColor(s.color), shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(s.name, style: GoogleFonts.poppins(fontSize: 13)),
                    ]),
                  )),
              ],
            ),
          ]),

          // Job title
          if (c.currentTitle != null) ...[
            const SizedBox(height: 4),
            Text(c.currentTitle!, style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis),
          ],

          // Experience
          const SizedBox(height: 6),
          Row(children: [
            Icon(Icons.work_outline, size: 11, color: Colors.grey.shade400),
            const SizedBox(width: 3),
            Text('${c.experienceYears} yrs exp',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
            if (c.cvName != null) ...[
              const SizedBox(width: 8),
              const Icon(Icons.description_outlined, size: 11, color: Color(0xFF34A853)),
              const SizedBox(width: 3),
              Text('CV', style: GoogleFonts.poppins(
                  fontSize: 10, color: const Color(0xFF34A853))),
            ],
          ]),

          // Skills
          if (c.skills.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(spacing: 4, runSpacing: 4,
              children: c.skills.take(2).map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(s, style: GoogleFonts.poppins(
                    fontSize: 9, color: const Color(0xFF1A73E8))),
              )).toList(),
            ),
          ],
        ]),
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } on Object {
      return const Color(0xFF1A73E8);
    }
  }
}
