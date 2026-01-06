import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/status_message.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/super_admin/add_school_request.dart';
import 'package:student_management/presentation/views/dashboard/data/models/res/super_admin/add_school_response.dart';
import 'package:student_management/presentation/views/dashboard/domain/use_cases/super_admin/add_school.dart';

part 'add_school_event.dart';
part 'add_school_state.dart';

@injectable
class AddSchoolBloc extends Bloc<AddSchoolEvent, AddSchoolState> {
  final AddSchool _addSchoolUseCase;
  final StateRequestHandler _handler;

  AddSchoolBloc(this._addSchoolUseCase, this._handler)
    : super(const AddSchoolState()) {
    on<AddNewSchool>(_addNewSchool);
  }

  Future<void> _addNewSchool(
    AddNewSchool event,
    Emitter<AddSchoolState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        var res = await _addSchoolUseCase(params: event.request);
        Log.d("New School Added with res ${res.data}");

        AddNewSchoolResponse response = AddNewSchoolResponse.fromJson(res.data);

        Log.d(
          "Model parsed for success of add new school ${response.admin?.toJson()}",
        );

        emit(state.copyWith(data: response, state: state.success));
      },
      dioError: (dioError) {
        Log.e(
          "Error while adding new school ${dioError.response?.statusCode} ${dioError.response?.data}",
        );
        emit(
          state.copyWith(
            state: state.failed,
            error: dioError.response?.statusCode.message,
            statusCode: dioError.response?.statusCode,
          ),
        );
      },
      error: (error) {
        Log.e("Error while adding new school $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }
}
