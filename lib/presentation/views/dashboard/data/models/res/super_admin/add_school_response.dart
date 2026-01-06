import 'dart:convert';

class AddNewSchoolResponse {
    final Tenant? tenant;
    final Admin? admin;
    final String? message;
    final String? accessUrl;
    final List<String>? nextSteps;

    AddNewSchoolResponse({
        this.tenant,
        this.admin,
        this.message,
        this.accessUrl,
        this.nextSteps,
    });

    AddNewSchoolResponse copyWith({
        Tenant? tenant,
        Admin? admin,
        String? message,
        String? accessUrl,
        List<String>? nextSteps,
    }) => 
        AddNewSchoolResponse(
            tenant: tenant ?? this.tenant,
            admin: admin ?? this.admin,
            message: message ?? this.message,
            accessUrl: accessUrl ?? this.accessUrl,
            nextSteps: nextSteps ?? this.nextSteps,
        );

    factory AddNewSchoolResponse.fromRawJson(String str) => AddNewSchoolResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AddNewSchoolResponse.fromJson(Map<String, dynamic> json) => AddNewSchoolResponse(
        tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
        admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
        message: json["message"],
        accessUrl: json["accessUrl"],
        nextSteps: json["nextSteps"] == null ? [] : List<String>.from(json["nextSteps"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "tenant": tenant?.toJson(),
        "admin": admin?.toJson(),
        "message": message,
        "accessUrl": accessUrl,
        "nextSteps": nextSteps == null ? [] : List<dynamic>.from(nextSteps!.map((x) => x)),
    };
}

class Admin {
    final String? id;
    final String? userId;
    final String? username;
    final String? email;
    final String? firstName;
    final String? lastName;
    final bool? temporaryPassword;

    Admin({
        this.id,
        this.userId,
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.temporaryPassword,
    });

    Admin copyWith({
        String? id,
        String? userId,
        String? username,
        String? email,
        String? firstName,
        String? lastName,
        bool? temporaryPassword,
    }) => 
        Admin(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            username: username ?? this.username,
            email: email ?? this.email,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            temporaryPassword: temporaryPassword ?? this.temporaryPassword,
        );

    factory Admin.fromRawJson(String str) => Admin.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["id"],
        userId: json["userId"],
        username: json["username"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        temporaryPassword: json["temporaryPassword"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "username": username,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "temporaryPassword": temporaryPassword,
    };
}

class Tenant {
    final String? id;
    final String? identifier;
    final String? name;
    final String? subdomain;
    final String? status;
    final String? subscriptionPlan;
    final dynamic activatedAt;

    Tenant({
        this.id,
        this.identifier,
        this.name,
        this.subdomain,
        this.status,
        this.subscriptionPlan,
        this.activatedAt,
    });

    Tenant copyWith({
        String? id,
        String? identifier,
        String? name,
        String? subdomain,
        String? status,
        String? subscriptionPlan,
        dynamic activatedAt,
    }) => 
        Tenant(
            id: id ?? this.id,
            identifier: identifier ?? this.identifier,
            name: name ?? this.name,
            subdomain: subdomain ?? this.subdomain,
            status: status ?? this.status,
            subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
            activatedAt: activatedAt ?? this.activatedAt,
        );

    factory Tenant.fromRawJson(String str) => Tenant.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
        id: json["id"],
        identifier: json["identifier"],
        name: json["name"],
        subdomain: json["subdomain"],
        status: json["status"],
        subscriptionPlan: json["subscriptionPlan"],
        activatedAt: json["activatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "name": name,
        "subdomain": subdomain,
        "status": status,
        "subscriptionPlan": subscriptionPlan,
        "activatedAt": activatedAt,
    };
}
