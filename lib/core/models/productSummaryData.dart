// To parse this JSON data, do
//
//     final productSummaryData = productSummaryDataFromMap(jsonString);

import 'dart:convert';

ProductSummaryData productSummaryDataFromMap(String str) =>
    ProductSummaryData.fromMap(json.decode(str));

String productSummaryDataToMap(ProductSummaryData data) =>
    json.encode(data.toMap());

class ProductSummaryData {
  ProductSummaryData({
    this.name,
    this.price,
    this.orders,
    this.sales,
    this.total,
  });

  String name;
  double price;
  int orders;
  int sales;
  int total;

  factory ProductSummaryData.fromMap(Map<String, dynamic> json) =>
      ProductSummaryData(
        name: json["name"],
        price: json["price"],
        orders: json["orders"],
        sales: json["sales"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "price": price,
        "orders": orders,
        "sales": sales,
        "total": total,
      };
}
