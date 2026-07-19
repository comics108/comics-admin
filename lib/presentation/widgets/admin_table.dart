import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AdminTableColumn<T> {
  final String header;
  final Widget Function(T item) cellBuilder;
  final double? width;
  final bool flex;

  const AdminTableColumn({
    required this.header,
    required this.cellBuilder,
    this.width,
    this.flex = false,
  });
}

class AdminTable<T> extends StatelessWidget {
  final List<AdminTableColumn<T>> columns;
  final List<T> data;
  final void Function(T item)? onRowTap;
  final bool isLoading;
  final String? emptyMessage;

  const AdminTable({
    super.key,
    required this.columns,
    required this.data,
    this.onRowTap,
    this.isLoading = false,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            emptyMessage ?? 'Нет данных',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header
        Container(
          decoration: const BoxDecoration(
            color: AppColors.tableHeader,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: columns.map((col) {
              final child = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  col.header,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              );

              if (col.flex) {
                return Expanded(child: child);
              }
              if (col.width != null) {
                return SizedBox(width: col.width, child: child);
              }
              return child;
            }).toList(),
          ),
        ),

        // Body
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final isEven = index % 2 == 0;

              return InkWell(
                onTap: onRowTap != null ? () => onRowTap!(item) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isEven ? AppColors.surface : AppColors.tableRowAlt,
                    border: const Border(
                      bottom: BorderSide(color: AppColors.border, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: columns.map((col) {
                      final child = Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: col.cellBuilder(item),
                      );

                      if (col.flex) {
                        return Expanded(child: child);
                      }
                      if (col.width != null) {
                        return SizedBox(width: col.width, child: child);
                      }
                      return child;
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AdminTableCell extends StatelessWidget {
  final String text;
  final bool secondary;
  final bool bold;

  const AdminTableCell(
    this.text, {
    super.key,
    this.secondary = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: secondary ? AppColors.textSecondary : AppColors.textPrimary,
        fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class AdminTableActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminTableActions({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: onEdit,
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onDelete,
            color: AppColors.error,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }
}
