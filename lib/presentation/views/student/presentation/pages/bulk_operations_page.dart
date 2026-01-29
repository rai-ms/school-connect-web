import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/student_model.dart';
import '../manager/student_bloc/student_bloc.dart';

class BulkOperationsPage extends StatefulWidget {
  const BulkOperationsPage({super.key});

  @override
  State<BulkOperationsPage> createState() => _BulkOperationsPageState();
}

class _BulkOperationsPageState extends State<BulkOperationsPage> {
  // Export filters
  String? _exportClassId;
  String? _exportSectionId;
  String? _exportStatus;

  // Import state
  String? _selectedFilePath;
  String? _selectedFileName;
  String? _importClassId;
  List<List<String>> _previewRows = [];
  List<String> _previewHeaders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Bulk Operations', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state.actionCompleted && state.event is ExportStudents) {
            _showSnackBar('CSV exported to: ${state.exportedFilePath}');
          }
          if (state.actionCompleted && state.event is DownloadImportTemplate) {
            _showSnackBar('Template saved to: ${state.exportedFilePath}');
          }
          if (state.actionCompleted && state.event is ImportStudents) {
            // Import result will be shown in the UI
          }
          if (state.isFailed) {
            _showSnackBar(state.error ?? 'An error occurred', isError: true);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExportSection(state),
                Space.h24,
                _buildImportSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== Export Section ====================

  Widget _buildExportSection(StudentState state) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.file_upload_outlined,
                  color: AppColors.safetyBlue, size: 24),
              Space.w8,
              Text('Export Students', style: AppStyles.medium.bold.white),
            ],
          ),
          Space.h16,
          Text(
            'Export student data as a CSV file with optional filters.',
            style: AppStyles.small.regular.greyColor,
          ),
          Space.h16,

          // Class ID filter
          _buildTextField(
            label: 'Class ID (optional)',
            value: _exportClassId,
            onChanged: (v) => setState(() => _exportClassId = v.isEmpty ? null : v),
          ),
          Space.h12,

          // Section ID filter
          _buildTextField(
            label: 'Section ID (optional)',
            value: _exportSectionId,
            onChanged: (v) => setState(() => _exportSectionId = v.isEmpty ? null : v),
          ),
          Space.h12,

          // Status filter dropdown
          _buildStatusDropdown(),
          Space.h16,

          // Export button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isLoading && state.event is ExportStudents
                  ? null
                  : () {
                      context.read<StudentBloc>().add(ExportStudents(
                            classId: _exportClassId,
                            sectionId: _exportSectionId,
                            status: _exportStatus,
                          ));
                    },
              icon: state.isLoading && state.event is ExportStudents
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.whiteColor,
                      ),
                    )
                  : const Icon(Icons.download, color: AppColors.whiteColor),
              label: Text(
                state.isLoading && state.event is ExportStudents
                    ? 'Exporting...'
                    : 'Export to CSV',
                style: AppStyles.semiMedium.semiBold.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safetyBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Show export result path
          if (state.exportedFilePath != null && state.event is ExportStudents)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.safetyGreen, size: 18),
                  Space.w8,
                  Expanded(
                    child: Text(
                      'Saved: ${state.exportedFilePath}',
                      style: AppStyles.extraSmall.regular.safetyGreen,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ==================== Import Section ====================

  Widget _buildImportSection(StudentState state) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.file_download_outlined,
                  color: AppColors.safetyGreen, size: 24),
              Space.w8,
              Text('Import Students', style: AppStyles.medium.bold.white),
            ],
          ),
          Space.h16,
          Text(
            'Import students from a CSV file. Download the template first to see the required format.',
            style: AppStyles.small.regular.greyColor,
          ),
          Space.h16,

          // Download template button
          OutlinedButton.icon(
            onPressed: state.isLoading && state.event is DownloadImportTemplate
                ? null
                : () {
                    context.read<StudentBloc>().add(const DownloadImportTemplate());
                  },
            icon: state.isLoading && state.event is DownloadImportTemplate
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.safetyBlue,
                    ),
                  )
                : const Icon(Icons.description_outlined,
                    color: AppColors.safetyBlue, size: 18),
            label: Text(
              'Download Template',
              style: AppStyles.small.semiBold.safetyBlue,
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.safetyBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          Space.h16,

          // Class ID for import
          _buildTextField(
            label: 'Default Class ID (optional)',
            value: _importClassId,
            onChanged: (v) => setState(() => _importClassId = v.isEmpty ? null : v),
          ),
          Space.h16,

          // File picker
          _buildFilePicker(),
          Space.h12,

          // Preview section
          if (_previewHeaders.isNotEmpty) _buildPreviewTable(),
          Space.h16,

          // Import button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _selectedFilePath == null ||
                      (state.isLoading && state.event is ImportStudents)
                  ? null
                  : () {
                      context.read<StudentBloc>().add(ImportStudents(
                            filePath: _selectedFilePath!,
                            classId: _importClassId,
                          ));
                    },
              icon: state.isLoading && state.event is ImportStudents
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.whiteColor,
                      ),
                    )
                  : const Icon(Icons.upload_file, color: AppColors.whiteColor),
              label: Text(
                state.isLoading && state.event is ImportStudents
                    ? 'Importing...'
                    : 'Import Students',
                style: AppStyles.semiMedium.semiBold.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.safetyGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor:
                    AppColors.safetyGreen.withValues(alpha: 0.3),
              ),
            ),
          ),

          // Import results
          if (state.importResult != null && state.event is ImportStudents)
            _buildImportResults(state.importResult!),
        ],
      ),
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.whiteColor.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.whiteColor.withValues(alpha: 0.05),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined,
                color: AppColors.greyColor, size: 40),
            Space.h8,
            if (_selectedFileName != null) ...[
              Text(
                _selectedFileName!,
                style: AppStyles.small.semiBold.white,
                textAlign: TextAlign.center,
              ),
              Space.h4,
              Text(
                'Tap to change file',
                style: AppStyles.extraSmall.regular.greyColor,
              ),
            ] else ...[
              Text(
                'Tap to select a CSV file',
                style: AppStyles.small.regular.greyColor,
              ),
              Space.h4,
              Text(
                'Supported format: .csv',
                style: AppStyles.extraSmall.regular
                    .colored(AppColors.greyColor.withValues(alpha: 0.6)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Space.h12,
        Text(
          'Preview (first ${_previewRows.length} rows):',
          style: AppStyles.small.semiBold.white,
        ),
        Space.h8,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
                AppColors.safetyBlue.withValues(alpha: 0.15)),
            dataRowColor: WidgetStateProperty.all(
                AppColors.whiteColor.withValues(alpha: 0.03)),
            border: TableBorder.all(
              color: AppColors.whiteColor.withValues(alpha: 0.1),
              width: 0.5,
            ),
            columnSpacing: 16,
            horizontalMargin: 12,
            columns: _previewHeaders
                .take(6) // Show first 6 columns to avoid overflow
                .map((h) => DataColumn(
                      label: Text(h,
                          style: AppStyles.extraSmall.bold.safetyBlue),
                    ))
                .toList(),
            rows: _previewRows
                .map((row) => DataRow(
                      cells: row
                          .take(6)
                          .map((cell) => DataCell(
                                Text(cell,
                                    style:
                                        AppStyles.extraSmall.regular.white,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildImportResults(BulkImportResult result) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Import Results', style: AppStyles.semiMedium.bold.white),
          Space.h12,

          // Summary cards
          Row(
            children: [
              _buildResultCard(
                'Total',
                result.totalRows.toString(),
                AppColors.safetyBlue,
              ),
              Space.w8,
              _buildResultCard(
                'Success',
                result.successCount.toString(),
                AppColors.safetyGreen,
              ),
              Space.w8,
              _buildResultCard(
                'Errors',
                result.errorCount.toString(),
                AppColors.safetyRed,
              ),
            ],
          ),

          // Error details
          if (result.errors.isNotEmpty) ...[
            Space.h16,
            Text('Error Details:', style: AppStyles.small.semiBold.safetyRed),
            Space.h8,
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: result.errors.length,
                itemBuilder: (context, index) {
                  final error = result.errors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.safetyRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.safetyRed.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Row ${error.rowNumber} - ${error.fieldName}',
                            style: AppStyles.extraSmall.bold.safetyLightRed,
                          ),
                          Space.h4,
                          Text(
                            error.errorMessage,
                            style: AppStyles.extraSmall.regular.white,
                          ),
                          if (error.rawValue != null) ...[
                            Space.h4,
                            Text(
                              'Value: ${error.rawValue}',
                              style: AppStyles.extraSmall.regular.greyColor,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: AppStyles.larger.bold.colored(color)),
            Space.h4,
            Text(label, style: AppStyles.extraSmall.regular.colored(color)),
          ],
        ),
      ),
    );
  }

  // ==================== Helper Widgets ====================

  Widget _buildTextField({
    required String label,
    required String? value,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: TextEditingController(text: value ?? '')
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: value?.length ?? 0),
        ),
      style: AppStyles.small.regular.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.extraSmall.regular.greyColor,
        filled: true,
        fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.whiteColor.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.whiteColor.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.safetyBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildStatusDropdown() {
    const statuses = ['ACTIVE', 'INACTIVE', 'GRADUATED', 'TRANSFERRED', 'DROPPED'];
    return DropdownButtonFormField<String>(
      initialValue: _exportStatus,
      decoration: InputDecoration(
        labelText: 'Status (optional)',
        labelStyle: AppStyles.extraSmall.regular.greyColor,
        filled: true,
        fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.whiteColor.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.whiteColor.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.safetyBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      dropdownColor: AppColors.backgroundImageColor,
      style: AppStyles.small.regular.white,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Statuses'),
        ),
        ...statuses.map((s) => DropdownMenuItem(
              value: s,
              child: Text(s),
            )),
      ],
      onChanged: (v) => setState(() => _exportStatus = v),
    );
  }

  // ==================== Actions ====================

  Future<void> _pickFile() async {
    // Using image_picker's XFile approach for file selection
    // Since file_picker is not available, we use a dialog to enter file path
    // or provide instructions for proper file picking
    final controller = TextEditingController(text: _selectedFilePath ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Select CSV File', style: AppStyles.medium.bold.white),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter the full path to your CSV file:',
              style: AppStyles.small.regular.greyColor,
            ),
            Space.h12,
            TextField(
              controller: controller,
              style: AppStyles.small.regular.white,
              decoration: InputDecoration(
                hintText: '/path/to/students.csv',
                hintStyle: AppStyles.extraSmall.regular.greyColor,
                filled: true,
                fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.whiteColor.withValues(alpha: 0.2),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            Space.h8,
            Text(
              'Note: For best experience, add the file_picker package to enable native file browsing.',
              style: AppStyles.extraSmall.regular
                  .colored(AppColors.safetyOrange.withValues(alpha: 0.8)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppStyles.small.medium.greyColor),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Select', style: AppStyles.small.medium.safetyBlue),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final file = File(result);
      if (await file.exists()) {
        setState(() {
          _selectedFilePath = result;
          _selectedFileName = result.split('/').last;
        });
        _parseCsvPreview(file);
      } else {
        _showSnackBar('File not found at the specified path', isError: true);
      }
    }
  }

  Future<void> _parseCsvPreview(File file) async {
    try {
      final content = await file.readAsString();
      final lines = content.split('\n').where((l) => l.trim().isNotEmpty).toList();
      if (lines.isEmpty) return;

      final headers = _parseCsvLine(lines.first);
      final rows = <List<String>>[];
      for (int i = 1; i < lines.length && i <= 5; i++) {
        rows.add(_parseCsvLine(lines[i]));
      }

      setState(() {
        _previewHeaders = headers;
        _previewRows = rows;
      });
    } catch (e) {
      _showSnackBar('Failed to parse CSV preview: $e', isError: true);
    }
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    bool inQuotes = false;
    StringBuffer current = StringBuffer();

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString().trim());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString().trim());
    return result;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.small.regular.white,
        ),
        backgroundColor: isError ? AppColors.safetyRed : AppColors.safetyGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
