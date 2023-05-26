// To parse this JSON data, do
//
//     final expenseModel = expenseModelFromJson(jsonString);

import 'dart:convert';

ExpenseModel expenseModelFromJson(String str) =>
    ExpenseModel.fromJson(json.decode(str));

String expenseModelToJson(ExpenseModel data) => json.encode(data.toJson());

class ExpenseModel {
  ExpenseModel({
    this.id,
    this.branch,
    this.amount,
    this.created,
    this.modified,
    this.name,
    this.description,
  });

  String id;
  String branch;
  String amount;
  String created;
  String modified;
  String name;
  String description;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        branch: json["branch"],
        amount: json["amount"],
        created: json["created"],
        modified: json["modified"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "amount": amount,
        "created": created,
        "modified": modified,
        "name": name,
        "description": description,
      };
}
