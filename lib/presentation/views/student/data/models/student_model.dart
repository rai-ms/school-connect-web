class CreateStudentRequest {
  final String rollNumber;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String currentClassId;
  final String currentSectionId;
  final String admissionDate;
  final String? previousSchool;
  final Map<String, String>? fatherInfo;
  final Map<String, String>? motherInfo;
  final Map<String, String>? guardianInfo;
  final Map<String, String>? emergencyContact;
  final bool createUserAccount;

  CreateStudentRequest({
    required this.rollNumber,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    required this.currentClassId,
    required this.currentSectionId,
    required this.admissionDate,
    this.previousSchool,
    this.fatherInfo,
    this.motherInfo,
    this.guardianInfo,
    this.emergencyContact,
    this.createUserAccount = false,
  });

  Map<String, dynamic> toJson() => {
        'rollNumber': rollNumber,
        'firstName': firstName,
        if (middleName != null) 'middleName': middleName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (postalCode != null) 'postalCode': postalCode,
        'currentClassId': currentClassId,
        'currentSectionId': currentSectionId,
        'admissionDate': admissionDate,
        if (previousSchool != null) 'previousSchool': previousSchool,
        if (fatherInfo != null) 'fatherInfo': fatherInfo,
        if (motherInfo != null) 'motherInfo': motherInfo,
        if (guardianInfo != null) 'guardianInfo': guardianInfo,
        if (emergencyContact != null) 'emergencyContact': emergencyContact,
        'createUserAccount': createUserAccount,
      };
}

class StudentResponse {
  final String id;
  final String rollNumber;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String fullName;
  final String? dateOfBirth;
  final String gender;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? currentClassId;
  final String? currentSectionId;
  final String? admissionDate;
  final String status;
  final String? photoUrl;
  final Map<String, dynamic>? fatherInfo;
  final Map<String, dynamic>? motherInfo;
  final Map<String, dynamic>? guardianInfo;
  final Map<String, dynamic>? emergencyContact;

  StudentResponse({
    required this.id,
    required this.rollNumber,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.fullName,
    this.dateOfBirth,
    required this.gender,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.currentClassId,
    this.currentSectionId,
    this.admissionDate,
    this.status = 'ACTIVE',
    this.photoUrl,
    this.fatherInfo,
    this.motherInfo,
    this.guardianInfo,
    this.emergencyContact,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    return StudentResponse(
      id: json['id']?.toString() ?? '',
      rollNumber: json['rollNumber'] ?? '',
      firstName: firstName,
      middleName: json['middleName'],
      lastName: lastName,
      fullName: json['fullName'] ?? '$firstName $lastName'.trim(),
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      currentClassId: json['currentClassId']?.toString(),
      currentSectionId: json['currentSectionId']?.toString(),
      admissionDate: json['admissionDate'],
      status: json['status'] ?? 'ACTIVE',
      photoUrl: json['photoUrl'],
      fatherInfo: json['fatherInfo'] is Map
          ? Map<String, dynamic>.from(json['fatherInfo'])
          : null,
      motherInfo: json['motherInfo'] is Map
          ? Map<String, dynamic>.from(json['motherInfo'])
          : null,
      guardianInfo: json['guardianInfo'] is Map
          ? Map<String, dynamic>.from(json['guardianInfo'])
          : null,
      emergencyContact: json['emergencyContact'] is Map
          ? Map<String, dynamic>.from(json['emergencyContact'])
          : null,
    );
  }

  bool get isActive => status == 'ACTIVE';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();
}

class StudentStatistics {
  final int totalStudents;
  final int activeStudents;
  final int inactiveStudents;
  final Map<String, int> byClass;
  final Map<String, int> byGender;

  StudentStatistics({
    this.totalStudents = 0,
    this.activeStudents = 0,
    this.inactiveStudents = 0,
    this.byClass = const {},
    this.byGender = const {},
  });

  factory StudentStatistics.fromJson(Map<String, dynamic> json) {
    return StudentStatistics(
      totalStudents: json['totalStudents'] ?? 0,
      activeStudents: json['activeStudents'] ?? 0,
      inactiveStudents: json['inactiveStudents'] ?? 0,
      byClass: json['byClass'] is Map
          ? Map<String, int>.from(json['byClass'])
          : {},
      byGender: json['byGender'] is Map
          ? Map<String, int>.from(json['byGender'])
          : {},
    );
  }
}

class BulkImportResult {
  final int totalRows;
  final int successCount;
  final int errorCount;
  final List<ImportError> errors;

  BulkImportResult({
    this.totalRows = 0,
    this.successCount = 0,
    this.errorCount = 0,
    this.errors = const [],
  });

  factory BulkImportResult.fromJson(Map<String, dynamic> json) {
    return BulkImportResult(
      totalRows: json['totalRows'] ?? 0,
      successCount: json['successCount'] ?? 0,
      errorCount: json['errorCount'] ?? 0,
      errors: json['errors'] is List
          ? (json['errors'] as List)
              .map((e) => ImportError.fromJson(e))
              .toList()
          : [],
    );
  }
}

class ImportError {
  final int rowNumber;
  final String fieldName;
  final String errorMessage;
  final String? rawValue;

  ImportError({
    required this.rowNumber,
    required this.fieldName,
    required this.errorMessage,
    this.rawValue,
  });

  factory ImportError.fromJson(Map<String, dynamic> json) {
    return ImportError(
      rowNumber: json['rowNumber'] ?? 0,
      fieldName: json['fieldName'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
      rawValue: json['rawValue'],
    );
  }
}
