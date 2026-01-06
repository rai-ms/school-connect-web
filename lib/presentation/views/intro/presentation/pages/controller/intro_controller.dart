

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/controller_base/widget_view_base.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/views/splash/presentation/manager/splash_bloc/splash_bloc.dart';
import 'package:student_management/presentation/widgets/animations/text_animation/typing_text.dart';
import 'package:student_management/presentation/widgets/customs/custom_button.dart';

import '../../../../../../generated/generated_images.dart';

part '../ui/intro_widget_view.dart';

class IntroController extends StatefulWidget {
  const IntroController({super.key});

  @override
  State<IntroController> createState() => _IntroControllerState();
}

class _IntroControllerState extends State<IntroController> {
  @override
  Widget build(BuildContext context) => _IntroWidgetView(this);
}
