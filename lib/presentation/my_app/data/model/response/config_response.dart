import 'dart:convert';

class ConfigResponse {
  final String? version;
  final DateTime? lastUpdated;
  final Features? features;
  final Ui? ui;
  final Runtime? runtime;

  ConfigResponse({
    this.version,
    this.lastUpdated,
    this.features,
    this.ui,
    this.runtime,
  });

  ConfigResponse copyWith({
    String? version,
    DateTime? lastUpdated,
    Features? features,
    Ui? ui,
    Runtime? runtime,
  }) =>
      ConfigResponse(
        version: version ?? this.version,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        features: features ?? this.features,
        ui: ui ?? this.ui,
        runtime: runtime ?? this.runtime,
      );

  factory ConfigResponse.fromRawJson(String str) => ConfigResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConfigResponse.fromJson(Map<String, dynamic> json) => ConfigResponse(
    version: json["version"],
    lastUpdated: json["lastUpdated"] == null ? null : DateTime.parse(json["lastUpdated"]),
    features: json["features"] == null ? null : Features.fromJson(json["features"]),
    ui: json["ui"] == null ? null : Ui.fromJson(json["ui"]),
    runtime: json["runtime"] == null ? null : Runtime.fromJson(json["runtime"]),
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "lastUpdated": lastUpdated?.toIso8601String(),
    "features": features?.toJson(),
    "ui": ui?.toJson(),
    "runtime": runtime?.toJson(),
  };
}

class Features {
  final bool? editProfile;

  Features({
    this.editProfile,
  });

  Features copyWith({
    bool? editProfile,
  }) =>
      Features(
        editProfile: editProfile ?? this.editProfile,
      );

  factory Features.fromRawJson(String str) => Features.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Features.fromJson(Map<String, dynamic> json) => Features(
    editProfile: json["editProfile"],
  );

  Map<String, dynamic> toJson() => {
    "editProfile": editProfile,
  };
}

class Runtime {
  final bool? isEnable;

  Runtime({
    this.isEnable,
  });

  Runtime copyWith({
    bool? isEnable,
  }) =>
      Runtime(
        isEnable: isEnable ?? this.isEnable,
      );

  factory Runtime.fromRawJson(String str) => Runtime.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Runtime.fromJson(Map<String, dynamic> json) => Runtime(
    isEnable: json["isEnable"],
  );

  Map<String, dynamic> toJson() => {
    "isEnable": isEnable,
  };
}

class Ui {
  final List<AvailableLanguage>? availableLanguage;

  Ui({
    this.availableLanguage,
  });

  Ui copyWith({
    List<AvailableLanguage>? availableLanguage,
  }) =>
      Ui(
        availableLanguage: availableLanguage ?? this.availableLanguage,
      );

  factory Ui.fromRawJson(String str) => Ui.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ui.fromJson(Map<String, dynamic> json) => Ui(
    availableLanguage: json["availableLanguage"] == null ? [] : List<AvailableLanguage>.from(json["availableLanguage"]!.map((x) => AvailableLanguage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "availableLanguage": availableLanguage == null ? [] : List<dynamic>.from(availableLanguage!.map((x) => x.toJson())),
  };
}

class AvailableLanguage {
  final String? langCode;
  final String? langName;

  AvailableLanguage({
    this.langCode,
    this.langName,
  });

  AvailableLanguage copyWith({
    String? langCode,
    String? langName,
  }) =>
      AvailableLanguage(
        langCode: langCode ?? this.langCode,
        langName: langName ?? this.langName,
      );

  factory AvailableLanguage.fromRawJson(String str) => AvailableLanguage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableLanguage.fromJson(Map<String, dynamic> json) => AvailableLanguage(
    langCode: json["langCode"],
    langName: json["langName"],
  );

  Map<String, dynamic> toJson() => {
    "langCode": langCode,
    "langName": langName,
  };
}
