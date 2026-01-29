

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/controller_base/widget_view_base.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/toast.dart' show toast;
import 'package:student_management/generated/generated_images.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/parent_dashboard.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/school_admin/school_admin_dashboard.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/student/student_dashboard.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/super_admin/super_admin_dashboard.dart';
import 'package:student_management/presentation/widgets/animated_loader/app_pull_to_refresh.dart';
import '../../../../../widgets/animated_loader/app_loader.dart';
import '../../../domain/entities/user_role.dart';
import '../../widgets/teacher/teacher_dashboard.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';

part '../ui/dashboard_widget_view.dart';
part 'mixins/dashboard_controller_mixin.dart';

class DashboardController extends StatefulWidget {
  const DashboardController({super.key});

  @override
  State<DashboardController> createState() => _DashboardControllerState();
}

class _DashboardControllerState extends State<DashboardController>
    with _DashBoardControllerMixin<DashboardController>{


  @override
  Widget build(BuildContext context) => _DashBoardWidgetView(this);
}
