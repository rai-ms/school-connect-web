import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;
import 'package:student_management/core/services/my_app_listener/my_app_listener.dart'
    show MyAppListener;
import 'package:student_management/core/utils/app_enum.dart' show AppLanguage;
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import 'package:student_management/generated/l10n/s.dart';

import '../../base/logger/app_logger_impl.dart';
import '../storage_service/storage_repo/app_storage_repo.dart';

/// [AppLanguageService] handles the whole language service in the app
@protected
@singleton
class AppLanguageService extends BaseService<void, String?> {
  final AppStorageRepository _appStorageRepo;
  AppLanguageService(this._appStorageRepo);

  /// [langCode] can be use to get the language code any time, any where in the app
  String langCode = 'en';

  AppLanguage lang = AppLanguage.english;

  /// [languageChange] need to assign in the my app to build the changes over the whole app
  /// Default lang code is en (i.e. English) but user can change as per their requirement
  late ValueNotifier<Locale> languageChange = ValueNotifier(const Locale('en'));

  /// NOTE: Below method must call in the my app, otherwise [Lokalise] will throws error of null
  /// [sdkToken] and [projectId] can be assign for the OTA service provided by the intl lokalise
  /// TODO(SharedPreference): It is mandatory to initialize the SharedPreference before calling [init] in [AppPreference]
  @postConstruct
  @override
  void init({String? param}) {
    // Fetching the device specific language
    AppLanguage systemLanguage = AppLanguage.fromString(
      Platform.localeName.substring(0, 2),
    );

    // Fetching language from local
    String? localLang = _appStorageRepo.lang();

    if (localLang == null) {
      Log.d("No language found in local");
      Log.d("Now looking for the support of language from device");
      List<Locale> supportLocals = S.supportedLocales;
      for (var action in supportLocals) {
        Log.d(
          "Action Lang ${action.languageCode} and System Lang $systemLanguage",
        );
        if (action.languageCode == systemLanguage.code.substring(0, 2)) {
          localLang = action.languageCode;
          Log.d("Language matched in device");
          break;
        }
      }
    }

    localLang ??= langCode;
    lang = AppLanguage.fromString(localLang);
    languageChange = ValueNotifier<Locale>(Locale(localLang));
    MyAppListener.service.addLocaleListener();
    Log.d("AppLanguageService Initialized");
  }

  /// [changeLanguage] method need to run, when require to update the language
  FVoid changeLanguage({required AppLanguage language}) async {
    List<Locale> supportLocals = S.supportedLocales;

    // Handling for wrong locale code
    if (language.code.length < 2) {
      Log.d("Not a valid language");
      return;
    }

    // Crop the locale code, if greater, below logic can be removed as per the requirement
    String localCode = language.code;
    if (localCode.length > 3) {
      localCode = language.code.substring(0, 2);
    }

    var locale = Locale(language.code);

    Log.d("Data received for changing lang ${locale.languageCode}");

    if (supportLocals.contains(locale)) {
      // Getting the Validate string for the language code
      localCode = (locale.countryCode?.isEmpty ?? false)
          ? locale.languageCode
          : locale.toString();

      // finally Changing the language here after handling the edge-cases
      languageChange.value = Locale(localCode);
      await S.delegate.load(Locale(localCode));
      MyAppListener.service.addLocaleListener();

      // Persisting the language code to local
      langCode = localCode;
      lang = language;

      // Persisting the language code in the Persistent storage
      await _appStorageRepo.lang.write(langCode);
    }
  }
}
