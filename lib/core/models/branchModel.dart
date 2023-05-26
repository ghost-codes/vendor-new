class BranchModel {
  final String id;
  final String branchName;
  final String location;
  final double revenueOfTheMonth;
  final String dateCreated;
  final String dateModified;
  final String description;
  final int vendor;
  final String branchVendor;
  final String logo;
  final String rootCategory;

  BranchModel({
    this.id,
    this.branchName,
    this.location,
    this.revenueOfTheMonth,
    this.branchVendor,
    this.description,
    this.dateCreated,
    this.dateModified,
    this.vendor,
    this.logo,
    this.rootCategory,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json["id"],
      logo: json["logo"],
      branchName: json["name"],
      location: json["location"],
      revenueOfTheMonth: 5000,
      dateCreated: json["created"],
      dateModified: json["modified"],
      description: json["description"],
      vendor: json["vendor"],
      branchVendor: json["branch_vendor"],
      rootCategory: json["root_category"],
    );
  }
}

// To parse this JSON data, do

//     final branchModel = branchModelFromJson(jsonString);

// import 'dart:convert';

// class BranchModel {
//   BranchModel({
//     this.id,
//     this.created,
//     this.modified,
//     this.logo,
//     this.name,
//     this.location,
//     this.description,
//     this.vendor,
//     this.branchVendor,
//   });

//   String id;
//   DateTime created;
//   DateTime modified;
//   dynamic logo;
//   String name;
//   String location;
//   String description;
//   int vendor;
//   String branchVendor;

//   factory BranchModel.fromRawJson(String str) =>
//       BranchModel.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
//         id: json["id"],
//         created: DateTime.parse(json["created"]),
//         modified: DateTime.parse(json["modified"]),
//         logo: json["logo"],
//         name: json["name"],
//         location: json["location"],
//         description: json["description"],
//         vendor: json["vendor"],
//         branchVendor: json["branch_vendor"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "created": created.toIso8601String(),
//         "modified": modified.toIso8601String(),
//         "logo": logo,
//         "name": name,
//         "location": location,
//         "description": description,
//         "vendor": vendor,
//         "branch_vendor": branchVendor,
//       };
// }
