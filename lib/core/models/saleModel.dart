// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:vendoorr/core/models/saleItemModel.dart';

SaleModel saleFromJson(String str) => SaleModel.fromJson(json.decode(str));

String saleToJson(SaleModel data) => json.encode(data.toJson());

class SaleModel {
  SaleModel({
    this.id,
    this.branch,
    this.saleItems,
    this.created,
    this.modified,
    this.name,
    this.attendant,
    this.amountPayable,
    this.amountReceived,
    this.balance,
    this.clientPhone,
    this.orderId,
    this.orderCreated,
    this.orderModified,
    this.vendor,
  });

  String id;
  String branch;
  List<SaleItem> saleItems;
  String created;
  String modified;
  String name;
  String attendant;
  String amountPayable;
  String amountReceived;
  String balance;
  String clientPhone;
  String orderId;
  String orderCreated;
  String orderModified;
  String vendor;

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        id: json["id"],
        branch: json["branch"],
        saleItems: List<SaleItem>.from(
            json["sale_items"].map((x) => SaleItem.fromJson(x))),
        created: json["created"],
        modified: json["modified"],
        name: json["name"],
        attendant: json["attendant"],
        amountPayable: json["amount_payable"],
        amountReceived: json["amount_received"],
        balance: json["balance"],
        clientPhone: json["client_phone"],
        orderId: json["order_id"],
        orderCreated: json["order_created"],
        orderModified: json["order_modified"],
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "sale_items": List<dynamic>.from(saleItems.map((x) => x.toJson())),
        "created": created,
        "modified": modified,
        "name": name,
        "attendant": attendant,
        "amount_payable": amountPayable,
        "amount_received": amountReceived,
        "balance": balance,
        "client_phone": clientPhone,
        "order_id": orderId,
        "order_created": orderCreated,
        "order_modified": orderModified,
        "vendor": vendor,
      };
}
