import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/piece_model.dart';
import '../../data/models/puzzle_model.dart';
import '../../data/models/episode_model.dart';
import '../../data/models/season_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class PiecesScreen extends ConsumerStatefulWidget {
  const PiecesScreen({super.key});

  @override
  ConsumerState<PiecesScreen> createState() => _PiecesScreenState();
}

class _PiecesScreenState extends ConsumerState<PiecesScreen> {
  int? _selectedSeasonId;
  int? _selectedEpisodeId;
  int? _selectedPuzzleId;

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
                l10n.menuPieces,
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
                    _selectedPuzzleId = null;
                  }),
                ),
                loading: () => const SizedBox(width: 150),
                error: (_, __) => const SizedBox.shrink(),
              ),
              if (_selectedSeasonId != null) ...[
                const SizedBox(width: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final episodesAsync = ref.watch(episodesProvider(_selectedSeasonId!));
                    return episodesAsync.when(
                      data: (episodes) => _EpisodeFilter(
                        episodes: episodes,
                        selectedId: _selectedEpisodeId,
                        onChanged: (id) => setState(() {
                          _selectedEpisodeId = id;
                          _selectedPuzzleId = null;
                        }),
                      ),
                      loading: () => const SizedBox(width: 150),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
              if (_selectedEpisodeId != null) ...[
                const SizedBox(width: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final puzzlesAsync = ref.watch(puzzlesProvider(_selectedEpisodeId!));
                    return puzzlesAsync.when(
                      data: (puzzles) => _PuzzleFilter(
                        puzzles: puzzles,
                        selectedId: _selectedPuzzleId,
                        onChanged: (id) => setState(() => _selectedPuzzleId = id),
                      ),
                      loading: () => const SizedBox(width: 150),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addPiece,
                icon: Icons.add,
                onPressed: _selectedPuzzleId == null
                    ? null
                    : () => _showPieceDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_selectedPuzzleId == null)
            Expanded(
              child: Center(
                child: Text(
                  l10n.selectPuzzle,
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
                  final piecesAsync = ref.watch(piecesProvider(_selectedPuzzleId!));

                  return piecesAsync.when(
                    data: (pieces) => AdminTable<Piece>(
                      columns: [
                        AdminTableColumn(
                          header: 'ID',
                          width: 60,
                          cellBuilder: (p) => AdminTableCell('${p.id}'),
                        ),
                        AdminTableColumn(
                          header: l10n.piecePosition,
                          width: 100,
                          cellBuilder: (p) => AdminTableCell(p.position),
                        ),
                        AdminTableColumn(
                          header: l10n.pieceSize,
                          width: 100,
                          cellBuilder: (p) => AdminTableCell(p.size),
                        ),
                        AdminTableColumn(
                          header: l10n.pieceFile,
                          flex: true,
                          cellBuilder: (p) => AdminTableCell(
                            p.hasFile ? p.file! : l10n.noFile,
                            secondary: !p.hasFile,
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.pieceVersion,
                          width: 80,
                          cellBuilder: (p) => AdminTableCell('v${p.version}'),
                        ),
                        AdminTableColumn(
                          header: l10n.pieceDate,
                          width: 100,
                          cellBuilder: (p) => AdminTableCell(
                            DateFormat('yyyy-MM-dd').format(p.date),
                          ),
                        ),
                        AdminTableColumn(
                          header: '',
                          width: 100,
                          cellBuilder: (p) => AdminTableActions(
                            onEdit: () => _showPieceDialog(context, ref, piece: p),
                            onDelete: () => _confirmDelete(context, ref, p),
                          ),
                        ),
                      ],
                      data: pieces,
                      onRowTap: (p) => _showPieceDialog(context, ref, piece: p),
                    ),
                    loading: () => const AdminTable<Piece>(
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

  Future<void> _showPieceDialog(BuildContext context, WidgetRef ref, {Piece? piece}) async {
    final l10n = AppLocalizations.of(context);

    final xController = TextEditingController(text: '${piece?.x ?? 0}');
    final yController = TextEditingController(text: '${piece?.y ?? 0}');
    final widthController = TextEditingController(text: '${piece?.width ?? 1}');
    final heightController = TextEditingController(text: '${piece?.height ?? 1}');
    final versionController = TextEditingController(text: '${piece?.version ?? 1}');
    final orderController = TextEditingController(text: '${piece?.order ?? 0}');
    DateTime selectedDate = piece?.date ?? DateTime.now();

    await AdminFormDialog.show<Piece>(
      context: context,
      title: piece == null ? l10n.addPiece : l10n.editPiece,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AdminTextField(
                    label: 'X',
                    controller: xController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminTextField(
                    label: 'Y',
                    controller: yController,
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
                    label: 'Width',
                    controller: widthController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminTextField(
                    label: 'Height',
                    controller: heightController,
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
                    label: l10n.pieceVersion,
                    controller: versionController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminTextField(
                    label: l10n.pieceOrder,
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
                  labelText: l10n.pieceDate,
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
          return piece;
        }

        final client = ref.read(apiClientProvider);
        final input = PieceInput(
          puzzleId: _selectedPuzzleId!,
          x: int.tryParse(xController.text) ?? 0,
          y: int.tryParse(yController.text) ?? 0,
          width: int.tryParse(widthController.text) ?? 1,
          height: int.tryParse(heightController.text) ?? 1,
          version: int.tryParse(versionController.text),
          date: selectedDate,
          order: int.tryParse(orderController.text),
        );

        if (piece == null) {
          return await client!.createPiece(input);
        } else {
          return await client!.updatePiece(piece.id, input);
        }
      },
    );

    ref.invalidate(piecesProvider(_selectedPuzzleId!));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Piece piece) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deletePieceConfirm),
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

    if (confirmed == true && _selectedPuzzleId != null) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deletePiece(piece.id);
      }
      ref.invalidate(piecesProvider(_selectedPuzzleId!));
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

class _PuzzleFilter extends StatelessWidget {
  final List<Puzzle> puzzles;
  final int? selectedId;
  final void Function(int?) onChanged;

  const _PuzzleFilter({
    required this.puzzles,
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
          hint: Text(l10n.selectPuzzle),
          items: puzzles.map((p) => DropdownMenuItem(
            value: p.id,
            child: Text(p.name.get('en') ?? p.name.get('ru') ?? 'Puzzle ${p.id}'),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
