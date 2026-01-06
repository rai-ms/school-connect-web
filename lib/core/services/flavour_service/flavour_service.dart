import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/no_param.dart';
import 'package:student_management/core/base/base_service/base_service.dart';
import 'package:student_management/core/base/flavour_base/flavour.dart';
import 'package:student_management/core/utils/app_enum.dart';
import 'package:student_management/core/utils/env_reader.dart';

import '../../base/logger/app_logger_impl.dart';

@singleton
@protected
class FlavourService extends BaseService<Future<void>, NoParam> {
  FlavourService();

  late final Flavour flavour;

  @postConstruct
  @override
  Future<void> init({NoParam? param}) async {
    var appEnvironment = await EnvReader.load();
    var filePath = appEnvironment.get("FLAVOUR");
    FlavourType type = FlavourType.fromString(val: filePath);
    flavour = await getFlavour(type);
    Log.d(
      "Flavour is ${flavour.runtimeType} and base Url is ${flavour.baseUrl}",
    );
    return;
  }

  String pickFile(FlavourType type) {
    switch (type) {
      case FlavourType.prod:
        return "assets/env/.env.prod";
      case FlavourType.uat:
        return "assets/env/.env.dev";
      case FlavourType.dev:
        return "assets/env/.env.dev";
      case FlavourType.unknown:
        return "assets/env/.env.dev";
    }
  }

  Future<Flavour> getFlavour(FlavourType type) async {
    var env = await EnvReader.load(assetPath: pickFile(type));
    return FlavourImpl(baseUrl: env.get("BASE_URL")!);
  }
}
