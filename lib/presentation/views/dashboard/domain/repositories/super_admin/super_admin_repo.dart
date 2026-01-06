import 'package:dio/dio.dart';

abstract class SuperAdminDashboardRepo {
  const SuperAdminDashboardRepo();

  Future<Response> fetchDashboard();
}
