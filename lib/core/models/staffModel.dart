import 'dart:convert';

StaffModel welcomeFromJson(String str) => StaffModel.fromJson(json.decode(str));

String welcomeToJson(StaffModel data) => json.encode(data.toJson());

class StaffModel {
  StaffModel({
    this.id,
    this.created,
    this.modified,
    this.photo,
    this.name,
    this.description,
    this.phone,
    this.user,
    this.branch,
    this.username,
    this.userRole,
    this.userRoleName,
    this.vendorUsername,
    this.isActive,
  });

  int id;
  bool isActive;
  String created;
  String modified;
  dynamic photo;
  String name;
  String description;
  String phone;
  int user;
  String userRole;
  String userRoleName;
  String branch;
  String username;
  String vendorUsername;

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        id: json["id"],
        created: json["created"],
        modified: json["modified"],
        photo: json["photo"],
        name: json["name"],
        userRole: json["user_role"],
        description: json["description"],
        phone: json["phone"],
        user: json["user"],
        branch: json["branch"],
        username: json["username"],
        vendorUsername: json["vendor_username"],
        userRoleName: json["user_role_name"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created,
        "modified": modified,
        "photo": photo,
        "name": name,
        "description": description,
        "phone": phone,
        "user": user,
        "branch": branch,
        "username": username,
        "is_active": isActive,
      };
}

class Role {
  String id;
  String name;

  Role({this.id, this.name});
  factory Role.fromJson(Map<String, dynamic> json) =>
      Role(id: json["id"], name: json["name"]);
}
