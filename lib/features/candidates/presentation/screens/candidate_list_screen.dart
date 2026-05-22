import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hireops/core/constants/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../providers/candidate_providers.dart';
import '../widgets/candidate_list_tile.dart';
import '../widgets/filter_bottom_sheet.dart';

class CandidateListScreen extends HookConsumerWidget {
  const CandidateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final candidatesAsync = ref.watch(candidateListProvider);
    final filter = ref.watch(candidateFilterNotifierProvider);
    final hasActiveFilter = filter.stage != null ||
        filter.tag != null ||
        filter.minExperience != null ||
        filter.maxExperience != null;

    // Debounced search
    useEffect(() {
      void listener() {
        Future.delayed(const Duration(milliseconds: 400), () {
          ref
              .read(candidateFilterNotifierProvider.notifier)
              .setQuery(searchCtrl.text);
        });
      }

      searchCtrl.addListener(listener);
      return () => searchCtrl.removeListener(listener);
    }, [searchCtrl]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.candidateList),
        actions: [
          // Filter button with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Filter',
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const FilterBottomSheet(),
                ),
              ),
              if (hasActiveFilter)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: AppStrings.searchCandidates,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: filter.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          searchCtrl.clear();
                          ref
                              .read(candidateFilterNotifierProvider.notifier)
                              .setQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Active Filter Chips ───────────────────────────────────────────
          if (hasActiveFilter)
            _ActiveFilterChips(
              filter: filter,
              onClear: () => ref
                  .read(candidateFilterNotifierProvider.notifier)
                  .clearFilters(),
            ),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(candidateListProvider),
              child: candidatesAsync.when(
                loading: () => ListView.builder(
                  itemCount: 8,
                  itemBuilder: (_, __) => const ShimmerListTile(),
                ),
                error: (e, _) => ErrorState(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(candidateListProvider),
                ),
                data: (candidates) {
                  if (candidates.isEmpty) {
                    return EmptyState(
                      icon: Icons.person_search_outlined,
                      title: 'No candidates found',
                      subtitle: filter.query.isNotEmpty
                          ? 'Try a different search term or clear filters.'
                          : 'Start by uploading a CV or adding a candidate manually.',
                      actionLabel: 'Add Candidate',
                      onAction: () => context.push('/candidates/add'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: candidates.length,
                    itemBuilder: (context, index) =>
                        CandidateListTile(candidate: candidates[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/candidates/add'),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text(AppStrings.addCandidate),
      ),
    );
  }
}

class _ActiveFilterChips extends StatelessWidget {
  final CandidateFilter filter;
  final VoidCallback onClear;

  const _ActiveFilterChips({required this.filter, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (filter.stage != null)
                    _Chip(label: 'Stage: ${filter.stage!.name}'),
                  if (filter.minExperience != null ||
                      filter.maxExperience != null)
                    _Chip(
                      label:
                          'Exp: ${filter.minExperience ?? 0}–${filter.maxExperience ?? '∞'} yrs',
                    ),
                  if (filter.tag != null) _Chip(label: '#${filter.tag}'),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
