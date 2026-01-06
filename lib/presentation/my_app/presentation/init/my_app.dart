import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/services/my_app_listener/my_app_listener.dart'
    show MyAppListenerModel, MyAppListener;
import 'package:student_management/core/services/route_service/app_routing.dart'
    show RouteService;
import 'package:student_management/core/services/storage_service/secure_storage/secure_storage_strategy.dart';
import 'package:student_management/core/services/theme_service/theme_service.dart'
    show ThemeService;
import 'package:student_management/core/utils/app_extension.dart';
import 'package:student_management/generated/l10n/s.dart';

import '../../../../core/base/logger/app_logger_impl.dart';
import '../../../../core/services/storage_service/secure_storage/secure_storage_keys.dart';
import '../../../../core/services/storage_service/storage_repository.dart';
import '../../../../core/utils/app_type_def.dart';

part 'my_app_mixin.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with _MyAppMixin<MyApp> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(1440, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );
    return ValueListenableBuilder<MyAppListenerModel>(
      valueListenable: MyAppListener.myAppListener,
      builder: (contextLang, myAppModel, child) {
        final botToastBuilder = BotToastInit();
        return MaterialApp.router(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          title: context.L.title,
          routerDelegate: RouteService.routeService.goRouter.routerDelegate,
          routeInformationParser:
              RouteService.routeService.goRouter.routeInformationParser,
          routeInformationProvider:
              RouteService.routeService.goRouter.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          locale: Locale(myAppModel.locale),
          theme: InjectorService.service.inject<ThemeService>().getTheme(
            context,
          ),
          builder: (context, child) {
            child = botToastBuilder(context, child);
            return child;
          },
        );
      },
    );
  }
}
