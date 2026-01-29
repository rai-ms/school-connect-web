import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/fee_payment_model.dart';
import '../../data/models/fee_structure_model.dart';
import '../manager/fee_bloc/fee_bloc.dart';

class CollectFeePage extends StatefulWidget {
  const CollectFeePage({super.key});

  @override
  State<CollectFeePage> createState() => _CollectFeePageState();
}

class _CollectFeePageState extends State<CollectFeePage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _lateFeeController = TextEditingController(text: '0');
  final _transactionIdController = TextEditingController();
  final _remarksController = TextEditingController();
  final _collectedByController = TextEditingController();

  String? _selectedFeeStructureId;
  String _selectedPaymentMode = 'CASH';

  static const List<String> _paymentModes = [
    'CASH',
    'CHEQUE',
    'ONLINE',
    'BANK_TRANSFER',
    'UPI',
    'CARD',
  ];

  @override
  void initState() {
    super.initState();
    context.read<FeeBloc>().add(const FetchFeeStructures());
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _amountController.dispose();
    _totalAmountController.dispose();
    _discountController.dispose();
    _lateFeeController.dispose();
    _transactionIdController.dispose();
    _remarksController.dispose();
    _collectedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Collect Fee', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocConsumer<FeeBloc, FeeState>(
        listener: (context, state) {
          if (state.isFailed && state.event is CollectFee) {
            BotToast.showText(text: state.error ?? 'Payment failed');
          }
          if (state.isSuccess && state.event is CollectFee) {
            BotToast.showText(text: 'Payment collected successfully');
            if (state.selectedPayment != null) {
              context.pushReplacement(
                  '/fees/receipt/${state.selectedPayment!.id}');
            } else {
              context.pop();
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fee Structure Selection
                  Text('Fee Structure', style: AppStyles.small.bold.white),
                  Space.h8,
                  _buildFeeStructureDropdown(state.feeStructures),
                  Space.h16,

                  // Student Info
                  Text('Student Information',
                      style: AppStyles.small.bold.white),
                  Space.h8,
                  _buildTextField(
                    controller: _studentIdController,
                    label: 'Student ID',
                    icon: Icons.badge_outlined,
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Student ID required' : null,
                  ),
                  Space.h12,
                  _buildTextField(
                    controller: _studentNameController,
                    label: 'Student Name',
                    icon: Icons.person_outline,
                  ),
                  Space.h16,

                  // Amount Section
                  Text('Payment Details', style: AppStyles.small.bold.white),
                  Space.h8,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _totalAmountController,
                          label: 'Total Amount',
                          icon: Icons.currency_rupee,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                      Space.w12,
                      Expanded(
                        child: _buildTextField(
                          controller: _amountController,
                          label: 'Amount Paid',
                          icon: Icons.payment,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  Space.h12,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _discountController,
                          label: 'Discount',
                          icon: Icons.discount_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Space.w12,
                      Expanded(
                        child: _buildTextField(
                          controller: _lateFeeController,
                          label: 'Late Fee',
                          icon: Icons.schedule,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Space.h16,

                  // Payment Mode
                  Text('Payment Mode', style: AppStyles.small.bold.white),
                  Space.h8,
                  _buildPaymentModeSelector(),
                  Space.h16,

                  // Optional Fields
                  if (_selectedPaymentMode != 'CASH') ...[
                    _buildTextField(
                      controller: _transactionIdController,
                      label: 'Transaction ID',
                      icon: Icons.receipt_long_outlined,
                    ),
                    Space.h12,
                  ],

                  _buildTextField(
                    controller: _collectedByController,
                    label: 'Collected By',
                    icon: Icons.person_pin_outlined,
                  ),
                  Space.h12,
                  _buildTextField(
                    controller: _remarksController,
                    label: 'Remarks',
                    icon: Icons.notes,
                    maxLines: 2,
                  ),
                  Space.h24,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.safetyGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading &&
                              state.event is CollectFee
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text('Collect Payment',
                              style: AppStyles.medium.bold.white),
                    ),
                  ),
                  Space.h30,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeeStructureDropdown(List<FeeStructureResponse> structures) {
    return GlassyBackground(
      child: DropdownButtonFormField<String>(
        initialValue: _selectedFeeStructureId,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        dropdownColor: AppColors.backgroundImageColor,
        style: AppStyles.small.regular.white,
        hint: Text('Select Fee Structure',
            style: AppStyles.small.regular.greyColor),
        items: structures.map((s) {
          final label =
              '${s.feeType?.name ?? 'Fee'} - \u{20B9}${s.amount.toStringAsFixed(0)}';
          return DropdownMenuItem(
            value: s.id,
            child: Text(label, style: AppStyles.small.regular.white),
          );
        }).toList(),
        onChanged: (val) {
          setState(() => _selectedFeeStructureId = val);
          if (val != null) {
            final selected =
                structures.firstWhere((s) => s.id == val);
            _totalAmountController.text =
                selected.effectiveAmount.toStringAsFixed(2);
          }
        },
        validator: (v) => v == null ? 'Select a fee structure' : null,
      ),
    );
  }

  Widget _buildPaymentModeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _paymentModes.map((mode) {
        final isSelected = _selectedPaymentMode == mode;
        return ChoiceChip(
          label: Text(mode.replaceAll('_', ' ')),
          selected: isSelected,
          selectedColor: AppColors.safetyBlue,
          backgroundColor: AppColors.whiteColor.withValues(alpha: 0.1),
          labelStyle: isSelected
              ? AppStyles.extraSmall.bold.white
              : AppStyles.extraSmall.regular.greyColor,
          onSelected: (_) =>
              setState(() => _selectedPaymentMode = mode),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppStyles.small.regular.white,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.small.regular.greyColor,
        prefixIcon: Icon(icon, color: AppColors.safetyBlue, size: 20),
        filled: true,
        fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.whiteColor.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.whiteColor.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.safetyBlue),
        ),
      ),
    );
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) return;

    final request = FeePaymentRequest(
      feeStructureId: _selectedFeeStructureId!,
      studentId: _studentIdController.text.trim(),
      studentName: _studentNameController.text.trim().isNotEmpty
          ? _studentNameController.text.trim()
          : null,
      amountPaid: double.tryParse(_amountController.text.trim()) ?? 0,
      totalAmount:
          double.tryParse(_totalAmountController.text.trim()) ?? 0,
      discountAmount:
          double.tryParse(_discountController.text.trim()),
      lateFeeAmount:
          double.tryParse(_lateFeeController.text.trim()),
      paymentMode: _selectedPaymentMode,
      transactionId: _transactionIdController.text.trim().isNotEmpty
          ? _transactionIdController.text.trim()
          : null,
      remarks: _remarksController.text.trim().isNotEmpty
          ? _remarksController.text.trim()
          : null,
      collectedBy: _collectedByController.text.trim().isNotEmpty
          ? _collectedByController.text.trim()
          : null,
    );

    context.read<FeeBloc>().add(CollectFee(request));
  }
}
