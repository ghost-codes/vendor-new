// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    this.id,
    this.created,
    this.modified,
    this.photo,
    this.name,
    this.phone,
    this.email,
    this.branch,
    this.branchId,
    this.branchName,
  });

  int id;
  DateTime created;
  DateTime modified;
  dynamic photo;
  String name;
  String phone;
  String email;
  String branch;
  String branchId;
  String branchName;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        photo: json["photo"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        branch: json["branch"],
        branchId: json["branch_id"],
        branchName: json["branch_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "photo": photo,
        "name": name,
        "phone": phone,
        "email": email,
        "branch": branch,
        "branch_id": branchId,
        "branch_name": branchName,
      };
}
