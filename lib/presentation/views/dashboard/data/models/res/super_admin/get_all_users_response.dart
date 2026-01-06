import 'package:student_management/presentation/views/dashboard/domain/entities/user_role.dart';

class GetAllUsersResponse {
  final List<Content>? content;
  final Pageable? pageable;
  final int? totalPages;
  final int? totalElements;
  final bool? last;
  final int? numberOfElements;
  final bool? first;
  final int? size;
  final int? number;
  final Sort? sort;
  final bool? empty;

  GetAllUsersResponse({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.numberOfElements,
    this.first,
    this.size,
    this.number,
    this.sort,
    this.empty,
  });

  GetAllUsersResponse copyWith({
    List<Content>? content,
    Pageable? pageable,
    int? totalPages,
    int? totalElements,
    bool? last,
    int? numberOfElements,
    bool? first,
    int? size,
    int? number,
    Sort? sort,
    bool? empty,
  }) => GetAllUsersResponse(
    content: content ?? this.content,
    pageable: pageable ?? this.pageable,
    totalPages: totalPages ?? this.totalPages,
    totalElements: totalElements ?? this.totalElements,
    last: last ?? this.last,
    numberOfElements: numberOfElements ?? this.numberOfElements,
    first: first ?? this.first,
    size: size ?? this.size,
    number: number ?? this.number,
    sort: sort ?? this.sort,
    empty: empty ?? this.empty,
  );

  factory GetAllUsersResponse.fromJson(Map<String, dynamic> json) =>
      GetAllUsersResponse(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x)),
              ),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
    "content": content == null
        ? []
        : List<dynamic>.from(content!.map((x) => x.toJson())),
    "pageable": pageable?.toJson(),
    "totalPages": totalPages,
    "totalElements": totalElements,
    "last": last,
    "numberOfElements": numberOfElements,
    "first": first,
    "size": size,
    "number": number,
    "sort": sort?.toJson(),
    "empty": empty,
  };
}

class Content {
  final String? id;
  final dynamic username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? phone;
  final dynamic avatarUrl;
  final String? primaryRole;
  final List<String>? roles;
  final String? status;
  final bool? emailVerified;
  final bool? mfaEnabled;
  final List<int>? lastLoginAt;
  final List<int>? createdAt;
  final List<int>? updatedAt;

  Content({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.primaryRole,
    this.roles,
    this.status,
    this.emailVerified,
    this.mfaEnabled,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  UserRole get role => UserRole.fromValue(primaryRole);

  Content copyWith({
    String? id,
    dynamic username,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phone,
    dynamic avatarUrl,
    String? primaryRole,
    List<String>? roles,
    String? status,
    bool? emailVerified,
    bool? mfaEnabled,
    List<int>? lastLoginAt,
    List<int>? createdAt,
    List<int>? updatedAt,
  }) => Content(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    primaryRole: primaryRole ?? this.primaryRole,
    roles: roles ?? this.roles,
    status: status ?? this.status,
    emailVerified: emailVerified ?? this.emailVerified,
    mfaEnabled: mfaEnabled ?? this.mfaEnabled,
    lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    fullName: json["fullName"],
    phone: json["phone"],
    avatarUrl: json["avatarUrl"],
    primaryRole: json["primaryRole"],
    roles: json["roles"] == null
        ? []
        : List<String>.from(json["roles"]!.map((x) => x)),
    status: json["status"],
    emailVerified: json["emailVerified"],
    mfaEnabled: json["mfaEnabled"],
    lastLoginAt: json["lastLoginAt"] == null
        ? []
        : List<int>.from(json["lastLoginAt"]!.map((x) => x)),
    createdAt: json["createdAt"] == null
        ? []
        : List<int>.from(json["createdAt"]!.map((x) => x)),
    updatedAt: json["updatedAt"] == null
        ? []
        : List<int>.from(json["updatedAt"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "fullName": fullName,
    "phone": phone,
    "avatarUrl": avatarUrl,
    "primaryRole": primaryRole,
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    "status": status,
    "emailVerified": emailVerified,
    "mfaEnabled": mfaEnabled,
    "lastLoginAt": lastLoginAt == null
        ? []
        : List<dynamic>.from(lastLoginAt!.map((x) => x)),
    "createdAt": createdAt == null
        ? []
        : List<dynamic>.from(createdAt!.map((x) => x)),
    "updatedAt": updatedAt == null
        ? []
        : List<dynamic>.from(updatedAt!.map((x) => x)),
  };
}

class Pageable {
  final int? pageNumber;
  final int? pageSize;
  final Sort? sort;
  final int? offset;
  final bool? paged;
  final bool? unpaged;

  Pageable({
    this.pageNumber,
    this.pageSize,
    this.sort,
    this.offset,
    this.paged,
    this.unpaged,
  });

  Pageable copyWith({
    int? pageNumber,
    int? pageSize,
    Sort? sort,
    int? offset,
    bool? paged,
    bool? unpaged,
  }) => Pageable(
    pageNumber: pageNumber ?? this.pageNumber,
    pageSize: pageSize ?? this.pageSize,
    sort: sort ?? this.sort,
    offset: offset ?? this.offset,
    paged: paged ?? this.paged,
    unpaged: unpaged ?? this.unpaged,
  );

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
    offset: json["offset"],
    paged: json["paged"],
    unpaged: json["unpaged"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "sort": sort?.toJson(),
    "offset": offset,
    "paged": paged,
    "unpaged": unpaged,
  };
}

class Sort {
  final bool? sorted;
  final bool? unsorted;
  final bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort copyWith({bool? sorted, bool? unsorted, bool? empty}) => Sort(
    sorted: sorted ?? this.sorted,
    unsorted: unsorted ?? this.unsorted,
    empty: empty ?? this.empty,
  );

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
    sorted: json["sorted"],
    unsorted: json["unsorted"],
    empty: json["empty"],
  );

  Map<String, dynamic> toJson() => {
    "sorted": sorted,
    "unsorted": unsorted,
    "empty": empty,
  };
}
