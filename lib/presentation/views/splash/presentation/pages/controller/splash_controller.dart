import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/controller_base/widget_view_base.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/services/analytics/firebase_analytics_service.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/toast.dart';
import 'package:student_management/presentation/my_app/presentation/manager/bloc/app_config_bloc/app_config_bloc.dart';
import 'package:student_management/presentation/views/splash/presentation/manager/splash_bloc/splash_bloc.dart';
import '../../../../../../generated/generated_images.dart';
part '../ui/splash_widget_view.dart';
part 'splash_mixin.dart';

class SplashController extends StatefulWidget {
  const SplashController({super.key});

  @override
  State<SplashController> createState() => _SplashControllerState();
}

class _SplashControllerState extends State<SplashController> with _SplashMixin<SplashController> {


  @override
  Widget build(BuildContext context) => _SplashWidgetView(this);
}
