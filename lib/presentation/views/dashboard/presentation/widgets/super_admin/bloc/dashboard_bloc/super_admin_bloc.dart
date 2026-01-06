import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/no_param.dart';
import 'package:student_management/core/base/base_client/status_message.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/dashboard/data/models/res/super_admin/get_all_users_response.dart';
import 'package:student_management/presentation/views/dashboard/domain/entities/super_admin_users_based_on_roles/super_admin_all_users.dart';
import 'package:student_management/presentation/views/dashboard/domain/use_cases/super_admin/fetch_super_admin_dashboard.dart';

part 'super_admin_event.dart';
part 'super_admin_state.dart';

@injectable
class SuperAdminDashboardBloc
    extends Bloc<SuperAdminDashboardEvent, SuperAdminDashboardState> {
  final StateRequestHandler _handler;
  final FetchSuperAdminDashboard _useCase;

  SuperAdminDashboardBloc(this._handler, this._useCase)
    : super(const SuperAdminDashboardState()) {
    on<GetDashBoardData>(_getDashBoardData);
  }

  Future<void> _getDashBoardData(
    GetDashBoardData event,
    Emitter<SuperAdminDashboardState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(event: event, state: state.loading));
        var response = await _useCase.call(params: const NoParam());
        Log.d("Response of SuperAdminDashboard is ${response.data} ");
        GetAllUsersResponse allUsersResponse = GetAllUsersResponse.fromJson(
          response.data,
        );
        Log.d("Length of users is ${allUsersResponse.content?.length}");

        List<SuperAdminAllUsers> totalTeachers =
            (allUsersResponse.content ?? [])
                .where((user) => user.role.isTeacher)
                .map((user) => SuperAdminAllUsers.fromContent(user))
                .toList();

        List<SuperAdminAllUsers> totalStudents =
            (allUsersResponse.content ?? [])
                .where((user) => user.role.isStudent)
                .map((user) => SuperAdminAllUsers.fromContent(user))
                .toList();

        List<SuperAdminAllUsers> totalOther = (allUsersResponse.content ?? [])
            .where((user) => user.role.isStudent)
            .map((user) => SuperAdminAllUsers.fromContent(user))
            .toList();

        emit(
          state.copyWith(
            state: state.success,
            allUsersResponse: allUsersResponse,
            totalTeachers: totalTeachers,
            totalStudents: totalStudents,
            totalOthers: totalOther,
          ),
        );
      },
      dioError: (DioException error) {
        Log.d("Error in calling super admin dashboard api ${error.response}");
        emit(
          state.copyWith(
            state: state.failed,
            error: error.response?.statusCode.message,
          ),
        );
      },
      error: (error) {
        Log.d("Error in calling super admin dashboard api $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }
}
