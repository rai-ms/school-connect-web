import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/controller_base/widget_view_base.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/services/theme_service/theme_service.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_enum.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/generated/generated_images.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/super_admin/add_school_request.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/super_admin/bloc/add_school_bloc/add_school_bloc.dart';
import 'package:student_management/presentation/widgets/animated_loader/app_loader.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

part '../ui/add_school_super_admin_widget_view.dart';
part 'mixins/add_school_super_admin_mixin.dart';

class AddSchoolSuperAdminController extends StatefulWidget {
  const AddSchoolSuperAdminController({super.key});

  @override
  State<AddSchoolSuperAdminController> createState() =>
      _AddSchoolSuperAdminControllerState();
}

class _AddSchoolSuperAdminControllerState
    extends State<AddSchoolSuperAdminController>
    with _AddSchoolSuperAdmin<AddSchoolSuperAdminController> {
  @override
  Widget build(BuildContext context) => _AddSchoolSuperAdminWidgetView(this);
}
