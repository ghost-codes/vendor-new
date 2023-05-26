class SaleItem {
  SaleItem({
    this.id,
    this.sale,
    this.created,
    this.modified,
    this.itemId,
    this.name,
    this.price,
    this.setPrice,
    this.quantity,
    this.orderedCreated,
    this.orderedModified,
    this.totalEvaluation,
  });

  int id;
  String sale;
  String created;
  String modified;
  String itemId;
  String name;
  String price;
  String setPrice;
  int quantity;
  String orderedCreated;
  String orderedModified;
  String totalEvaluation;

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
        id: json["id"],
        sale: json["sale"],
        created: json["created"],
        modified: json["modified"],
        itemId: json["item_id"],
        name: json["name"],
        price: json["price"],
        setPrice: json["set_price"],
        quantity: json["quantity"],
        orderedCreated: json["ordered_created"],
        orderedModified: json["ordered_modified"],
        totalEvaluation: json["total_evaluation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sale": sale,
        "created": created,
        "modified": modified,
        "item_id": itemId,
        "name": name,
        "price": price,
        "set_price": setPrice,
        "quantity": quantity,
        "ordered_created": orderedCreated,
        "ordered_modified": orderedModified,
        "total_evaluation": totalEvaluation,
      };
}
