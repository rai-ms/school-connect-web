import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/incident_report_model.dart';
import '../models/counseling_referral_model.dart';
import '../models/emergency_alert_model.dart';

abstract class SafetyRepository {
  Future<IncidentReportResponse> createIncidentReport(IncidentReportRequest request);
  Future<CounselingReferralResponse> createCounselingReferral(CounselingReferralRequest request);
  Future<EmergencyAlertResponse> triggerEmergencyAlert(EmergencyAlertRequest request);
  Future<List<EmergencyAlertResponse>> getActiveAlerts();
}

@Singleton(as: SafetyRepository)
class SafetyRepositoryImpl implements SafetyRepository {
  final ApiDispatcher _apiDispatcher;

  SafetyRepositoryImpl(this._apiDispatcher);

  @override
  Future<IncidentReportResponse> createIncidentReport(IncidentReportRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/safety/incidents',
      body: request.toJson(),
    );

    final data = response.data['data'] ?? response.data;
    return IncidentReportResponse.fromJson(data);
  }

  @override
  Future<CounselingReferralResponse> createCounselingReferral(CounselingReferralRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/safety/counseling',
      body: request.toJson(),
    );

    final data = response.data['data'] ?? response.data;
    return CounselingReferralResponse.fromJson(data);
  }

  @override
  Future<EmergencyAlertResponse> triggerEmergencyAlert(EmergencyAlertRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/safety/alerts',
      body: request.toJson(),
    );

    final data = response.data['data'] ?? response.data;
    return EmergencyAlertResponse.fromJson(data);
  }

  @override
  Future<List<EmergencyAlertResponse>> getActiveAlerts() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/safety/alerts/active',
    );

    final data = response.data['data'] ?? response.data;
    if (data is List) {
      return data.map((e) => EmergencyAlertResponse.fromJson(e)).toList();
    }
    return [];
  }
}
