import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;

import 'injector.config.dart';

// fvm dart run build_runner build --delete-conflicting-outputs

final GetIt _inject = GetIt.instance;

@InjectableInit(
  initializerName: 'injectAllData',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> _configureInjection() => injectAllData(_inject, environment: "dev");

class InjectorService extends BaseService<Future<void>, void> {
  static final InjectorService service = InjectorService._();

  InjectorService._();

  GetIt get inject => _inject;

  @override
  Future<void> init({void param}) async {
    await _configureInjection();
  }
}
