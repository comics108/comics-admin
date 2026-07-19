import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/device_model.dart';
import '../providers/data_providers.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_pagination.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  String? _platformFilter;
  int _currentPage = 1;
  static const _itemsPerPage = 50;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(deviceStatsProvider);
    final query = DeviceQuery(
      platform: _platformFilter,
      page: _currentPage,
      limit: _itemsPerPage,
    );
    final devicesAsync = ref.watch(devicesProvider(query));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with stats
          Row(
            children: [
              Text(
                l10n.devicesTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),

              // Stats
              statsAsync.when(
                data: (stats) => Row(
                  children: [
                    _StatBadge(
                      label: l10n.devicesTotal,
                      value: stats.total,
                    ),
                    const SizedBox(width: 16),
                    _StatBadge(
                      label: l10n.devicesActive30,
                      value: stats.active30days,
                      color: AppColors.success,
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Platform filter
          Row(
            children: [
              _PlatformFilter(
                platforms: ['android', 'ios'],
                selectedPlatform: _platformFilter,
                onChanged: (p) => setState(() {
                  _platformFilter = p;
                  _currentPage = 1;
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table
          Expanded(
            child: devicesAsync.when(
              data: (response) => Column(
                children: [
                  Expanded(
                    child: AdminTable<Device>(
                      columns: [
                        AdminTableColumn(
                          header: 'ID',
                          width: 60,
                          cellBuilder: (d) => AdminTableCell('${d.id}'),
                        ),
                        AdminTableColumn(
                          header: l10n.devicesToken,
                          width: 150,
                          cellBuilder: (d) => AdminTableCell(
                            d.pushToken ?? '—',
                            secondary: d.pushToken == null,
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.devicesPlatform,
                          width: 100,
                          cellBuilder: (d) => _PlatformBadge(
                            platform: d.platformName,
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.devicesLanguage,
                          width: 80,
                          cellBuilder: (d) => AdminTableCell(
                            d.culture.toUpperCase(),
                          ),
                        ),
                        AdminTableColumn(
                          header: l10n.devicesLastActivity,
                          flex: true,
                          cellBuilder: (d) => AdminTableCell(
                            d.lastModified != null ? _formatDate(d.lastModified!) : '—',
                            secondary: true,
                          ),
                        ),
                      ],
                      data: response.data,
                    ),
                  ),
                  AdminPagination(
                    currentPage: response.pagination.page,
                    totalPages: response.pagination.totalPages,
                    totalItems: response.pagination.total,
                    itemsPerPage: response.pagination.limit,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                  ),
                ],
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color? color;

  const _StatBadge({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: (color ?? AppColors.primary).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformFilter extends StatelessWidget {
  final List<String> platforms;
  final String? selectedPlatform;
  final void Function(String?) onChanged;

  const _PlatformFilter({
    required this.platforms,
    required this.selectedPlatform,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        _FilterChip(
          label: l10n.devicesAllPlatforms,
          isSelected: selectedPlatform == null,
          onTap: () => onChanged(null),
        ),
        ...platforms.map((p) => _FilterChip(
              label: p.toUpperCase(),
              isSelected: selectedPlatform == p,
              onTap: () => onChanged(p),
            )),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final String platform;

  const _PlatformBadge({required this.platform});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (platform.toLowerCase()) {
      case 'ios':
        icon = Icons.apple;
        color = Colors.black87;
        break;
      case 'android':
        icon = Icons.android;
        color = Colors.green;
        break;
      default:
        icon = Icons.devices;
        color = AppColors.textSecondary;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          platform,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
