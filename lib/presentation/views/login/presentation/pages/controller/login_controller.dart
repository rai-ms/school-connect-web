import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/controller_base/widget_view_base.dart';
import 'package:student_management/core/services/analytics/firebase_analytics_service.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/core/services/theme_service/theme_service.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_enum.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/input_validator.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/views/login/presentation/manager/login_bloc/login_bloc.dart';
import 'package:student_management/presentation/widgets/customs/app_text_field.dart';
import 'package:student_management/presentation/widgets/customs/custom_button.dart';
import 'package:student_management/presentation/widgets/customs/silver_validation/silver_validation.dart';
import 'package:student_management/presentation/widgets/gradient/gradient_text.dart';

import '../../../../../../core/base/logger/app_logger_impl.dart';
import '../../../../../../core/services/di/injector.dart';
import '../../../../../../generated/generated_images.dart';
import '../../../../../widgets/customs/toast.dart';
import '../../../domain/entities/login_event.dart';

part '../ui/login_widget_view.dart';
part 'login_controller_mixin.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController>
    with _LoginControllerMixin<LoginController> {
  @override
  Widget build(BuildContext context) => _LoginWidgetView(this);
}
