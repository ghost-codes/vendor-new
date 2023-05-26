import 'dart:convert';

TabModel tabModelFromJson(String str) => TabModel.fromJson(json.decode(str));

String tabModelToJson(TabModel data) => json.encode(data.toJson());

class TabModel {
  TabModel({
    this.id,
    this.branch,
    this.records,
    this.created,
    this.modified,
    this.name,
    this.total,
    this.description,
  });

  String id;
  String branch;
  List<Record> records;
  String created;
  String modified;
  String name;
  String total;
  String description;

  factory TabModel.fromJson(Map<String, dynamic> json) => TabModel(
        id: json["id"],
        branch: json["branch"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
        created: json["created"],
        modified: json["modified"],
        name: json["name"],
        total: json["total"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
        "created": created,
        "modified": modified,
        "name": name,
        "total": total,
        "description": description,
      };
}

class Record {
  Record({
    this.id,
    this.creditTab,
    this.recordItems,
    this.created,
    this.modified,
    this.description,
    this.attendant,
    this.recordType,
    this.value,
    this.containsItems,
  });

  String id;
  String creditTab;
  List<RecordItem> recordItems;
  String created;
  String modified;
  String description;
  String attendant;
  String recordType;
  String value;
  bool containsItems;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        creditTab: json["credit_tab"],
        recordItems: List<RecordItem>.from(
            json["record_items"].map((x) => RecordItem.fromJson(x))),
        created: json["created"],
        modified: json["modified"],
        description: json["description"],
        attendant: json["attendant"],
        recordType: json["record_type"],
        value: json["value"],
        containsItems: json["contains_items"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "credit_tab": creditTab,
        "record_items": List<dynamic>.from(recordItems.map((x) => x.toJson())),
        "created": created,
        "modified": modified,
        "description": description,
        "attendant": attendant,
        "record_type": recordType,
        "value": value,
        "contains_items": containsItems,
      };
}

class RecordItem {
  RecordItem({
    this.id,
    this.record,
    this.created,
    this.modified,
    this.itemId,
    this.itemType,
    this.name,
    this.price,
    this.quantity,
    this.trackedQuantity,
  });

  int id;
  String record;
  String created;
  String modified;
  String itemId;
  String itemType;
  String name;
  String price;
  int quantity;
  int trackedQuantity;

  factory RecordItem.fromJson(Map<String, dynamic> json) => RecordItem(
        id: json["id"],
        record: json["record"],
        created: json["created"],
        modified: json["modified"],
        itemId: json["item_id"],
        itemType: json["item_type"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        trackedQuantity: json["tracked_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "record": record,
        "created": created,
        "modified": modified,
        "item_id": itemId,
        "item_type": itemType,
        "name": name,
        "price": price,
        "quantity": quantity,
        "tracked_quantity": trackedQuantity,
      };
}
