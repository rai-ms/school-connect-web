import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'data/models/emergency_alert_model.dart';
import 'data/repositories/safety_repository.dart';

class SafetyLogPage extends StatefulWidget {
  const SafetyLogPage({super.key});

  @override
  State<SafetyLogPage> createState() => _SafetyLogPageState();
}

class _SafetyLogPageState extends State<SafetyLogPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final SafetyRepository _safetyRepository;

  bool _isLoadingAlerts = false;
  List<EmergencyAlertResponse> _alerts = [];
  String? _alertsError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _safetyRepository = InjectorService.service.inject<SafetyRepository>();
    _fetchAlerts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAlerts() async {
    setState(() {
      _isLoadingAlerts = true;
      _alertsError = null;
    });
    try {
      final alerts = await _safetyRepository.getActiveAlerts();
      if (mounted) {
        setState(() {
          _alerts = alerts;
          _isLoadingAlerts = false;
        });
      }
    } catch (e) {
      Log.e("Failed to fetch alerts: $e");
      if (mounted) {
        setState(() {
          _isLoadingAlerts = false;
          _alertsError = 'Failed to load alerts. Pull to refresh.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safety Log',
          style: AppStyles.large.bold.chineseBlack,
        ),
        backgroundColor: AppColors.ghostWhite,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.safetyRed,
          unselectedLabelColor: AppColors.darkElectricBlue,
          indicatorColor: AppColors.safetyRed,
          labelStyle: AppStyles.medium.medium,
          unselectedLabelStyle: AppStyles.medium.regular,
          tabs: const [
            Tab(text: 'Incidents'),
            Tab(text: 'Counseling'),
            Tab(text: 'Alerts'),
          ],
        ),
      ),
      backgroundColor: AppColors.ghostWhite,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIncidentsTab(),
          _buildCounselingTab(),
          _buildAlertsTab(),
        ],
      ),
    );
  }

  // ---------- Incidents Tab ----------

  Widget _buildIncidentsTab() {
    // The SafetyRepository only has createIncidentReport and no list endpoint.
    // Show an empty state directing users to report incidents.
    return _buildEmptyState(
      icon: Icons.report_problem_outlined,
      title: 'No Incidents Reported',
      subtitle: 'Incident reports will appear here once submitted.',
      color: AppColors.safetyOrange,
    );
  }

  // ---------- Counseling Tab ----------

  Widget _buildCounselingTab() {
    // The SafetyRepository only has createCounselingReferral and no list endpoint.
    // Show an empty state directing users to create referrals.
    return _buildEmptyState(
      icon: Icons.psychology_outlined,
      title: 'No Counseling Referrals',
      subtitle: 'Counseling referrals will appear here once submitted.',
      color: AppColors.safetyBlue,
    );
  }

  // ---------- Alerts Tab ----------

  Widget _buildAlertsTab() {
    if (_isLoadingAlerts) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.safetyRed,
        ),
      );
    }

    if (_alertsError != null && _alerts.isEmpty) {
      return _buildErrorState(_alertsError!, onRetry: _fetchAlerts);
    }

    if (_alerts.isEmpty) {
      return _buildEmptyState(
        icon: Icons.notifications_off_outlined,
        title: 'No Active Alerts',
        subtitle: 'Emergency alerts will appear here when triggered.',
        color: AppColors.safetyRed,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAlerts,
      color: AppColors.safetyRed,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          return _buildAlertCard(alert);
        },
      ),
    );
  }

  Widget _buildAlertCard(EmergencyAlertResponse alert) {
    final severityColor = _getSeverityColor(alert.severity);
    final statusLabel = alert.isActive ? 'Active' : 'Resolved';
    final statusColor = alert.isActive
        ? AppColors.safetyRed
        : AppColors.safetyGreen;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alert.title,
                  style: AppStyles.medium.semiBold.chineseBlack,
                ),
              ),
              _buildStatusChip(statusLabel, statusColor),
            ],
          ),
          const SizedBox(height: 8),
          if (alert.message != null && alert.message!.isNotEmpty) ...[
            Text(
              alert.message!,
              style: AppStyles.small.regular.darkElectricBlue,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              _buildInfoChip(
                'Type: ${alert.alertType}',
                AppColors.safetyBlue,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                alert.severity,
                severityColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.darkElectricBlue,
              ),
              const SizedBox(width: 4),
              Text(
                alert.createdAt != null
                    ? DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(alert.createdAt!)
                    : 'Date unavailable',
                style: AppStyles.small.regular.darkElectricBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Shared Widgets ----------

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppStyles.small.medium.colored(color),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppStyles.extraSmall.medium.colored(color),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppStyles.large.semiBold.chineseBlack,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppStyles.regular.regular.darkElectricBlue,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.safetyRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.safetyRed,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: AppStyles.regular.regular.darkElectricBlue,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: AppColors.safetyRed),
                label: Text(
                  'Retry',
                  style: AppStyles.medium.medium.safetyRed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'HIGH':
      case 'CRITICAL':
        return AppColors.safetyRed;
      case 'MEDIUM':
        return AppColors.safetyOrange;
      case 'LOW':
        return AppColors.safetyYellow;
      default:
        return AppColors.safetyGrey;
    }
  }
}
