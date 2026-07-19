import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';

class AdminFileDropZone extends StatefulWidget {
  final void Function(PlatformFile file) onFileSelected;
  final List<String>? allowedExtensions;
  final String? hint;

  const AdminFileDropZone({
    super.key,
    required this.onFileSelected,
    this.allowedExtensions,
    this.hint,
  });

  @override
  State<AdminFileDropZone> createState() => _AdminFileDropZoneState();
}

class _AdminFileDropZoneState extends State<AdminFileDropZone> {
  bool _isDragOver = false;
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions != null
          ? FileType.custom
          : FileType.any,
      allowedExtensions: widget.allowedExtensions,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
      widget.onFileSelected(result.files.first);
    }
  }

  void _clearFile() {
    setState(() => _selectedFile = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isDragOver = true);
        return true;
      },
      onLeave: (data) {
        setState(() => _isDragOver = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isDragOver = false);
        // Note: Web drag and drop handling would go here
        // For desktop, FilePicker is the primary method
      },
      builder: (context, candidateData, rejectedData) {
        if (_selectedFile != null) {
          return _buildSelectedFile(l10n);
        }
        return _buildDropZone(l10n);
      },
    );
  }

  Widget _buildDropZone(AppLocalizations l10n) {
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isDragOver ? AppColors.primary : AppColors.border,
            width: _isDragOver ? 2 : 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _isDragOver
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: _isDragOver ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.dragFileHere,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isDragOver ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.hint ?? l10n.orClickToSelect,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (widget.allowedExtensions != null) ...[
              const SizedBox(height: 8),
              Text(
                '${l10n.allowedFormats}: ${widget.allowedExtensions!.join(', ')}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile(AppLocalizations l10n) {
    final file = _selectedFile!;
    final sizeKb = (file.size / 1024).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.success),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.success.withOpacity(0.05),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 32,
            color: AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$sizeKb KB',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _clearFile,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
