import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';

class AdminPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final void Function(int page) onPageChanged;

  const AdminPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final start = (currentPage - 1) * itemsPerPage + 1;
    final end = currentPage * itemsPerPage > totalItems
        ? totalItems
        : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.showing(start, end, totalItems),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              _PaginationButton(
                icon: Icons.chevron_left,
                enabled: currentPage > 1,
                onPressed: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 4),
              ..._buildPageButtons(),
              const SizedBox(width: 4),
              _PaginationButton(
                icon: Icons.chevron_right,
                enabled: currentPage < totalPages,
                onPressed: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageButtons() {
    final pages = <Widget>[];
    final range = _getPageRange();

    for (var i = range.start; i <= range.end; i++) {
      if (i == range.start && i > 1) {
        pages.add(_PageNumber(page: 1, isSelected: false, onPressed: () => onPageChanged(1)));
        if (i > 2) {
          pages.add(const _Ellipsis());
        }
      }

      pages.add(_PageNumber(
        page: i,
        isSelected: i == currentPage,
        onPressed: () => onPageChanged(i),
      ));

      if (i == range.end && i < totalPages) {
        if (i < totalPages - 1) {
          pages.add(const _Ellipsis());
        }
        pages.add(_PageNumber(
          page: totalPages,
          isSelected: false,
          onPressed: () => onPageChanged(totalPages),
        ));
      }
    }

    return pages;
  }

  ({int start, int end}) _getPageRange() {
    const maxVisible = 5;

    if (totalPages <= maxVisible) {
      return (start: 1, end: totalPages);
    }

    var start = currentPage - 2;
    var end = currentPage + 2;

    if (start < 1) {
      end += (1 - start);
      start = 1;
    }

    if (end > totalPages) {
      start -= (end - totalPages);
      end = totalPages;
    }

    if (start < 1) start = 1;

    return (start: start, end: end);
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _PaginationButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.textPrimary : AppColors.textSecondary.withOpacity(0.5),
        ),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onPressed;

  const _PageNumber({
    required this.page,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelected ? null : onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      child: Center(
        child: Text(
          '...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
