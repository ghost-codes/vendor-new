// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.id,
    this.branch,
    this.orderItems,
    this.created,
    this.modified,
    this.name,
    this.attendant,
    this.total,
    this.discount,
    this.discountIsPercentage,
    this.amountPayable,
    this.clientPhone,
    this.isPending,
    this.isTrashed,
    this.isArchived,
    this.vendor,
  });

  String id;
  String branch;
  List<OrderItem> orderItems;
  String created;
  String modified;
  String name;
  String attendant;
  String total;
  String discount;
  bool discountIsPercentage;
  String amountPayable;
  String clientPhone;
  bool isPending;
  bool isTrashed;
  bool isArchived;
  String vendor;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        branch: json["branch"],
        orderItems: List<OrderItem>.from(
            json["order_items"].map((x) => OrderItem.fromJson(x))),
        created: json["created"],
        modified: json["modified"],
        name: json["name"],
        attendant: json["attendant"],
        total: json["total"],
        discount: json["discount"],
        discountIsPercentage: json["discount_is_percentage"],
        amountPayable: json["amount_payable"],
        clientPhone: json["client_phone"],
        isPending: json["is_pending"],
        isTrashed: json["is_trashed"],
        isArchived: json["is_archived"],
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "created": created,
        "modified": modified,
        "name": name,
        "attendant": attendant,
        "total": total,
        "discount": discount,
        "discount_is_percentage": discountIsPercentage,
        "amount_payable": amountPayable,
        "client_phone": clientPhone,
        "is_pending": isPending,
        "is_trashed": isTrashed,
        "is_archived": isArchived,
        "vendor": vendor,
      };
}

class OrderItem {
  OrderItem({
    this.id,
    this.order,
    this.created,
    this.modified,
    this.itemId,
    this.type,
    this.name,
    this.price,
    this.quantity,
    this.trackedQuantity,
    this.isPending,
    this.isTrashed,
    this.totalEvaluation,
    this.printer,
    this.ancestorCategory,
  });

  int id;
  String ancestorCategory;
  String order;
  String created;
  String modified;
  String itemId;
  String type;
  String name;
  String price;
  int quantity;
  int trackedQuantity;
  bool isPending;
  bool isTrashed;
  String totalEvaluation;
  String printer;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        order: json["order"],
        created: json["created"],
        modified: json["modified"],
        itemId: json["item_id"],
        type: json["type"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        trackedQuantity: json["tracked_quantity"],
        isPending: json["is_pending"],
        isTrashed: json["is_trashed"],
        totalEvaluation: json["total_evaluation"],
        printer: json["printer"],
        ancestorCategory: json["ancestor_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "created": created,
        "modified": modified,
        "item_id": itemId,
        "type": type,
        "name": name,
        "price": price,
        "quantity": quantity,
        "tracked_quantity": trackedQuantity,
        "is_pending": isPending,
        "is_trashed": isTrashed,
        "total_evaluation": totalEvaluation,
        "printer": printer,
      };
}
