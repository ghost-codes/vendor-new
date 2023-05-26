// To parse this JSON data, do
//
//     final productHistoryModel = productHistoryModelFromJson(jsonString);

import 'dart:convert';

ProductHistoryModel productHistoryModelFromJson(String str) =>
    ProductHistoryModel.fromJson(json.decode(str));

String productHistoryModelToJson(ProductHistoryModel data) =>
    json.encode(data.toJson());

class ProductHistoryModel {
  ProductHistoryModel({
    this.id,
    this.product,
    this.consignedProduct,
    this.created,
    this.modified,
    this.quantity,
    this.autoTracked,
    this.attendant,
    this.actionType,
    this.totalRemaining,
    this.description,
  });

  String id;
  String product;
  String consignedProduct;
  String created;
  String modified;
  int quantity;
  bool autoTracked;
  String attendant;
  String actionType;
  int totalRemaining;
  String description;

  factory ProductHistoryModel.fromJson(Map<String, dynamic> json) =>
      ProductHistoryModel(
        id: json["id"],
        product: json["product"],
        consignedProduct: json["consigned_product"],
        created: json["created"],
        modified: json["modified"],
        quantity: json["quantity"],
        autoTracked: json["auto_tracked"],
        attendant: json["attendant"],
        actionType: json["action_type"],
        totalRemaining: json["total_remaining"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "consigned_product": consignedProduct,
        "created": created,
        "modified": modified,
        "quantity": quantity,
        "auto_tracked": autoTracked,
        "attendant": attendant,
        "action_type": actionType,
        "total_remaining": totalRemaining,
        "description": description,
      };
}
