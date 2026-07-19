import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/models/episode_model.dart';
import '../../data/models/season_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class PuzzlesScreen extends ConsumerStatefulWidget {
  const PuzzlesScreen({super.key});

  @override
  ConsumerState<PuzzlesScreen> createState() => _PuzzlesScreenState();
}

class _PuzzlesScreenState extends ConsumerState<PuzzlesScreen> {
  int? _selectedSeasonId;
  int? _selectedEpisodeId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final seasonsAsync = ref.watch(seasonsProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.menuPuzzles,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              seasonsAsync.when(
                data: (seasons) => _SeasonFilter(
                  seasons: seasons,
                  selectedId: _selectedSeasonId,
                  onChanged: (id) => setState(() {
                    _selectedSeasonId = id;
                    _selectedEpisodeId = null;
                  }),
                ),
                loading: () => const SizedBox(width: 150),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 16),
              if (_selectedSeasonId != null)
                Consumer(
                  builder: (context, ref, _) {
                    final episodesAsync = ref.watch(episodesProvider(_selectedSeasonId!));
                    return episodesAsync.when(
                      data: (episodes) => _EpisodeFilter(
                        episodes: episodes,
                        selectedId: _selectedEpisodeId,
                        onChanged: (id) => setState(() => _selectedEpisodeId = id),
                      ),
                      loading: () => const SizedBox(width: 150),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addPuzzle,
                icon: Icons.add,
                onPressed: _selectedEpisodeId == null
                    ? null
                    : () => _showPuzzleDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_selectedEpisodeId == null)
            Expanded(
              child: Center(
                child: Text(
                  l10n.selectEpisode,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final puzzlesAsync = ref.watch(puzzlesProvider(_selectedEpisodeId!));

                  return puzzlesAsync.when(
                    data: (puzzles) => AdminTable<Puzzle>(
                      columns: [
                        AdminTableColumn(
                          header: 'ID',
                          width: 60,
                          cellBuilder: (p) => AdminTableCell('${p.id}'),
                        ),
                        AdminTableColumn(
                          header: l10n.puzzleName,
                          flex: true,
                          cellBuilder: (p) => AdminTableCell(
                            p.name.get('en') ?? p.name.get('ru') ?? '',
                            bold: true,
                          ),
                        ),
                        AdminTableColumn(
                          header: '${l10n.puzzleRows}×${l10n.puzzleColumns}',
                          width: 100,
                          cellBuilder: (p) => AdminTableCell('${p.rows}×${p.columns}'),
                        ),
                        AdminTableColumn(
                          header: l10n.puzzleVersion,
                          width: 80,
                          cellBuilder: (p) => AdminTableCell('v${p.version}'),
                        ),
                        AdminTableColumn(
                          header: l10n.puzzleDate,
                          width: 100,
                          cellBuilder: (p) => AdminTableCell(
                            DateFormat('yyyy-MM-dd').format(p.date),
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.puzzlePieces,
                          width: 80,
                          cellBuilder: (p) => AdminTableCell('${p.piecesCount}'),
                        ),
                        AdminTableColumn(
                          header: '',
                          width: 100,
                          cellBuilder: (p) => AdminTableActions(
                            onEdit: () => _showPuzzleDialog(context, ref, puzzle: p),
                            onDelete: () => _confirmDelete(context, ref, p),
                          ),
                        ),
                      ],
                      data: puzzles,
                      onRowTap: (p) => _showPuzzleDialog(context, ref, puzzle: p),
                    ),
                    loading: () => const AdminTable<Puzzle>(
                      columns: [],
                      data: [],
                      isLoading: true,
                    ),
                    error: (e, _) => Center(
                      child: Text('${l10n.error}: $e'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showPuzzleDialog(BuildContext context, WidgetRef ref, {Puzzle? puzzle}) async {
    final l10n = AppLocalizations.of(context);

    final nameEnController = TextEditingController(text: puzzle?.name.en ?? '');
    final nameRuController = TextEditingController(text: puzzle?.name.ru ?? '');
    final nameHiController = TextEditingController(text: puzzle?.name.hi ?? '');
    final rowsController = TextEditingController(text: '${puzzle?.rows ?? 3}');
    final columnsController = TextEditingController(text: '${puzzle?.columns ?? 3}');
    final versionController = TextEditingController(text: '${puzzle?.version ?? 1}');
    final orderController = TextEditingController(text: '${puzzle?.order ?? 0}');
    DateTime selectedDate = puzzle?.date ?? DateTime.now();

    await AdminFormDialog.show<Puzzle>(
      context: context,
      title: puzzle == null ? l10n.addPuzzle : l10n.editPuzzle,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminTextField(
              label: '${l10n.puzzleName} (${l10n.textEnglish})',
              controller: nameEnController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.puzzleName} (${l10n.textRussian})',
              controller: nameRuController,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.puzzleName} (${l10n.textHindi})',
              controller: nameHiController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AdminTextField(
                    label: l10n.puzzleRows,
                    controller: rowsController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminTextField(
                    label: l10n.puzzleColumns,
                    controller: columnsController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AdminTextField(
                    label: l10n.puzzleVersion,
                    controller: versionController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminTextField(
                    label: l10n.puzzleOrder,
                    controller: orderController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.puzzleDate,
                  border: const OutlineInputBorder(),
                ),
                child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
              ),
            ),
          ],
        ),
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return puzzle;
        }

        final client = ref.read(apiClientProvider);
        final input = PuzzleInput(
          episodeId: _selectedEpisodeId!,
          name: LocalizedText(
            en: nameEnController.text.isEmpty ? null : nameEnController.text,
            ru: nameRuController.text.isEmpty ? null : nameRuController.text,
            hi: nameHiController.text.isEmpty ? null : nameHiController.text,
          ),
          rows: int.tryParse(rowsController.text) ?? 3,
          columns: int.tryParse(columnsController.text) ?? 3,
          version: int.tryParse(versionController.text),
          date: selectedDate,
          order: int.tryParse(orderController.text),
        );

        if (puzzle == null) {
          return await client!.createPuzzle(input);
        } else {
          return await client!.updatePuzzle(puzzle.id, input);
        }
      },
    );

    ref.invalidate(puzzlesProvider(_selectedEpisodeId!));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Puzzle puzzle) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deletePuzzleConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && _selectedEpisodeId != null) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deletePuzzle(puzzle.id);
      }
      ref.invalidate(puzzlesProvider(_selectedEpisodeId!));
    }
  }
}

class _SeasonFilter extends StatelessWidget {
  final List<Season> seasons;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _SeasonFilter({
    required this.seasons,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedId,
          hint: Text(l10n.selectSeason),
          items: seasons.map((s) => DropdownMenuItem(
            value: s.id,
            child: Text(s.name.get('en') ?? s.name.get('ru') ?? 'Season ${s.id}'),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _EpisodeFilter extends StatelessWidget {
  final List<Episode> episodes;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _EpisodeFilter({
    required this.episodes,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedId,
          hint: Text(l10n.selectEpisode),
          items: episodes.map((e) => DropdownMenuItem(
            value: e.id,
            child: Text(e.name.get('en') ?? e.name.get('ru') ?? 'Episode ${e.id}'),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
