import 'package:student_management/core/base/logger/app_logger_impl.dart';

enum LogMode { debug, live }

enum AppTheme {
  system("system"),
  dark("dark"),
  light("light");

  final String value;

  const AppTheme(this.value);

  static AppTheme getTheme(String? theme) {
    if (theme == null || theme.isEmpty) return AppTheme.system;
    try {
      return AppTheme.values.firstWhere((element) => element.value == theme);
    } catch (e) {
      return AppTheme.system;
    }
  }

  String getThemeVal() {
    return value;
  }

  @override
  String toString() {
    return value;
  }
}

enum ModelType { list, grid }

enum ImageType { memory, asset, link, svg, file, lottie }

enum RequestResource { camera, storage, microphone }

enum ToastType { success, error }

enum FlavourType {
  prod('PROD'),
  uat('STAGING'),
  dev('DEV'),
  unknown(null);

  final String? _flavour;

  const FlavourType(this._flavour);

  static FlavourType fromString({String? val}) {
    if (val == null || val.isEmpty) return FlavourType.dev;
    Log.d("Flavour Type $val");
    try {
      var fl = FlavourType.values.firstWhere(
        (FlavourType element) => element._flavour == val,
        orElse: () => FlavourType.dev,
      );
      Log.d("FlavourType is ${fl._flavour}");
      return fl;
    } catch (e) {
      Log.e("Error while getting flavour type $e");
      return FlavourType.dev;
    }
  }

  @override
  String toString() {
    return _flavour ?? "unknown";
  }
}

enum TextInputFieldType {
  email,
  password,
  name,
  otp,
  none;

  bool get isEmail => this == email;

  bool get isPhone => this == password;

  bool get isName => this == name;

  bool get isOtp => this == otp;

  bool get isNone => this == none;

  String? get errorMessage => switch (this) {
    TextInputFieldType.email => "Invalid email format",
    TextInputFieldType.password => "Invalid password format",
    TextInputFieldType.name => "",
    TextInputFieldType.otp => "",
    TextInputFieldType.none => null,
  };
}

enum LoginType {
  email,
  phone;

  bool get isEmail => this == LoginType.email;
  bool get isPhone => this == LoginType.phone;
}

enum AppLanguage {
  english("en", "English"),
  hindi("hi", "हिन्दी"),
  bhojpuri("es", "भोजपुरी"),
  urdu("ur", "اردو");

  final String code;
  final String language;

  const AppLanguage(this.code, this.language);

  /// Converts a string to an AppLanguage enum value.
  /// Returns [AppLanguage.english] if the string is null, empty, or does not match any defined language.
  factory AppLanguage.fromString(String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) {
      return AppLanguage.english;
    }
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => AppLanguage.english,
    );
  }
}

enum ArrowDirection {
  right,
  left,
  top,
  down;

  bool get isRight => this == ArrowDirection.right;
  bool get isLeft => this == ArrowDirection.left;
  bool get isTop => this == ArrowDirection.top;
  bool get isDown => this == ArrowDirection.down;

  bool get isSH => this == ArrowDirection.right || this == ArrowDirection.left;
  bool get isSW => this == ArrowDirection.top || this == ArrowDirection.down;
}
