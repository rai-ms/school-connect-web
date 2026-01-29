class CreateParentRequest {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String parentType;
  final String? gender;
  final String? dateOfBirth;
  final String email;
  final String phone;
  final String? alternatePhone;
  final String? workPhone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? occupation;
  final String? employer;
  final String? educationLevel;
  final String? relationshipToStudent;
  final bool? isPrimaryContact;
  final bool? isEmergencyContact;
  final bool? canPickupChild;
  final bool createUserAccount;

  CreateParentRequest({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.parentType,
    this.gender,
    this.dateOfBirth,
    required this.email,
    required this.phone,
    this.alternatePhone,
    this.workPhone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.occupation,
    this.employer,
    this.educationLevel,
    this.relationshipToStudent,
    this.isPrimaryContact,
    this.isEmergencyContact,
    this.canPickupChild,
    this.createUserAccount = false,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        if (middleName != null) 'middleName': middleName,
        'lastName': lastName,
        'parentType': parentType,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        'email': email,
        'phone': phone,
        if (alternatePhone != null) 'alternatePhone': alternatePhone,
        if (workPhone != null) 'workPhone': workPhone,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (postalCode != null) 'postalCode': postalCode,
        if (occupation != null) 'occupation': occupation,
        if (employer != null) 'employer': employer,
        if (educationLevel != null) 'educationLevel': educationLevel,
        if (relationshipToStudent != null)
          'relationshipToStudent': relationshipToStudent,
        if (isPrimaryContact != null) 'isPrimaryContact': isPrimaryContact,
        if (isEmergencyContact != null)
          'isEmergencyContact': isEmergencyContact,
        if (canPickupChild != null) 'canPickupChild': canPickupChild,
        'createUserAccount': createUserAccount,
      };
}

class ParentResponse {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String fullName;
  final String parentType;
  final String? gender;
  final String? dateOfBirth;
  final String email;
  final String? phone;
  final String? alternatePhone;
  final String? workPhone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? occupation;
  final String? employer;
  final String? workAddress;
  final String? annualIncome;
  final String? educationLevel;
  final String? relationshipToStudent;
  final bool isPrimaryContact;
  final bool isEmergencyContact;
  final bool canPickupChild;
  final String? preferredLanguage;
  final String status;
  final bool portalAccessEnabled;
  final String? photoUrl;
  final String? notes;
  final String? specialInstructions;
  final List<LinkedStudentInfo> linkedStudents;

  ParentResponse({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.fullName,
    required this.parentType,
    this.gender,
    this.dateOfBirth,
    required this.email,
    this.phone,
    this.alternatePhone,
    this.workPhone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.occupation,
    this.employer,
    this.workAddress,
    this.annualIncome,
    this.educationLevel,
    this.relationshipToStudent,
    this.isPrimaryContact = false,
    this.isEmergencyContact = false,
    this.canPickupChild = true,
    this.preferredLanguage,
    this.status = 'ACTIVE',
    this.portalAccessEnabled = true,
    this.photoUrl,
    this.notes,
    this.specialInstructions,
    this.linkedStudents = const [],
  });

  factory ParentResponse.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] ?? '';
    final lastName = json['lastName'] ?? '';
    return ParentResponse(
      id: json['id']?.toString() ?? '',
      firstName: firstName,
      middleName: json['middleName'],
      lastName: lastName,
      fullName: json['fullName'] ?? '$firstName $lastName'.trim(),
      parentType: json['parentType'] ?? 'FATHER',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      email: json['email'] ?? '',
      phone: json['phone'],
      alternatePhone: json['alternatePhone'],
      workPhone: json['workPhone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      occupation: json['occupation'],
      employer: json['employer'],
      workAddress: json['workAddress'],
      annualIncome: json['annualIncome'],
      educationLevel: json['educationLevel'],
      relationshipToStudent: json['relationshipToStudent'],
      isPrimaryContact: json['isPrimaryContact'] ?? false,
      isEmergencyContact: json['isEmergencyContact'] ?? false,
      canPickupChild: json['canPickupChild'] ?? true,
      preferredLanguage: json['preferredLanguage'],
      status: json['status'] ?? 'ACTIVE',
      portalAccessEnabled: json['portalAccessEnabled'] ?? true,
      photoUrl: json['photoUrl'],
      notes: json['notes'],
      specialInstructions: json['specialInstructions'],
      linkedStudents: (json['linkedStudents'] as List?)
              ?.map((e) =>
                  LinkedStudentInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isActive => status == 'ACTIVE';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();

  String get parentTypeDisplay {
    switch (parentType) {
      case 'FATHER':
        return 'Father';
      case 'MOTHER':
        return 'Mother';
      case 'GUARDIAN':
        return 'Guardian';
      case 'GRANDFATHER':
        return 'Grandfather';
      case 'GRANDMOTHER':
        return 'Grandmother';
      case 'UNCLE':
        return 'Uncle';
      case 'AUNT':
        return 'Aunt';
      case 'BROTHER':
        return 'Brother';
      case 'SISTER':
        return 'Sister';
      default:
        return 'Other';
    }
  }
}

class LinkedStudentInfo {
  final String id;
  final String fullName;
  final String? rollNumber;
  final String? currentClassId;
  final String? relationship;

  LinkedStudentInfo({
    required this.id,
    required this.fullName,
    this.rollNumber,
    this.currentClassId,
    this.relationship,
  });

  factory LinkedStudentInfo.fromJson(Map<String, dynamic> json) {
    return LinkedStudentInfo(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      rollNumber: json['rollNumber'],
      currentClassId: json['currentClassId'],
      relationship: json['relationship'],
    );
  }
}
