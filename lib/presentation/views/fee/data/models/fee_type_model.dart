class FeeTypeRequest {
  final String name;
  final String? description;
  final bool? isRecurring;
  final String? frequency;
  final bool? isMandatory;
  final bool? isActive;

  FeeTypeRequest({
    required this.name,
    this.description,
    this.isRecurring,
    this.frequency,
    this.isMandatory,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (isRecurring != null) 'isRecurring': isRecurring,
        if (frequency != null) 'frequency': frequency,
        if (isMandatory != null) 'isMandatory': isMandatory,
        if (isActive != null) 'isActive': isActive,
      };
}

class FeeTypeResponse {
  final String id;
  final String name;
  final String? description;
  final bool isRecurring;
  final String? frequency;
  final bool isMandatory;
  final bool isActive;
  final DateTime? createdAt;

  FeeTypeResponse({
    required this.id,
    required this.name,
    this.description,
    this.isRecurring = false,
    this.frequency,
    this.isMandatory = true,
    this.isActive = true,
    this.createdAt,
  });

  factory FeeTypeResponse.fromJson(Map<String, dynamic> json) {
    return FeeTypeResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      isRecurring: json['isRecurring'] ?? false,
      frequency: json['frequency'],
      isMandatory: json['isMandatory'] ?? true,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'isRecurring': isRecurring,
        'frequency': frequency,
        'isMandatory': isMandatory,
        'isActive': isActive,
      };
}
