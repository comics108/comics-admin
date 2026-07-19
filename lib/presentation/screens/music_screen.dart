import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/music_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final musicAsync = ref.watch(musicProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.menuMusic,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addMusic,
                icon: Icons.add,
                onPressed: () => _showMusicDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: musicAsync.when(
              data: (musicList) => AdminTable<Music>(
                columns: [
                  AdminTableColumn(
                    header: 'ID',
                    width: 60,
                    cellBuilder: (m) => AdminTableCell('${m.id}'),
                  ),
                  AdminTableColumn(
                    header: l10n.musicName,
                    flex: true,
                    cellBuilder: (m) => AdminTableCell(
                      m.name.get('en') ?? m.name.get('ru') ?? '',
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.musicAuthor,
                    width: 150,
                    cellBuilder: (m) => AdminTableCell(
                      m.author.get('en') ?? m.author.get('ru') ?? '',
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.musicFile,
                    width: 150,
                    cellBuilder: (m) => AdminTableCell(
                      m.hasFile ? m.file! : l10n.noFile,
                      secondary: !m.hasFile,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.musicOrder,
                    width: 80,
                    cellBuilder: (m) => AdminTableCell('${m.order}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (m) => AdminTableActions(
                      onEdit: () => _showMusicDialog(context, ref, music: m),
                      onDelete: () => _confirmDelete(context, ref, m),
                    ),
                  ),
                ],
                data: musicList,
                onRowTap: (m) => _showMusicDialog(context, ref, music: m),
              ),
              loading: () => const AdminTable<Music>(
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

  Future<void> _showMusicDialog(BuildContext context, WidgetRef ref, {Music? music}) async {
    final l10n = AppLocalizations.of(context);

    final nameEnController = TextEditingController(text: music?.name.en ?? '');
    final nameRuController = TextEditingController(text: music?.name.ru ?? '');
    final nameHiController = TextEditingController(text: music?.name.hi ?? '');
    final authorEnController = TextEditingController(text: music?.author.en ?? '');
    final authorRuController = TextEditingController(text: music?.author.ru ?? '');
    final authorHiController = TextEditingController(text: music?.author.hi ?? '');
    final orderController = TextEditingController(text: '${music?.order ?? 0}');

    await AdminFormDialog.show<Music>(
      context: context,
      title: music == null ? l10n.addMusic : l10n.editMusic,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminTextField(
              label: '${l10n.musicName} (${l10n.textEnglish})',
              controller: nameEnController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.musicName} (${l10n.textRussian})',
              controller: nameRuController,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.musicName} (${l10n.textHindi})',
              controller: nameHiController,
            ),
            const SizedBox(height: 24),
            AdminTextField(
              label: '${l10n.musicAuthor} (${l10n.textEnglish})',
              controller: authorEnController,
              required: true,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.musicAuthor} (${l10n.textRussian})',
              controller: authorRuController,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: '${l10n.musicAuthor} (${l10n.textHindi})',
              controller: authorHiController,
            ),
            const SizedBox(height: 16),
            AdminTextField(
              label: l10n.musicOrder,
              controller: orderController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return music;
        }

        final client = ref.read(apiClientProvider);
        final input = MusicInput(
          name: LocalizedText(
            en: nameEnController.text.isEmpty ? null : nameEnController.text,
            ru: nameRuController.text.isEmpty ? null : nameRuController.text,
            hi: nameHiController.text.isEmpty ? null : nameHiController.text,
          ),
          author: LocalizedText(
            en: authorEnController.text.isEmpty ? null : authorEnController.text,
            ru: authorRuController.text.isEmpty ? null : authorRuController.text,
            hi: authorHiController.text.isEmpty ? null : authorHiController.text,
          ),
          order: int.tryParse(orderController.text),
        );

        if (music == null) {
          return await client!.createMusic(input);
        } else {
          return await client!.updateMusic(music.id, input);
        }
      },
    );

    ref.invalidate(musicProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Music music) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteMusicConfirm),
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
        await client!.deleteMusic(music.id);
      }
      ref.invalidate(musicProvider);
    }
  }
}
