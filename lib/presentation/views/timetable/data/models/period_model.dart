class PeriodRequest {
  final int periodNumber;
  final String name;
  final String startTime;
  final String endTime;
  final bool? isBreak;
  final bool? isActive;

  PeriodRequest({
    required this.periodNumber,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.isBreak,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'periodNumber': periodNumber,
        'name': name,
        'startTime': startTime,
        'endTime': endTime,
        if (isBreak != null) 'isBreak': isBreak,
        if (isActive != null) 'isActive': isActive,
      };
}

class PeriodResponse {
  final String id;
  final int periodNumber;
  final String name;
  final String startTime;
  final String endTime;
  final bool isBreak;
  final bool isActive;

  PeriodResponse({
    required this.id,
    required this.periodNumber,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.isBreak = false,
    this.isActive = true,
  });

  factory PeriodResponse.fromJson(Map<String, dynamic> json) {
    return PeriodResponse(
      id: json['id'] ?? '',
      periodNumber: json['periodNumber'] ?? 0,
      name: json['name'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isBreak: json['isBreak'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  String get timeRange => '$startTime - $endTime';
}
