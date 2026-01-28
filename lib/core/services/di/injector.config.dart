// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../presentation/my_app/data/repo/app_config_repo_impl.dart'
    as _i1013;
import '../../../presentation/my_app/domain/repo/app_config_repo.dart'
    as _i1045;
import '../../../presentation/my_app/domain/use_case/get_app_config_use_case.dart'
    as _i331;
import '../../../presentation/my_app/domain/use_case/secure_storage_use_case.dart'
    as _i822;
import '../../../presentation/my_app/presentation/manager/bloc/app_config_bloc/app_config_bloc.dart'
    as _i940;
import '../../../presentation/views/dashboard/data/repositories/profile_repo_impl.dart'
    as _i245;
import '../../../presentation/views/dashboard/data/repositories/super_admin/add_school_repository_impl.dart'
    as _i1063;
import '../../../presentation/views/dashboard/data/repositories/super_admin/super_admin_repo_impl.dart'
    as _i220;
import '../../../presentation/views/dashboard/domain/repositories/profile_repo.dart'
    as _i265;
import '../../../presentation/views/dashboard/domain/repositories/super_admin/add_school_repository.dart'
    as _i820;
import '../../../presentation/views/dashboard/domain/repositories/super_admin/super_admin_repo.dart'
    as _i75;
import '../../../presentation/views/dashboard/domain/use_cases/profile_fetch_use_case.dart'
    as _i813;
import '../../../presentation/views/dashboard/domain/use_cases/super_admin/add_school.dart'
    as _i210;
import '../../../presentation/views/dashboard/domain/use_cases/super_admin/fetch_super_admin_dashboard.dart'
    as _i106;
import '../../../presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart'
    as _i292;
import '../../../presentation/views/dashboard/presentation/widgets/super_admin/bloc/add_school_bloc/add_school_bloc.dart'
    as _i542;
import '../../../presentation/views/dashboard/presentation/widgets/super_admin/bloc/dashboard_bloc/super_admin_bloc.dart'
    as _i394;
import '../../../presentation/views/login/data/repositories/login_repository_impl.dart'
    as _i410;
import '../../../presentation/views/login/domain/repositories/login_repository.dart'
    as _i677;
import '../../../presentation/views/login/presentation/manager/login_bloc/login_bloc.dart'
    as _i914;
import '../../../presentation/views/splash/domain/use_cases/add_use_case.dart'
    as _i822;
import '../../../presentation/views/splash/presentation/manager/splash_bloc/splash_bloc.dart'
    as _i1048;
import '../../handler/api_request_handler.dart' as _i564;
import '../../handler/state_request_handler.dart' as _i140;
import '../api_service/api_dispatcher.dart' as _i896;
import '../api_service/api_service.dart' as _i317;
import '../deep_link_service/deep_link_service.dart' as _i274;
import '../flavour_service/flavour_service.dart' as _i279;
import '../language_service/language_service.dart' as _i908;
import '../notification/notification_service.dart' as _i85;
import '../permissin_service/permission_service.dart' as _i49;
import '../storage_service/hive_storage/hive_strategy.dart' as _i1039;
import '../storage_service/memory_strategy/memory_strategy.dart' as _i413;
import '../storage_service/no_op_strategy/no_op_strategy.dart' as _i158;
import '../storage_service/secure_storage/secure_storage_strategy.dart'
    as _i213;
import '../storage_service/secure_storage_service.dart' as _i643;
import '../storage_service/storage_contract/storage_contract.dart' as _i738;
import '../storage_service/storage_repo/app_storage_repo.dart' as _i122;
import '../storage_service/storage_repo/auth_storage_repo.dart' as _i708;
import '../storage_service/storage_repository.dart' as _i1048;
import '../theme_service/theme_service.dart' as _i674;
import '../token_service/token_manager.dart' as _i52;

const String _dev = 'dev';

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> injectAllData(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i140.StateRequestHandler>(() => _i140.StateRequestHandler());
  gh.singleton<_i564.ApiHandler>(() => const _i564.ApiHandler());
  gh.singleton<_i158.NoOpStorageStrategy>(
      () => const _i158.NoOpStorageStrategy());
  gh.singleton<_i49.PermissionService>(() => _i49.PermissionService());
  gh.singleton<_i317.ApiService>(() => const _i317.ApiService());
  gh.singletonAsync<_i279.FlavourService>(() {
    final i = _i279.FlavourService();
    return i.init().then((_) => i);
  });
  gh.lazySingleton<_i274.DeepLinkService>(() => _i274.DeepLinkService());
  gh.lazySingleton<_i643.SecureStorageService>(
      () => _i643.SecureStorageService());
  gh.lazySingleton<_i822.AddUseCases>(() => _i822.AddUseCases());
  gh.singletonAsync<_i738.StorageStrategy>(
    () {
      final i = _i1039.HiveStorageStrategy();
      return i.init().then((_) => i);
    },
    instanceName: 'hive_storage',
  );
  gh.singletonAsync<_i122.AppStorageRepository>(() async =>
      _i122.AppStorageRepository(await gh.getAsync<_i738.StorageStrategy>(
          instanceName: 'hive_storage')));
  await gh.singletonAsync<_i738.StorageStrategy>(
    () {
      final i = _i213.SecureStorageStrategy();
      return i.init().then((_) => i);
    },
    instanceName: 'secure_storage',
    preResolve: true,
  );
  gh.lazySingletonAsync<_i1048.StorageRepository>(() async =>
      _i1048.StorageRepository(await gh.getAsync<_i738.StorageStrategy>(
          instanceName: 'hive_storage')));
  gh.singleton<_i413.MemoryStorageStrategy>(
    () => _i413.MemoryStorageStrategy(),
    instanceName: 'memory_storage',
  );
  gh.lazySingleton<_i896.ApiDispatcher>(
      () => _i896.ApiDispatcher(gh<_i317.ApiService>()));
  gh.lazySingleton<_i52.TokenManager>(
      () => _i52.TokenManager(gh<_i643.SecureStorageService>()));
  gh.lazySingleton<_i85.NotificationService>(
      () => _i85.NotificationService(gh<_i274.DeepLinkService>()));
  gh.lazySingleton<_i265.ProfileRepo>(
      () => _i245.ProfileRepoImpl(gh<_i896.ApiDispatcher>()));
  gh.singleton<_i708.AuthStorageRepository>(() => _i708.AuthStorageRepository(
      gh<_i738.StorageStrategy>(instanceName: 'secure_storage')));
  gh.singleton<_i822.SecureStorageUseCase>(() => _i822.SecureStorageUseCase(
      gh<_i738.StorageStrategy>(instanceName: 'secure_storage')));
  gh.singletonAsync<_i908.AppLanguageService>(() async =>
      _i908.AppLanguageService(await gh.getAsync<_i122.AppStorageRepository>())
        ..init());
  gh.singletonAsync<_i674.ThemeService>(() async =>
      _i674.ThemeService(await gh.getAsync<_i1048.StorageRepository>())
        ..init());
  gh.lazySingleton<_i677.LoginRepository>(
      () => _i410.LoginRepositoryImpl(gh<_i896.ApiDispatcher>()));
  gh.lazySingleton<_i1045.AppConfigRepo>(
      () => _i1013.AppConfigRepoImpl(gh<_i896.ApiDispatcher>()));
  gh.singleton<_i75.SuperAdminDashboardRepo>(
      () => _i220.SuperAdminDashboardRepoImpl(
            gh<_i896.ApiDispatcher>(),
            gh<_i708.AuthStorageRepository>(),
          ));
  gh.singletonAsync<_i1048.SplashBloc>(() async => _i1048.SplashBloc(
        gh<_i140.StateRequestHandler>(),
        gh<_i708.AuthStorageRepository>(),
        await gh.getAsync<_i122.AppStorageRepository>(),
      ));
  gh.lazySingleton<_i820.AddSchoolRepository>(
      () => _i1063.AddSchoolRepositoryImpl(
            gh<_i896.ApiDispatcher>(),
            gh<_i708.AuthStorageRepository>(),
          ));
  gh.lazySingleton<_i813.ProfileFetchUseCase>(
    () => _i813.ProfileFetchUseCase(gh<_i265.ProfileRepo>()),
    registerFor: {_dev},
  );
  gh.factory<_i914.LoginBloc>(() => _i914.LoginBloc(
        gh<_i140.StateRequestHandler>(),
        gh<_i677.LoginRepository>(),
        gh<_i708.AuthStorageRepository>(),
      ));
  gh.factory<_i292.ProfileManageBloc>(() => _i292.ProfileManageBloc(
        gh<_i140.StateRequestHandler>(),
        gh<_i708.AuthStorageRepository>(),
        gh<_i813.ProfileFetchUseCase>(),
      ));
  gh.singleton<_i210.AddSchool>(
      () => _i210.AddSchool(gh<_i820.AddSchoolRepository>()));
  gh.lazySingleton<_i331.FetchAppConfigUseCase>(
      () => _i331.FetchAppConfigUseCase(gh<_i1045.AppConfigRepo>()));
  gh.factory<_i542.AddSchoolBloc>(() => _i542.AddSchoolBloc(
        gh<_i210.AddSchool>(),
        gh<_i140.StateRequestHandler>(),
      ));
  gh.singleton<_i106.FetchSuperAdminDashboard>(
      () => _i106.FetchSuperAdminDashboard(gh<_i75.SuperAdminDashboardRepo>()));
  gh.factory<_i940.AppConfigBloc>(() => _i940.AppConfigBloc(
        gh<_i331.FetchAppConfigUseCase>(),
        gh<_i140.StateRequestHandler>(),
      ));
  gh.factory<_i394.SuperAdminDashboardBloc>(() => _i394.SuperAdminDashboardBloc(
        gh<_i140.StateRequestHandler>(),
        gh<_i106.FetchSuperAdminDashboard>(),
      ));
  return getIt;
}
