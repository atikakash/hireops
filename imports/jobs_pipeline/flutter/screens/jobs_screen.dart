import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/job_bloc.dart';
import '../models/job_models.dart';
import 'pipeline_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});
  @override State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  bool? _filterOpen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobBloc()..add(const JobsLoadRequested()),
      child: BlocConsumer<JobBloc, JobState>(
        listener: (context, state) {
          if (state is JobActionSuccess) Fluttertoast.showToast(msg: state.message);
          if (state is JobError)         Fluttertoast.showToast(msg: state.message);
        },
        builder: (context, state) {
          final jobs = state is JobsLoaded       ? state.jobs :
                       state is JobActionSuccess  ? (state.jobs ?? <JobModel>[]) : <JobModel>[];
          final isLoading = state is JobLoading;

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: _buildAppBar(context, jobs.length),
            body: Column(children: [
              _buildFilterRow(context),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
                    : jobs.isEmpty ? _buildEmpty()
                    : _buildList(context, jobs),
              ),
            ]),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showCreateJobSheet(context),
              backgroundColor: const Color(0xFF1A73E8),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('New Job', style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, int count) => AppBar(
    backgroundColor: const Color(0xFF1A73E8),
    foregroundColor: Colors.white,
    title: Text('Job Positions', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Chip(
          label: Text('$count jobs',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white)),
          backgroundColor: Colors.white.withValues(alpha: 0.2),
        ),
      ),
    ],
  );

  Widget _buildFilterRow(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(children: [
      _filterChip('All',  null,  _filterOpen, (v) { setState(() => _filterOpen = v); context.read<JobBloc>().add(JobsLoadRequested(isOpen: v)); }),
      const SizedBox(width: 8),
      _filterChip('Open', true,  _filterOpen, (v) { setState(() => _filterOpen = v); context.read<JobBloc>().add(JobsLoadRequested(isOpen: v)); }),
      const SizedBox(width: 8),
      _filterChip('Closed', false, _filterOpen, (v) { setState(() => _filterOpen = v); context.read<JobBloc>().add(JobsLoadRequested(isOpen: v)); }),
    ]),
  );

  Widget _filterChip(String label, bool? value, bool? current, Function(bool?) onTap) {
    final selected = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:  selected ? const Color(0xFF1A73E8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFF1A73E8) : Colors.grey.shade300),
        ),
        child: Text(label, style: GoogleFonts.poppins(
          fontSize: 12, fontWeight: FontWeight.w500,
          color: selected ? Colors.white : Colors.grey.shade700,
        )),
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.work_outline, size: 72, color: Colors.grey),
      const SizedBox(height: 16),
      Text('No jobs yet', style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
      const SizedBox(height: 8),
      Text('Create your first job position using the button below.',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
    ]),
  );

  Widget _buildList(BuildContext context, List<JobModel> jobs) =>
    ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: jobs.length,
      itemBuilder: (_, i) => _jobCard(context, jobs[i]),
    );

  Widget _jobCard(BuildContext context, JobModel job) {
    final typeColors = {
      'full_time':  const Color(0xFF1A73E8),
      'part_time':  const Color(0xFF9C27B0),
      'contract':   const Color(0xFFF9AB00),
      'internship': const Color(0xFF34A853),
    };
    final color = typeColors[job.type] ?? const Color(0xFF1A73E8);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => JobBloc()..add(PipelineLoadRequested(job.id)),
            child: PipelineScreen(job: job),
          ),
        )),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(job.title, style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (job.isOpen ? const Color(0xFF34A853) : Colors.grey).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(job.isOpen ? 'Open' : 'Closed',
                    style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: job.isOpen ? const Color(0xFF34A853) : Colors.grey,
                    )),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (action) {
                  if (action == 'pipeline') {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => JobBloc()..add(PipelineLoadRequested(job.id)),
                        child: PipelineScreen(job: job),
                      ),
                    ));
                  } else if (action == 'delete') {
                    context.read<JobBloc>().add(JobDeleteRequested(job.id));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'pipeline',
                    child: Row(children: [
                      const Icon(Icons.view_kanban_outlined, size: 18, color: Color(0xFF1A73E8)),
                      const SizedBox(width: 8),
                      Text('View Pipeline', style: GoogleFonts.poppins(fontSize: 13)),
                    ])),
                  PopupMenuItem(value: 'delete',
                    child: Row(children: [
                      const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      Text('Delete', style: GoogleFonts.poppins(fontSize: 13, color: Colors.red)),
                    ])),
                ],
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              if (job.department != null) ...[
                Icon(Icons.apartment_outlined, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(job.department!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 12),
              ],
              if (job.location != null) ...[
                Icon(Icons.location_on_outlined, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(job.location!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(job.typeLabel, style: GoogleFonts.poppins(
                    fontSize: 11, color: color, fontWeight: FontWeight.w500)),
              ),
              const Spacer(),
              Icon(Icons.people_outline, size: 15, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text('${job.candidateCount} candidates',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
            ]),
          ]),
        ),
      ),
    );
  }

  void _showCreateJobSheet(BuildContext context) {
    final titleCtrl  = TextEditingController();
    final deptCtrl   = TextEditingController();
    final locCtrl    = TextEditingController();
    final descCtrl   = TextEditingController();
    String jobType   = 'full_time';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<JobBloc>(),
        child: StatefulBuilder(builder: (ctx, setState) {
          return Container(
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text('Create New Job', style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _sheetField('Job Title *', titleCtrl, Icons.work_outline),
                const SizedBox(height: 12),
                _sheetField('Department', deptCtrl, Icons.apartment_outlined),
                const SizedBox(height: 12),
                _sheetField('Location', locCtrl, Icons.location_on_outlined),
                const SizedBox(height: 12),

                // Job type selector
                Text('Type', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  for (final t in [
                    {'value': 'full_time', 'label': 'Full Time'},
                    {'value': 'part_time', 'label': 'Part Time'},
                    {'value': 'contract',  'label': 'Contract'},
                    {'value': 'internship','label': 'Internship'},
                  ])
                    GestureDetector(
                      onTap: () => setState(() => jobType = t['value']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: jobType == t['value'] ? const Color(0xFF1A73E8) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: jobType == t['value']
                              ? const Color(0xFF1A73E8) : Colors.grey.shade300),
                        ),
                        child: Text(t['label']!, style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: jobType == t['value'] ? Colors.white : Colors.grey.shade700,
                          fontWeight: jobType == t['value'] ? FontWeight.w600 : FontWeight.normal,
                        )),
                      ),
                    ),
                ]),
                const SizedBox(height: 12),
                _sheetField('Description', descCtrl, Icons.description_outlined, maxLines: 3),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity, height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleCtrl.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: 'Job title is required.');
                        return;
                      }
                      Navigator.pop(ctx);
                      ctx.read<JobBloc>().add(JobCreateSubmitted(
                        title:       titleCtrl.text.trim(),
                        department:  deptCtrl.text.trim().isEmpty  ? null : deptCtrl.text.trim(),
                        location:    locCtrl.text.trim().isEmpty    ? null : locCtrl.text.trim(),
                        type:        jobType,
                        description: descCtrl.text.trim().isEmpty  ? null : descCtrl.text.trim(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Create Job', style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
          );
        }),
      ),
    );
  }

  Widget _sheetField(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1}) =>
    TextField(
      controller: ctrl, maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A73E8), size: 20),
        filled: true, fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF1A73E8))),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
}
