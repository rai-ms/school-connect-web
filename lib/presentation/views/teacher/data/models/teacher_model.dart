class CreateTeacherRequest {
  final String employeeId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String phone;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String joiningDate;
  final String employeeType;
  final String? department;
  final String designation;
  final List<String>? subjects;
  final String? highestQualification;
  final int? experienceYears;
  final bool createUserAccount;

  CreateTeacherRequest({
    required this.employeeId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    required this.joiningDate,
    this.employeeType = 'PERMANENT',
    this.department,
    required this.designation,
    this.subjects,
    this.highestQualification,
    this.experienceYears,
    this.createUserAccount = true,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'firstName': firstName,
        if (middleName != null) 'middleName': middleName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'email': email,
        'phone': phone,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (postalCode != null) 'postalCode': postalCode,
        'joiningDate': joiningDate,
        'employeeType': employeeType,
        if (department != null) 'department': department,
        'designation': designation,
        if (subjects != null) 'subjects': subjects,
        if (highestQualification != null)
          'highestQualification': highestQualification,
        if (experienceYears != null) 'experienceYears': experienceYears,
        'createUserAccount': createUserAccount,
      };
}

class TeacherResponse {
  final String id;
  final String employeeId;
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
  final String? joiningDate;
  final String? employeeType;
  final String? department;
  final String? designation;
  final List<String> subjects;
  final List<String> classes;
  final bool isClassTeacher;
  final String? classTeacherFor;
  final String? highestQualification;
  final int? experienceYears;
  final String status;
  final String? photoUrl;
  final double? rating;

  TeacherResponse({
    required this.id,
    required this.employeeId,
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
    this.joiningDate,
    this.employeeType,
    this.department,
    this.designation,
    this.subjects = const [],
    this.classes = const [],
    this.isClassTeacher = false,
    this.classTeacherFor,
    this.highestQualification,
    this.experienceYears,
    this.status = 'ACTIVE',
    this.photoUrl,
    this.rating,
  });

  factory TeacherResponse.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    return TeacherResponse(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId'] ?? '',
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
      joiningDate: json['joiningDate'],
      employeeType: json['employeeType'],
      department: json['department'],
      designation: json['designation'],
      subjects: (json['subjects'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      classes: (json['classes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isClassTeacher: json['isClassTeacher'] ?? false,
      classTeacherFor: json['classTeacherFor'],
      highestQualification: json['highestQualification'],
      experienceYears: json['experienceYears'],
      status: json['status'] ?? 'ACTIVE',
      photoUrl: json['photoUrl'],
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  bool get isActive => status == 'ACTIVE';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();
}
