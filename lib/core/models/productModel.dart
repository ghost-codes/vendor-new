import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.image,
    this.branch,
    this.category,
    this.name,
    this.batchCode,
    this.autoTrackConsignment,
    this.unitCostPrice,
    this.unitMinimumPrice,
    this.unitSellingPrice,
    this.description,
    this.quantityRemaining,
  });

  int quantityRemaining;
  String id;
  String image;
  String branch;
  String category;
  String name;
  String batchCode;
  bool autoTrackConsignment;
  String unitCostPrice;
  String unitMinimumPrice;
  String unitSellingPrice;
  String description;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        quantityRemaining: json["quantity_remaining"],
        image: json["image"],
        branch: json["branch"],
        category: json["category"],
        name: json["name"],
        batchCode: json["batch_code"],
        autoTrackConsignment: json["auto_track_consignment"],
        unitCostPrice: json["unit_cost_price"],
        unitMinimumPrice: json["unit_minimum_selling_price"],
        unitSellingPrice: json["unit_selling_price"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "branch": branch,
        "category": category,
        "name": name,
        "batch_code": batchCode,
        "auto_track_consignment": autoTrackConsignment,
        "unit_cost_price": unitCostPrice,
        "unit_minimum_selling_price": unitMinimumPrice,
        "unit_selling_price": unitSellingPrice,
        "description": description,
        "quantity_remaining": quantityRemaining,
      };
}
