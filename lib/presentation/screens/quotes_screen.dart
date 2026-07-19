import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class QuotesScreen extends ConsumerStatefulWidget {
  const QuotesScreen({super.key});

  @override
  ConsumerState<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends ConsumerState<QuotesScreen> {
  QuoteStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quotesAsync = ref.watch(quotesProvider(QuoteQuery(status: _selectedStatus)));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.menuQuotes,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              _StatusFilter(
                selectedStatus: _selectedStatus,
                onChanged: (status) => setState(() => _selectedStatus = status),
              ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addQuote,
                icon: Icons.add,
                onPressed: () => _showQuoteDialog(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: quotesAsync.when(
              data: (quotes) => AdminTable<Quote>(
                columns: [
                  AdminTableColumn(
                    header: 'ID',
                    width: 60,
                    cellBuilder: (q) => AdminTableCell('${q.id}'),
                  ),
                  AdminTableColumn(
                    header: l10n.quoteText,
                    flex: true,
                    cellBuilder: (q) {
                      final text = q.text.get('en') ?? q.text.get('ru') ?? '';
                      return AdminTableCell(
                        text.length > 80 ? '${text.substring(0, 80)}...' : text,
                        bold: true,
                      );
                    },
                  ),
                  AdminTableColumn(
                    header: l10n.quoteStatus,
                    width: 120,
                    cellBuilder: (q) => _StatusBadge(status: q.status),
                  ),
                  AdminTableColumn(
                    header: l10n.quotePublishDate,
                    width: 120,
                    cellBuilder: (q) => AdminTableCell(
                      q.publishDate != null
                          ? DateFormat('yyyy-MM-dd').format(q.publishDate!)
                          : '—',
                      secondary: q.publishDate == null,
                    ),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 140,
                    cellBuilder: (q) => Row(
                      children: [
                        if (q.isScheduled)
                          IconButton(
                            icon: const Icon(Icons.publish, size: 18),
                            tooltip: l10n.publishNow,
                            onPressed: () => _publishNow(context, ref, q),
                          ),
                        AdminTableActions(
                          onEdit: () => _showQuoteDialog(context, ref, quote: q),
                          onDelete: () => _confirmDelete(context, ref, q),
                        ),
                      ],
                    ),
                  ),
                ],
                data: quotes,
                onRowTap: (q) => _showQuoteDialog(context, ref, quote: q),
              ),
              loading: () => const AdminTable<Quote>(
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

  Future<void> _showQuoteDialog(BuildContext context, WidgetRef ref, {Quote? quote}) async {
    final l10n = AppLocalizations.of(context);

    final textEnController = TextEditingController(text: quote?.text.en ?? '');
    final textRuController = TextEditingController(text: quote?.text.ru ?? '');
    final textHiController = TextEditingController(text: quote?.text.hi ?? '');
    final imageEnController = TextEditingController(text: quote?.image.en ?? '');
    final imageRuController = TextEditingController(text: quote?.image.ru ?? '');
    final imageHiController = TextEditingController(text: quote?.image.hi ?? '');
    DateTime? publishDate = quote?.publishDate;

    await AdminFormDialog.show<Quote>(
      context: context,
      title: quote == null ? l10n.addQuote : l10n.editQuote,
      content: StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminTextField(
                label: '${l10n.quoteText} (${l10n.textEnglish})',
                controller: textEnController,
                maxLines: 3,
                required: true,
              ),
              const SizedBox(height: 16),
              AdminTextField(
                label: '${l10n.quoteText} (${l10n.textRussian})',
                controller: textRuController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              AdminTextField(
                label: '${l10n.quoteText} (${l10n.textHindi})',
                controller: textHiController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              AdminTextField(
                label: '${l10n.quoteImage} (${l10n.textEnglish})',
                controller: imageEnController,
              ),
              const SizedBox(height: 16),
              AdminTextField(
                label: '${l10n.quoteImage} (${l10n.textRussian})',
                controller: imageRuController,
              ),
              const SizedBox(height: 16),
              AdminTextField(
                label: '${l10n.quoteImage} (${l10n.textHindi})',
                controller: imageHiController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: publishDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => publishDate = date);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.quotePublishDate,
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          publishDate != null
                              ? DateFormat('yyyy-MM-dd').format(publishDate!)
                              : '—',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => publishDate = null),
                    tooltip: l10n.cancel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onSave: () async {
        final config = ref.read(appConfigProvider);
        if (config?.isMockMode ?? true) {
          return quote;
        }

        final client = ref.read(apiClientProvider);
        final input = QuoteInput(
          text: LocalizedText(
            en: textEnController.text.isEmpty ? null : textEnController.text,
            ru: textRuController.text.isEmpty ? null : textRuController.text,
            hi: textHiController.text.isEmpty ? null : textHiController.text,
          ),
          image: LocalizedText(
            en: imageEnController.text.isEmpty ? null : imageEnController.text,
            ru: imageRuController.text.isEmpty ? null : imageRuController.text,
            hi: imageHiController.text.isEmpty ? null : imageHiController.text,
          ),
          publishDate: publishDate,
        );

        if (quote == null) {
          return await client!.createQuote(input);
        } else {
          return await client!.updateQuote(quote.id, input);
        }
      },
    );

    ref.invalidate(quotesProvider);
  }

  Future<void> _publishNow(BuildContext context, WidgetRef ref, Quote quote) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.publishNow),
        content: Text(l10n.confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.publishQuote(quote.id);
      }
      ref.invalidate(quotesProvider);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Quote quote) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.deleteQuoteConfirm),
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
        await client!.deleteQuote(quote.id);
      }
      ref.invalidate(quotesProvider);
    }
  }
}

class _StatusFilter extends StatelessWidget {
  final QuoteStatus? selectedStatus;
  final void Function(QuoteStatus?) onChanged;

  const _StatusFilter({
    required this.selectedStatus,
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
        child: DropdownButton<QuoteStatus?>(
          value: selectedStatus,
          hint: Text(l10n.quoteStatus),
          items: [
            DropdownMenuItem<QuoteStatus?>(
              value: null,
              child: Text(l10n.allQuotes),
            ),
            DropdownMenuItem(
              value: QuoteStatus.published,
              child: Text(l10n.quotePublished),
            ),
            DropdownMenuItem(
              value: QuoteStatus.scheduled,
              child: Text(l10n.quoteScheduled),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final QuoteStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPublished = status == QuoteStatus.published;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPublished ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isPublished ? l10n.quotePublished : l10n.quoteScheduled,
        style: TextStyle(
          fontSize: 12,
          color: isPublished ? AppColors.success : AppColors.warning,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
