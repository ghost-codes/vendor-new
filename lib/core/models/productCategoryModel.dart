// To parse this JSON data, do
//
//     final productCategoryModel = productCategoryModelFromJson(jsonString);

import 'dart:convert';

class ProductCategoryModel {
  ProductCategoryModel({
    this.id,
    this.image,
    this.name,
    this.branch,
    this.description,
    this.isEnd,
    this.path,
    this.depth,
    this.numchild,
  });

  String id;
  String image;
  String name;
  String branch;
  String description;
  bool isEnd;
  String path;
  int depth;
  int numchild;

  factory ProductCategoryModel.fromRawJson(String str) =>
      ProductCategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        branch: json["branch"],
        description: json["description"],
        isEnd: json["is_end"],
        path: json["path"],
        depth: json["depth"],
        numchild: json["numchild"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "branch": branch,
        "description": description,
        "is_end": isEnd,
        "path": path,
        "depth": depth,
        "numchild": numchild,
      };
}
