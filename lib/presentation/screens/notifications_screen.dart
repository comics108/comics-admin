import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _titleEnController = TextEditingController();
  final _titleRuController = TextEditingController();
  final _titleHiController = TextEditingController();
  final _bodyEnController = TextEditingController();
  final _bodyRuController = TextEditingController();
  final _bodyHiController = TextEditingController();
  String _platform = 'all';
  bool _isSending = false;
  NotificationResult? _lastResult;

  @override
  void dispose() {
    _titleEnController.dispose();
    _titleRuController.dispose();
    _titleHiController.dispose();
    _bodyEnController.dispose();
    _bodyRuController.dispose();
    _bodyHiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.menuNotifications,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.notificationTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _titleEnController,
                              label: l10n.textEnglish,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _titleRuController,
                              label: l10n.textRussian,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _titleHiController,
                              label: l10n.textHindi,
                            ),
                            const SizedBox(height: 24),

                            Text(
                              l10n.notificationBody,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _bodyEnController,
                              label: l10n.textEnglish,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _bodyRuController,
                              label: l10n.textRussian,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _bodyHiController,
                              label: l10n.textHindi,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),

                            Text(
                              l10n.notificationPlatform,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SegmentedButton<String>(
                              segments: [
                                ButtonSegment(
                                  value: 'all',
                                  label: Text(l10n.notificationPlatformAll),
                                ),
                                ButtonSegment(
                                  value: 'ios',
                                  label: Text(l10n.notificationPlatformIos),
                                ),
                                ButtonSegment(
                                  value: 'android',
                                  label: Text(l10n.notificationPlatformAndroid),
                                ),
                              ],
                              selected: {_platform},
                              onSelectionChanged: (selection) {
                                setState(() => _platform = selection.first);
                              },
                            ),
                            const SizedBox(height: 32),

                            AdminButton.primary(
                              label: _isSending ? l10n.loading : l10n.sendNotification,
                              icon: Icons.send,
                              onPressed: _isSending ? null : _sendNotification,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                // Result panel
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.notificationSent,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (_lastResult != null) ...[
                            _ResultRow(
                              label: 'Sent',
                              value: '${_lastResult!.sent}',
                              color: AppColors.success,
                            ),
                            const SizedBox(height: 12),
                            _ResultRow(
                              label: 'Failed',
                              value: '${_lastResult!.failed}',
                              color: _lastResult!.hasFailures ? AppColors.error : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            _ResultRow(
                              label: 'Total',
                              value: '${_lastResult!.total}',
                              bold: true,
                            ),
                          ] else
                            Text(
                              '—',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _sendNotification() async {
    final l10n = AppLocalizations.of(context);

    // Validate that at least one title and body are filled
    final hasTitle = _titleEnController.text.isNotEmpty ||
        _titleRuController.text.isNotEmpty ||
        _titleHiController.text.isNotEmpty;
    final hasBody = _bodyEnController.text.isNotEmpty ||
        _bodyRuController.text.isNotEmpty ||
        _bodyHiController.text.isNotEmpty;

    if (!hasTitle || !hasBody) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.error),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final config = ref.read(appConfigProvider);
      if (config?.isMockMode ?? true) {
        // Mock result
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _lastResult = const NotificationResult(sent: 1234, failed: 12);
        });
      } else {
        final client = ref.read(apiClientProvider);
        final input = NotificationInput(
          title: LocalizedText(
            en: _titleEnController.text.isEmpty ? null : _titleEnController.text,
            ru: _titleRuController.text.isEmpty ? null : _titleRuController.text,
            hi: _titleHiController.text.isEmpty ? null : _titleHiController.text,
          ),
          body: LocalizedText(
            en: _bodyEnController.text.isEmpty ? null : _bodyEnController.text,
            ru: _bodyRuController.text.isEmpty ? null : _bodyRuController.text,
            hi: _bodyHiController.text.isEmpty ? null : _bodyHiController.text,
          ),
          platform: _platform,
        );
        final result = await client!.sendNotification(input);
        setState(() => _lastResult = result);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.notificationSent),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;

  const _ResultRow({
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
