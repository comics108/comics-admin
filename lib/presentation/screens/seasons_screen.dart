import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/season_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class SeasonsScreen extends ConsumerWidget {
  const SeasonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                l10n.menuSeasons,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addSeason,
                icon: Icons.add,
                onPressed: () => _showSeasonDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: seasonsAsync.when(
              data: (seasons) => AdminTable<Season>(
                columns: [
                  AdminTableColumn(
                    header: 'ID',
                    width: 60,
                    cellBuilder: (season) => AdminTableCell('${season.id}'),
                  ),
                  AdminTableColumn(
                    header: l10n.seasonName,
                    flex: true,
                    cellBuilder: (season) => AdminTableCell(
                      season.name.get('en') ?? season.name.get('ru') ?? '',
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.seasonImage,
                    width: 100,
                    cellBuilder: (season) => AdminTableCell(
                      season.hasImage ? season.image! : l10n.noFile,
                      secondary: !season.hasImage,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.seasonProduct,
                    width: 150,
                    cellBuilder: (season) => AdminTableCell(
                      season.product ?? '—',
                      secondary: season.product == null,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.seasonOrder,
                    width: 80,
                    cellBuilder: (season) => AdminTableCell('${season.order}'),
                  ),
                  AdminTableColumn(
                    header: l10n.seasonEpisodes,
                    width: 80,
                    cellBuilder: (season) => AdminTableCell('${season.episodesCount}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (season) => AdminTableActions(
                      onEdit: () => _showSeasonDialog(context, ref, season: season),
                      onDelete: () => _confirmDelete(context, ref, season),
                    ),
                  ),
                ],
                data: seasons,
                onRowTap: (season) => _showSeasonDialog(context, ref, season: season),
              ),
              loading: () => const AdminTable<Season>(
                columns: [],
                data: [],
                isLoading: true,
              ),
              error: (e, _) => Center(
                child: Text('${l10n.error}: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSeasonDialog(BuildContext context, WidgetRef ref, {Season? season}) async {
    final l10n = AppLocalizations.of(context);

    final nameEnController = TextEditingController(text: season?.name.en ?? '');
    final nameRuController = TextEditingController(text: season?.name.ru ?? '');
    final nameHiController = TextEditingController(text: season?.name.hi ?? '');
    final productController = TextEditingController(text: season?.product ?? '');
    final orderController = TextEditingController(text: '${season?.order ?? 0}');

    await AdminFormDialog.show<Season>(
      context: context,
      title: season == null ? l10n.addSeason : l10n.editSeason,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminTextField(
            label: '${l10n.seasonName} (${l10n.textEnglish})',
            controller: nameEnController,
            required: true,
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: '${l10n.seasonName} (${l10n.textRussian})',
            controller: nameRuController,
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: '${l10n.seasonName} (${l10n.textHindi})',
            controller: nameHiController,
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: l10n.seasonProduct,
            controller: productController,
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: l10n.seasonOrder,
            controller: orderController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return season;
        }

        final client = ref.read(apiClientProvider);
        final input = SeasonInput(
          name: LocalizedText(
            en: nameEnController.text.isEmpty ? null : nameEnController.text,
            ru: nameRuController.text.isEmpty ? null : nameRuController.text,
            hi: nameHiController.text.isEmpty ? null : nameHiController.text,
          ),
          product: productController.text.isEmpty ? null : productController.text,
          order: int.tryParse(orderController.text),
        );

        if (season == null) {
          return await client!.createSeason(input);
        } else {
          return await client!.updateSeason(season.id, input);
        }
      },
    );

    ref.invalidate(seasonsProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Season season) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteSeasonConfirm),
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

    if (confirmed == true) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deleteSeason(season.id);
      }
      ref.invalidate(seasonsProvider);
    }
  }
}
