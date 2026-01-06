import 'package:flutter/material.dart';
import 'package:student_management/core/services/route_service/app_routing.dart'
    show RouteService;
import 'package:student_management/core/utils/app_extension.dart';
import 'package:student_management/generated/l10n/s.dart';

BuildContext get ctx => RouteService.navigatorKey.currentState!.context;

double deviceHeight = MediaQuery.of(ctx).size.height;
double deviceWidth = MediaQuery.of(ctx).size.width;

S? get L => ctx.L;
