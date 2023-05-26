// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserRoleDisplayModel> userModelFromJson(String str) =>
    List<UserRoleDisplayModel>.from(
        json.decode(str).map((x) => UserRoleDisplayModel.fromJson(x)));

String userModelToJson(List<UserRoleDisplayModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserRoleDisplayModel {
  UserRoleDisplayModel({
    this.id,
    this.created,
    this.modified,
    this.name,
    this.description,
    this.isDefault,
    this.canViewProducts,
    this.canCreateProducts,
    this.canManageProducts,
    this.canViewConsignments,
    this.canCreateConsignments,
    this.canManageConsignments,
    this.canViewOrders,
    this.canCreateOrders,
    this.canManageOrders,
    this.canRegulateOrders,
    this.canViewSales,
    this.canMakeSales,
    this.canRefundSales,
    this.canViewAccountTabs,
    this.canCreateAccountTabs,
    this.canManageAccountTabs,
    this.canViewExpenses,
    this.canCreateExpenses,
    this.canManageExpenses,
    this.canViewStaff,
    this.canCreateStaff,
    this.canManageStaff,
    this.canViewContacts,
    this.canCreateContacts,
    this.canManageContacts,
    this.canViewAnalyses,
    this.canViewActivityLog,
    this.canManageActivityLog,
    this.canViewOtherSettings,
    this.canManageOtherSettings,
    this.canEditPriceForOrders,
    this.vendor,
  });

  String id;
  String created;
  String modified;
  String name;
  String description;
  bool isDefault;
  bool canViewProducts;
  bool canCreateProducts;
  bool canManageProducts;
  bool canViewConsignments;
  bool canCreateConsignments;
  bool canManageConsignments;
  bool canViewOrders;
  bool canCreateOrders;
  bool canManageOrders;
  bool canRegulateOrders;
  bool canViewSales;
  bool canMakeSales;
  bool canRefundSales;
  bool canViewAccountTabs;
  bool canCreateAccountTabs;
  bool canManageAccountTabs;
  bool canViewExpenses;
  bool canCreateExpenses;
  bool canManageExpenses;
  bool canViewStaff;
  bool canCreateStaff;
  bool canManageStaff;
  bool canViewContacts;
  bool canCreateContacts;
  bool canManageContacts;
  bool canViewAnalyses;
  bool canViewActivityLog;
  bool canManageActivityLog;
  bool canViewOtherSettings;
  bool canManageOtherSettings;
  bool canEditPriceForOrders;
  String vendor;

  factory UserRoleDisplayModel.fromJson(Map<String, dynamic> json) =>
      UserRoleDisplayModel(
        id: json["id"],
        created: json["created"],
        modified: json["modified"],
        name: json["name"],
        description: json["description"],
        isDefault: json["is_default"],
        canViewProducts: json["can_view_products"],
        canCreateProducts: json["can_create_products"],
        canManageProducts: json["can_manage_products"],
        canViewConsignments: json["can_view_consignments"],
        canCreateConsignments: json["can_create_consignments"],
        canManageConsignments: json["can_manage_consignments"],
        canViewOrders: json["can_view_orders"],
        canCreateOrders: json["can_create_orders"],
        canManageOrders: json["can_manage_orders"],
        canRegulateOrders: json["can_regulate_orders"],
        canViewSales: json["can_view_sales"],
        canMakeSales: json["can_make_sales"],
        canRefundSales: json["can_refund_sales"],
        canViewAccountTabs: json["can_view_account_tabs"],
        canCreateAccountTabs: json["can_create_account_tabs"],
        canManageAccountTabs: json["can_manage_account_tabs"],
        canViewExpenses: json["can_view_expenses"],
        canCreateExpenses: json["can_create_expenses"],
        canManageExpenses: json["can_manage_expenses"],
        canViewStaff: json["can_view_staff"],
        canCreateStaff: json["can_create_staff"],
        canManageStaff: json["can_manage_staff"],
        canViewContacts: json["can_view_contacts"],
        canCreateContacts: json["can_create_contacts"],
        canManageContacts: json["can_manage_contacts"],
        canViewAnalyses: json["can_view_analyses"],
        canViewActivityLog: json["can_view_activity_log"],
        canManageActivityLog: json["can_manage_activity_log"],
        canViewOtherSettings: json["can_view_other_settings"],
        canManageOtherSettings: json["can_manage_other_settings"],
        canEditPriceForOrders: json["can_edit_prices_for_orders"],
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created,
        "modified": modified,
        "name": name,
        "description": description,
        "is_default": isDefault,
        "can_view_products": canViewProducts,
        "can_create_products": canCreateProducts,
        "can_manage_products": canManageProducts,
        "can_view_consignments": canViewConsignments,
        "can_create_consignments": canCreateConsignments,
        "can_manage_consignments": canManageConsignments,
        "can_view_orders": canViewOrders,
        "can_create_orders": canCreateOrders,
        "can_manage_orders": canManageOrders,
        "can_regulate_orders": canRegulateOrders,
        "can_view_sales": canViewSales,
        "can_make_sales": canMakeSales,
        "can_refund_sales": canRefundSales,
        "can_view_account_tabs": canViewAccountTabs,
        "can_create_account_tabs": canCreateAccountTabs,
        "can_manage_account_tabs": canManageAccountTabs,
        "can_view_expenses": canViewExpenses,
        "can_create_expenses": canCreateExpenses,
        "can_manage_expenses": canManageExpenses,
        "can_view_staff": canViewStaff,
        "can_create_staff": canCreateStaff,
        "can_manage_staff": canManageStaff,
        "can_view_contacts": canViewContacts,
        "can_create_contacts": canCreateContacts,
        "can_manage_contacts": canManageContacts,
        "can_view_analyses": canViewAnalyses,
        "can_view_activity_log": canViewActivityLog,
        "can_manage_activity_log": canManageActivityLog,
        "can_view_other_settings": canViewOtherSettings,
        "can_manage_other_settings": canManageOtherSettings,
        "can_edit_prices_for_orders": canEditPriceForOrders,
        "vendor": vendor,
      };

  Map<String, bool> toPermissionsMap() {
    return {
      "can_view_products": canViewProducts,
      "can_create_products": canCreateProducts,
      "can_manage_products": canManageProducts,
      "can_view_consignments": canViewConsignments,
      "can_create_consignments": canCreateConsignments,
      "can_manage_consignments": canManageConsignments,
      "can_view_orders": canViewOrders,
      "can_create_orders": canCreateOrders,
      "can_manage_orders": canManageOrders,
      "can_regulate_orders": canRegulateOrders,
      "can_view_sales": canViewSales,
      "can_make_sales": canMakeSales,
      "can_refund_sales": canRefundSales,
      "can_view_account_tabs": canViewAccountTabs,
      "can_create_account_tabs": canCreateAccountTabs,
      "can_manage_account_tabs": canManageAccountTabs,
      "can_view_expenses": canViewExpenses,
      "can_create_expenses": canCreateExpenses,
      "can_manage_expenses": canManageExpenses,
      "can_view_staff": canViewStaff,
      "can_create_staff": canCreateStaff,
      "can_manage_staff": canManageStaff,
      "can_view_contacts": canViewContacts,
      "can_create_contacts": canCreateContacts,
      "can_manage_contacts": canManageContacts,
      "can_view_analyses": canViewAnalyses,
      "can_view_activity_log": canViewActivityLog,
      "can_manage_activity_log": canManageActivityLog,
      "can_view_other_settings": canViewOtherSettings,
      "can_manage_other_settings": canManageOtherSettings,
      "can_edit_prices_for_orders": canEditPriceForOrders,
    };
  }

  bool compareTo(Map<String, bool> map) {
    List<bool> values = [];
    Map<String, bool> b = toPermissionsMap();
    b.forEach((key, value) {
      values.add(map[key] == value);
    });
    return values.firstWhere((element) => !element, orElse: () => true);
  }
}
