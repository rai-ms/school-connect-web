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
import 'package:student_management/core/services/route_service/route_names.dart';

class FeeDashboardPage extends StatefulWidget {
  const FeeDashboardPage({super.key});

  @override
  State<FeeDashboardPage> createState() => _FeeDashboardPageState();
}

class _FeeDashboardPageState extends State<FeeDashboardPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<FeeBloc>();
    bloc.add(const FetchCollectionReport());
    bloc.add(const FetchOverduePayments());
    bloc.add(const FetchAllPayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Fee Management', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocBuilder<FeeBloc, FeeState>(
        builder: (context, state) {
          if (state.isLoading && state.collectionReport == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeeBloc>().add(const FetchCollectionReport());
              context.read<FeeBloc>().add(const FetchOverduePayments());
              context.read<FeeBloc>().add(const FetchAllPayments());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppPadding.padA16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collection Summary
                  if (state.collectionReport != null)
                    _buildCollectionSummary(state.collectionReport!),
                  Space.h20,

                  // Quick Actions
                  Text('Quick Actions', style: AppStyles.medium.bold.white),
                  Space.h12,
                  _buildQuickActions(),
                  Space.h20,

                  // Overdue Payments
                  if (state.overduePayments.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Overdue Payments',
                            style: AppStyles.medium.bold.white),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.safetyLightRed
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${state.overduePayments.length}',
                            style: AppStyles.small.bold
                                .colored(AppColors.safetyLightRed),
                          ),
                        ),
                      ],
                    ),
                    Space.h12,
                    ...state.overduePayments
                        .take(5)
                        .map((p) => _buildPaymentCard(p)),
                    Space.h20,
                  ],

                  // Recent Payments
                  if (state.payments.isNotEmpty) ...[
                    Text('Recent Payments',
                        style: AppStyles.medium.bold.white),
                    Space.h12,
                    ...state.payments.take(10).map((p) => _buildPaymentCard(p)),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RoutesName.collectFee),
        backgroundColor: AppColors.safetyGreen,
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
        label: Text('Collect Fee', style: AppStyles.small.bold.white),
      ),
    );
  }

  Widget _buildCollectionSummary(CollectionReport report) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Collected',
                _formatCurrency(report.totalCollected),
                Icons.account_balance_wallet,
                AppColors.safetyGreen,
              ),
            ),
            Space.w12,
            Expanded(
              child: _buildStatCard(
                'Total Pending',
                _formatCurrency(report.totalPending),
                Icons.pending_actions,
                AppColors.safetyOrange,
              ),
            ),
          ],
        ),
        Space.h12,
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'This Month',
                _formatCurrency(report.monthlyCollection),
                Icons.calendar_month,
                AppColors.safetyBlue,
              ),
            ),
            Space.w12,
            Expanded(
              child: _buildStatCard(
                'Overdue',
                '${report.overdueCount}',
                Icons.warning_amber_rounded,
                AppColors.safetyLightRed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return GlassyBackground(
      borderColor: color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              Space.w8,
              Expanded(
                child: Text(title,
                    style: AppStyles.extraSmall.regular.greyColor,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Space.h8,
          Text(value, style: AppStyles.large.bold.colored(color)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Collect Fee',
            Icons.payment,
            AppColors.safetyGreen,
            () => context.push(RoutesName.collectFee),
          ),
        ),
        Space.w8,
        Expanded(
          child: _buildActionButton(
            'Pending Fees',
            Icons.pending_actions,
            AppColors.safetyOrange,
            () => context.push(RoutesName.pendingFees),
          ),
        ),
        Space.w8,
        Expanded(
          child: _buildActionButton(
            'Fee Types',
            Icons.category,
            AppColors.safetyBlue,
            () {
              // Fee types management - could be inline or separate page
              context.read<FeeBloc>().add(const FetchFeeTypes());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassyBackground(
        borderColor: color.withValues(alpha: 0.3),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            Space.h8,
            Text(label,
                style: AppStyles.extraSmall.semiBold.white,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(FeePaymentResponse payment) {
    final statusColor = _getStatusColor(payment.paymentStatus);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/fees/receipt/${payment.id}'),
        child: GlassyBackground(
          borderColor: statusColor.withValues(alpha: 0.3),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Space.w12,
              // Payment details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        _buildStatusChip(payment.paymentStatus, statusColor),
                      ],
                    ),
                    Space.h4,
                    Row(
                      children: [
                        Text(
                          payment.feeStructure?.feeType?.name ?? 'Fee',
                          style: AppStyles.extraSmall.regular.greyColor,
                        ),
                        if (payment.receiptNumber != null) ...[
                          Text(' | ',
                              style: AppStyles.extraSmall.regular.greyColor),
                          Text(payment.receiptNumber!,
                              style: AppStyles.extraSmall.regular
                                  .colored(AppColors.safetyLightBlue)),
                        ],
                      ],
                    ),
                    Space.h4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid: ${_formatCurrency(payment.amountPaid)}',
                          style: AppStyles.small.semiBold
                              .colored(AppColors.safetyGreen),
                        ),
                        if (payment.balanceAmount > 0)
                          Text(
                            'Due: ${_formatCurrency(payment.balanceAmount)}',
                            style: AppStyles.small.semiBold
                                .colored(AppColors.safetyLightRed),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: AppStyles.extraSmall.bold.colored(color),
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

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '\u{20B9}${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\u{20B9}${amount.toStringAsFixed(0)}';
  }
}
