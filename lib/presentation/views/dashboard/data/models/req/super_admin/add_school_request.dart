class AddSchoolRequest {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String subdomain;
  final String subscriptionPlan;
  final String? website;
  final Map<String, dynamic>? configuration;
  final bool createDefaultClasses;
  final AdminUser adminUser;

  AddSchoolRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.subdomain,
    required this.subscriptionPlan,
    this.website,
    this.configuration,
    this.createDefaultClasses = false,
    required this.adminUser,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
        'subdomain': subdomain,
        'subscriptionPlan': subscriptionPlan,
        if (website != null) 'website': website,
        if (configuration != null) 'configuration': configuration,
        'createDefaultClasses': createDefaultClasses,
        'adminUser': adminUser.toJson(),
      };
}

class AdminUser {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String userId;
  final String username;
  final String phone;

  AdminUser({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.userId,
    required this.username,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'userId': userId,
        'username': username,
        'phone': phone,
      };
}
