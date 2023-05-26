class OrderItem {
  OrderItem({
    this.id,
    this.order,
    this.created,
    this.modified,
    this.itemId,
    this.name,
    this.price,
    this.setPrice,
    this.quantity,
    this.isPending,
    this.isTrashed,
    this.totalEvaluation,
    this.printer,
  });

  int id;
  String order;
  DateTime created;
  String modified;
  String itemId;
  String name;
  String price;
  String setPrice;
  int quantity;
  bool isPending;
  bool isTrashed;
  String totalEvaluation;
  String printer;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        order: json["order"],
        created: DateTime.parse(json["created"]),
        modified: json["modified"],
        itemId: json["item_id"],
        name: json["name"],
        price: json["price"],
        setPrice: json["set_price"],
        quantity: json["quantity"],
        isPending: json["is_pending"],
        isTrashed: json["is_trashed"],
        totalEvaluation: json["total_evaluation"],
        printer: json["printer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "created": created.toIso8601String(),
        "modified": modified,
        "item_id": itemId,
        "name": name,
        "price": price,
        "set_price": setPrice,
        "quantity": quantity,
        "is_pending": isPending,
        "is_trashed": isTrashed,
        "total_evaluation": totalEvaluation,
        "printer": printer,
      };
}
