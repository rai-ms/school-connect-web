import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import 'package:student_management/core/utils/api_end_point.dart';
import '../models/res/school_admin/dashboard_stats_model.dart';
import '../../../fee/data/models/fee_payment_model.dart';

abstract class SchoolAdminDashboardRepository {
  Future<TenantStatistics> getTenantStatistics();
  Future<CollectionReport> getFeeCollectionReport();
  Future<int> getPendingLeaveCount();
}

@Singleton(as: SchoolAdminDashboardRepository)
class SchoolAdminDashboardRepositoryImpl
    implements SchoolAdminDashboardRepository {
  final ApiDispatcher _apiDispatcher;

  SchoolAdminDashboardRepositoryImpl(this._apiDispatcher);

  @override
  Future<TenantStatistics> getTenantStatistics() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: ApiEndPoint.tenantStatistics,
    );
    return TenantStatistics.fromJson(response.data);
  }

  @override
  Future<CollectionReport> getFeeCollectionReport() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: ApiEndPoint.feeCollectionReport,
    );
    return CollectionReport.fromJson(response.data);
  }

  @override
  Future<int> getPendingLeaveCount() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: ApiEndPoint.pendingLeaveRequests,
    );
    final data = response.data;
    if (data is Map && data['content'] != null) {
      return (data['content'] as List).length;
    }
    if (data is List) {
      return data.length;
    }
    return 0;
  }
}
