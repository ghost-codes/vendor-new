// To parse this JSON data, do
//
//     final activityDataModel = activityDataModelFromJson(jsonString);

import 'dart:convert';

ActivityDataModel activityDataModelFromJson(String str) =>
    ActivityDataModel.fromJson(json.decode(str));

String activityDataModelToJson(ActivityDataModel data) =>
    json.encode(data.toJson());

class ActivityDataModel {
  ActivityDataModel({
    this.id,
    this.branch,
    this.deviceInfo,
    this.created,
    this.modified,
    this.itemType,
    this.activityType,
    this.itemId,
    this.reference,
    this.description,
    this.user,
  });

  String id;
  String branch;
  DeviceInfo deviceInfo;
  String created;
  String modified;
  String itemType;
  String activityType;
  String itemId;
  String reference;
  String description;
  String user;

  factory ActivityDataModel.fromJson(Map<String, dynamic> json) =>
      ActivityDataModel(
        id: json["id"],
        branch: json["branch"],
        deviceInfo: DeviceInfo.fromJson(json["device_info"]),
        created: json["created"],
        modified: json["modified"],
        itemType: json["item_type"],
        activityType: json["activity_type"],
        itemId: json["item_id"],
        reference: json["reference"],
        description: json["description"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch": branch,
        "device_info": deviceInfo.toJson(),
        "created": created,
        "modified": modified,
        "item_type": itemType,
        "activity_type": activityType,
        "item_id": itemId,
        "reference": reference,
        "description": description,
        "user": user,
      };
}

class DeviceInfo {
  DeviceInfo({
    this.id,
    this.name,
    this.operatingSystem,
    this.operatingSystemVersion,
    this.browser,
    this.browserVersion,
    this.ipAddress,
  });

  String id;
  String name;
  String operatingSystem;
  String operatingSystemVersion;
  String browser;
  String browserVersion;
  String ipAddress;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        id: json["id"],
        name: json["name"],
        operatingSystem: json["operating_system"],
        operatingSystemVersion: json["operating_system_version"],
        browser: json["browser"],
        browserVersion: json["browser_version"],
        ipAddress: json["ip_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "operating_system": operatingSystem,
        "operating_system_version": operatingSystemVersion,
        "browser": browser,
        "browser_version": browserVersion,
        "ip_address": ipAddress,
      };
}
