import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/episode_model.dart';
import '../../data/models/season_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class EpisodesScreen extends ConsumerStatefulWidget {
  const EpisodesScreen({super.key});

  @override
  ConsumerState<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends ConsumerState<EpisodesScreen> {
  int? _selectedSeasonId;

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
                l10n.menuEpisodes,
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
                  onChanged: (id) => setState(() => _selectedSeasonId = id),
                ),
                loading: () => const SizedBox(width: 150),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addEpisode,
                icon: Icons.add,
                onPressed: _selectedSeasonId == null
                    ? null
                    : () => _showEpisodeDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_selectedSeasonId == null)
            Expanded(
              child: Center(
                child: Text(
                  l10n.selectSeason,
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
                  final episodesAsync = ref.watch(episodesProvider(_selectedSeasonId!));

                  return episodesAsync.when(
                    data: (episodes) => AdminTable<Episode>(
                      columns: [
                        AdminTableColumn(
                          header: 'ID',
                          width: 60,
                          cellBuilder: (ep) => AdminTableCell('${ep.id}'),
                        ),
                        AdminTableColumn(
                          header: l10n.episodeName,
                          flex: true,
                          cellBuilder: (ep) => AdminTableCell(
                            ep.name.get('en') ?? ep.name.get('ru') ?? '',
                            bold: true,
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.episodeFile,
                          width: 100,
                          cellBuilder: (ep) => AdminTableCell(
                            ep.hasFile ? l10n.yes : l10n.noFile,
                            secondary: !ep.hasFile,
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.episodeVersion,
                          width: 80,
                          cellBuilder: (ep) => AdminTableCell('v${ep.version}'),
                        ),
                        AdminTableColumn(
                          header: l10n.episodeDate,
                          width: 100,
                          cellBuilder: (ep) => AdminTableCell(
                            DateFormat('yyyy-MM-dd').format(ep.date),
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.episodeOrder,
                          width: 80,
                          cellBuilder: (ep) => AdminTableCell('${ep.order}'),
                        ),
                        AdminTableColumn(
                          header: '',
                          width: 100,
                          cellBuilder: (ep) => AdminTableActions(
                            onEdit: () => _showEpisodeDialog(context, ref, episode: ep),
                            onDelete: () => _confirmDelete(context, ref, ep),
                          ),
                        ),
                      ],
                      data: episodes,
                      onRowTap: (ep) => _showEpisodeDialog(context, ref, episode: ep),
                    ),
                    loading: () => const AdminTable<Episode>(
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

  Future<void> _showEpisodeDialog(BuildContext context, WidgetRef ref, {Episode? episode}) async {
    final l10n = AppLocalizations.of(context);

    final nameEnController = TextEditingController(text: episode?.name.en ?? '');
    final nameRuController = TextEditingController(text: episode?.name.ru ?? '');
    final nameHiController = TextEditingController(text: episode?.name.hi ?? '');
    final productController = TextEditingController(text: episode?.product ?? '');
    final versionController = TextEditingController(text: '${episode?.version ?? 1}');
    final orderController = TextEditingController(text: '${episode?.order ?? 0}');
    DateTime selectedDate = episode?.date ?? DateTime.now();

    await AdminFormDialog.show<Episode>(
      context: context,
      title: episode == null ? l10n.addEpisode : l10n.editEpisode,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminTextField(
              label: '${l10n.episodeName} (${l10n.textEnglish})',
              controller: nameEnController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.episodeName} (${l10n.textRussian})',
              controller: nameRuController,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.episodeName} (${l10n.textHindi})',
              controller: nameHiController,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: l10n.episodeProduct,
              controller: productController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AdminTextField(
                    label: l10n.episodeVersion,
                    controller: versionController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AdminTextField(
                    label: l10n.episodeOrder,
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
                  labelText: l10n.episodeDate,
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
          return episode;
        }

        final client = ref.read(apiClientProvider);
        final input = EpisodeInput(
          seasonId: _selectedSeasonId!,
          name: LocalizedText(
            en: nameEnController.text.isEmpty ? null : nameEnController.text,
            ru: nameRuController.text.isEmpty ? null : nameRuController.text,
            hi: nameHiController.text.isEmpty ? null : nameHiController.text,
          ),
          product: productController.text.isEmpty ? null : productController.text,
          version: int.tryParse(versionController.text),
          date: selectedDate,
          order: int.tryParse(orderController.text),
        );

        if (episode == null) {
          return await client!.createEpisode(input);
        } else {
          return await client!.updateEpisode(episode.id, input);
        }
      },
    );

    ref.invalidate(episodesProvider(_selectedSeasonId!));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Episode episode) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteEpisodeConfirm),
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

    if (confirmed == true && _selectedSeasonId != null) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deleteEpisode(episode.id);
      }
      ref.invalidate(episodesProvider(_selectedSeasonId!));
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
