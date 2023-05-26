// To parse this JSON data, do
//
//     final consignmentModel = consignmentModelFromJson(jsonString);

import 'dart:convert';

ConsignmentModel consignmentModelFromJson(String str) =>
    ConsignmentModel.fromJson(json.decode(str));

String consignmentModelToJson(ConsignmentModel data) =>
    json.encode(data.toJson());

class ConsignmentModel {
  ConsignmentModel({
    this.id,
    this.branch,
    this.reference,
    this.consignedProducts,
    this.cost,
    this.remaining,
    this.description,
    this.branchName,
    this.created,
  });

  String created;
  String id;
  String branch;
  String reference;
  List<ConsignedProduct> consignedProducts;
  String cost;
  String remaining;
  String description;
  String branchName;

  factory ConsignmentModel.fromJson(Map<String, dynamic> json) =>
      ConsignmentModel(
        id: json["id"],
        branch: json["branch"],
        reference: json["reference"],
        consignedProducts: List<ConsignedProduct>.from(
            json["consigned_products"]
                .map((x) => ConsignedProduct.fromJson(x))),
        created: json["created"],
        cost: json["cost"],
        remaining: json["remaining"],
        description: json["description"],
        branchName: json["branch_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "reference": reference,
        "consigned_products":
            List<dynamic>.from(consignedProducts.map((x) => x.toJson())),
        "cost": cost,
        "remaining": remaining,
        "description": description,
        "branch_name": branchName,
        "created": created,
      };
}

class ConsignedProduct {
  ConsignedProduct({
    this.name,
    this.id,
    this.consignment,
    this.product,
    this.unitCostPrice,
    this.unitMinimumSellingPrice,
    this.unitSellingPrice,
    this.quantityConsigned,
    this.quantityRemaining,
  });

  String id;
  String name;
  String consignment;
  String product;
  String unitCostPrice;
  String unitMinimumSellingPrice;
  String unitSellingPrice;
  int quantityConsigned;
  int quantityRemaining;

  factory ConsignedProduct.fromJson(Map<String, dynamic> json) =>
      ConsignedProduct(
        id: json["id"],
        consignment: json["consignment"],
        name: json["name"],
        product: json["product"],
        unitCostPrice: json["unit_cost_price"],
        unitMinimumSellingPrice: json["unit_minimum_selling_price"],
        unitSellingPrice: json["unit_selling_price"],
        quantityConsigned: json["quantity_consigned"],
        quantityRemaining: json["quantity_remaining"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "consignment": consignment,
        "name": name,
        "product": product,
        "unit_cost_price": unitCostPrice,
        "unit_minimum_selling_price": unitMinimumSellingPrice,
        "unit_selling_price": unitSellingPrice,
        "quantity_consigned": quantityConsigned,
        "quantity_remaining": quantityRemaining,
      };
}
