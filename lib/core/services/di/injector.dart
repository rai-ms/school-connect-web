import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import 'injector.config.dart';

// fvm dart run build_runner build --delete-conflicting-outputs

final GetIt _inject = GetIt.instance;

@InjectableInit(
  initializerName: 'injectAllData',
  preferRelativeImports: true,
  asExtension: false,
)
void _configureInjection() => injectAllData(_inject, environment: "dev");

class InjectorService extends BaseService<FVoid, void> {
  static final InjectorService service = InjectorService._();

  InjectorService._();

  GetIt get inject => _inject;

  @override
  FVoid init({void param}) async {
    _configureInjection();
  }
}
