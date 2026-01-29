import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/fee_payment_model.dart';
import '../manager/fee_bloc/fee_bloc.dart';

class PendingFeesPage extends StatefulWidget {
  final String? studentId;

  const PendingFeesPage({super.key, this.studentId});

  @override
  State<PendingFeesPage> createState() => _PendingFeesPageState();
}

class _PendingFeesPageState extends State<PendingFeesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final bloc = context.read<FeeBloc>();
    if (widget.studentId != null) {
      bloc.add(FetchStudentPendingFees(widget.studentId!));
    } else {
      bloc.add(const FetchOverduePayments());
      bloc.add(const FetchAllPayments());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text(
          widget.studentId != null ? 'My Pending Fees' : 'Pending & Overdue',
          style: AppStyles.large.bold.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        bottom: widget.studentId == null
            ? TabBar(
                controller: _tabController,
                indicatorColor: AppColors.safetyBlue,
                labelStyle: AppStyles.small.bold.white,
                unselectedLabelStyle: AppStyles.small.regular.greyColor,
                tabs: const [
                  Tab(text: 'Overdue'),
                  Tab(text: 'All Pending'),
                ],
              )
            : null,
      ),
      body: BlocBuilder<FeeBloc, FeeState>(
        builder: (context, state) {
          if (state.isLoading &&
              state.overduePayments.isEmpty &&
              state.pendingFees.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          if (widget.studentId != null) {
            return _buildFeeList(state.pendingFees);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildFeeList(state.overduePayments),
              _buildFeeList(state.payments
                  .where((p) =>
                      p.isPending || p.isPartial || p.isOverdue)
                  .toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeeList(List<FeePaymentResponse> fees) {
    if (fees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64,
                color: AppColors.safetyGreen.withValues(alpha: 0.5)),
            Space.h16,
            Text('No pending fees', style: AppStyles.medium.regular.greyColor),
            Space.h4,
            Text('All fees are up to date',
                style: AppStyles.small.regular
                    .colored(AppColors.safetyGreen)),
          ],
        ),
      );
    }

    // Calculate total pending
    final totalPending =
        fees.fold<double>(0.0, (sum, f) => sum + f.balanceAmount);

    return Column(
      children: [
        // Summary bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.safetyLightRed.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${fees.length} pending',
                  style: AppStyles.small.semiBold.white),
              Text(
                'Total: \u{20B9}${totalPending.toStringAsFixed(0)}',
                style: AppStyles.small.bold
                    .colored(AppColors.safetyLightRed),
              ),
            ],
          ),
        ),
        // List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              if (widget.studentId != null) {
                context
                    .read<FeeBloc>()
                    .add(FetchStudentPendingFees(widget.studentId!));
              } else {
                context.read<FeeBloc>().add(const FetchOverduePayments());
                context.read<FeeBloc>().add(const FetchAllPayments());
              }
            },
            child: ListView.builder(
              padding: AppPadding.padA16,
              itemCount: fees.length,
              itemBuilder: (context, index) =>
                  _buildPendingCard(fees[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingCard(FeePaymentResponse payment) {
    final statusColor = _getStatusColor(payment.paymentStatus);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/fees/receipt/${payment.id}'),
        child: GlassyBackground(
          borderColor: statusColor.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      payment.studentName ?? 'Student',
                      style: AppStyles.semiMedium.semiBold.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      payment.paymentStatus,
                      style: AppStyles.extraSmall.bold.colored(statusColor),
                    ),
                  ),
                ],
              ),
              Space.h8,

              // Fee type and structure
              Row(
                children: [
                  Icon(Icons.receipt_outlined,
                      size: 14, color: AppColors.safetyLightBlue),
                  Space.w4,
                  Text(
                    payment.feeStructure?.feeType?.name ?? 'Fee',
                    style: AppStyles.extraSmall.regular
                        .colored(AppColors.safetyLightBlue),
                  ),
                  if (payment.feeStructure?.term != null) ...[
                    Text(' | ',
                        style: AppStyles.extraSmall.regular.greyColor),
                    Text(payment.feeStructure!.term!,
                        style: AppStyles.extraSmall.regular.greyColor),
                  ],
                ],
              ),
              Space.h8,

              // Amount details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total',
                          style: AppStyles.extraSmall.regular.greyColor),
                      Text(
                        '\u{20B9}${payment.totalAmount.toStringAsFixed(0)}',
                        style: AppStyles.small.semiBold.white,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Paid',
                          style: AppStyles.extraSmall.regular.greyColor),
                      Text(
                        '\u{20B9}${payment.amountPaid.toStringAsFixed(0)}',
                        style: AppStyles.small.semiBold
                            .colored(AppColors.safetyGreen),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Balance',
                          style: AppStyles.extraSmall.regular.greyColor),
                      Text(
                        '\u{20B9}${payment.balanceAmount.toStringAsFixed(0)}',
                        style: AppStyles.small.bold
                            .colored(AppColors.safetyLightRed),
                      ),
                    ],
                  ),
                ],
              ),
              Space.h8,

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: payment.totalAmount > 0
                      ? (payment.amountPaid / payment.totalAmount)
                          .clamp(0.0, 1.0)
                      : 0.0,
                  backgroundColor:
                      AppColors.whiteColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    payment.amountPaid > 0
                        ? AppColors.safetyGreen
                        : statusColor,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
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
      default:
        return AppColors.selectiveYellow;
    }
  }
}
