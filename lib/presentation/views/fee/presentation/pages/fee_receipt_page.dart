import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/fee_payment_model.dart';
import '../manager/fee_bloc/fee_bloc.dart';

class FeeReceiptPage extends StatefulWidget {
  final String paymentId;

  const FeeReceiptPage({super.key, required this.paymentId});

  @override
  State<FeeReceiptPage> createState() => _FeeReceiptPageState();
}

class _FeeReceiptPageState extends State<FeeReceiptPage> {
  @override
  void initState() {
    super.initState();
    context.read<FeeBloc>().add(FetchReceipt(widget.paymentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Payment Receipt', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<FeeBloc, FeeState>(
        builder: (context, state) {
          if (state.isLoading && state.selectedPayment == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          final payment = state.selectedPayment;
          if (payment == null) {
            return Center(
              child: Text('Receipt not found',
                  style: AppStyles.medium.regular.greyColor),
            );
          }

          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Column(
              children: [
                // Receipt Header
                _buildReceiptHeader(payment),
                Space.h16,

                // Amount Breakdown
                _buildAmountBreakdown(payment),
                Space.h16,

                // Payment Info
                _buildPaymentInfo(payment),
                Space.h16,

                // Student Info
                _buildStudentInfo(payment),
                Space.h30,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceiptHeader(FeePaymentResponse payment) {
    final statusColor = _getStatusColor(payment.paymentStatus);

    return GlassyBackground(
      borderColor: statusColor.withValues(alpha: 0.3),
      child: Column(
        children: [
          // Receipt Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('RECEIPT', style: AppStyles.small.bold.greyColor),
              if (payment.receiptNumber != null)
                Text(
                  payment.receiptNumber!,
                  style: AppStyles.small.bold
                      .colored(AppColors.safetyLightBlue),
                ),
            ],
          ),
          Space.h16,

          // Large Amount
          Text(
            '\u{20B9}${payment.amountPaid.toStringAsFixed(2)}',
            style: AppStyles.extraLarge.bold.colored(statusColor),
          ),
          Space.h8,

          // Status Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              payment.paymentStatus,
              style: AppStyles.small.bold.colored(statusColor),
            ),
          ),
          Space.h12,

          // Date
          if (payment.paymentDate != null)
            Text(
              'Date: ${payment.paymentDate}',
              style: AppStyles.small.regular.greyColor,
            ),
        ],
      ),
    );
  }

  Widget _buildAmountBreakdown(FeePaymentResponse payment) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount Breakdown',
              style: AppStyles.semiMedium.bold.white),
          Space.h12,
          _buildAmountRow('Total Amount', payment.totalAmount),
          if (payment.discountAmount > 0)
            _buildAmountRow(
                'Discount', -payment.discountAmount, AppColors.safetyGreen),
          if (payment.lateFeeAmount > 0)
            _buildAmountRow(
                'Late Fee', payment.lateFeeAmount, AppColors.safetyLightRed),
          const Divider(color: AppColors.greyColor, height: 24),
          _buildAmountRow('Amount Paid', payment.amountPaid,
              AppColors.safetyGreen),
          if (payment.balanceAmount > 0)
            _buildAmountRow('Balance Due', payment.balanceAmount,
                AppColors.safetyLightRed),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.small.regular.greyColor),
          Text(
            '${amount < 0 ? '-' : ''}\u{20B9}${amount.abs().toStringAsFixed(2)}',
            style: color != null
                ? AppStyles.small.semiBold.colored(color)
                : AppStyles.small.semiBold.white,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(FeePaymentResponse payment) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Details',
              style: AppStyles.semiMedium.bold.white),
          Space.h12,
          if (payment.paymentMode != null)
            _buildInfoRow('Mode', payment.paymentMode!.replaceAll('_', ' ')),
          if (payment.transactionId != null)
            _buildInfoRow('Transaction ID', payment.transactionId!),
          if (payment.collectedBy != null)
            _buildInfoRow('Collected By', payment.collectedBy!),
          if (payment.feeStructure?.feeType?.name != null)
            _buildInfoRow('Fee Type', payment.feeStructure!.feeType!.name),
          if (payment.feeStructure?.academicYear != null)
            _buildInfoRow(
                'Academic Year', payment.feeStructure!.academicYear!),
          if (payment.feeStructure?.term != null)
            _buildInfoRow('Term', payment.feeStructure!.term!),
          if (payment.remarks != null)
            _buildInfoRow('Remarks', payment.remarks!),
        ],
      ),
    );
  }

  Widget _buildStudentInfo(FeePaymentResponse payment) {
    return GlassyBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Student Information',
              style: AppStyles.semiMedium.bold.white),
          Space.h12,
          if (payment.studentName != null)
            _buildInfoRow('Name', payment.studentName!),
          _buildInfoRow('Student ID', payment.studentId),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppStyles.small.regular.greyColor),
          ),
          Expanded(
            child:
                Text(value, style: AppStyles.small.semiBold.white),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PAID':
        return AppColors.safetyGreen;
      case 'PARTIAL':
        return AppColors.safetyOrange;
      case 'OVERDUE':
        return AppColors.safetyLightRed;
      case 'CANCELLED':
        return AppColors.greyColor;
      case 'REFUNDED':
        return AppColors.safetyBlue;
      default:
        return AppColors.selectiveYellow;
    }
  }
}
