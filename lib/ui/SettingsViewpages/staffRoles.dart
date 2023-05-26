import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/staffRoleViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/addUserRoleModal.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/deleteUserRoleModal.dart';
import 'package:vendoorr/ui/widgets/editUserRoleModal.dart';

class StaffRoles extends StatelessWidget {
  const StaffRoles({
    Key key,
  }) : super(key: key);

  final String branchId = "";

  @override
  Widget build(BuildContext context) {
    return BaseView<StaffRoleViewModel>(onModelReady: (model) {
      model.init(branch: branchId);
    }, builder: (context, staffRoleModel, _) {
      return staffRoleModel.state == ViewState.Busy
          ? Center(
              child: Loaders.fadingCube,
            )
          : Column(children: [
              StaffRoleHeader(),
              SizedBox(
                height: ConstantValues.PadWide,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView(
                              children: staffRoleModel.userRoles
                                  .map((e) => InkWell(
                                      onTap: () {
                                        staffRoleModel.setSelectedUserRole(
                                            staffRoleModel.userRoles
                                                .indexOf(e));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 15),
                                          width: double.infinity,
                                          decoration: staffRoleModel.userRoles
                                                      .indexOf(e) ==
                                                  staffRoleModel.selectedIndex
                                              ? BoxDecoration(
                                                  color: LocalColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ConstantValues
                                                              .BorderRadius),
                                                  boxShadow:
                                                      ConstantValues.baseShadow)
                                              : null,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Text(
                                            e.name,
                                            style: LocalTextTheme.tableHeader
                                                .copyWith(
                                                    color: LocalColors.black,
                                                    fontSize: 16),
                                          ))))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(ConstantValues.PadWide * 2),
                        decoration: BoxDecoration(
                            color: LocalColors.white,
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius),
                            boxShadow: ConstantValues.baseShadow),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  PermissionClass(
                                    name: "Products",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_products",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewProducts,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_products",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canCreateProducts,
                                      ),
                                      Permission(
                                        permissionName: "Can manage.",
                                        objectId: "can_manage_products",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canManageProducts,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Consignments",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_consignments",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canViewConsignments,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_consignments",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canCreateConsignments,
                                      ),
                                      Permission(
                                        permissionName: "Can manage.",
                                        objectId: "can_manage_consignments",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canManageConsignments,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Orders",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_orders",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewOrders,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_orders",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canCreateOrders,
                                      ),
                                      Permission(
                                        permissionName: "Can manage.",
                                        objectId: "can_manage_orders",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canManageOrders,
                                      ),
                                      Permission(
                                        permissionName: "Can regulate.",
                                        objectId: "can_regulate_orders",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canRegulateOrders,
                                      )
                                    ],
                                  ),
                                  PermissionClass(
                                    name: "",
                                    permissions: [
                                      Permission(
                                        objectId: "can_edit_prices_for_orders",
                                        permissionName:
                                            "Can Edit Price For Orders",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canEditPriceForOrders,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Sales",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_sales",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewSales,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_make_sales",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canMakeSales,
                                      ),
                                      Permission(
                                        permissionName: "Can refund.",
                                        objectId: "can_refund_sales",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canRefundSales,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Credits/Debits",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_account_tabs",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canViewAccountTabs,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_account_tabs",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canCreateAccountTabs,
                                      ),
                                      Permission(
                                        permissionName: "Can credit and debit.",
                                        objectId: "can_manage_account_tabs",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canManageAccountTabs,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Expenses",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view",
                                        objectId: "can_view_expenses",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewExpenses,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_expenses",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canCreateExpenses,
                                      ),
                                      Permission(
                                        permissionName: "Can manage",
                                        objectId: "can_manage_expenses",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canManageExpenses,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Staff",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_staff",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewStaff,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_staff",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canCreateStaff,
                                      ),
                                      Permission(
                                        permissionName: "Can manage",
                                        objectId: "can_manage_staff",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canManageStaff,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Contacts",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_contacts",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewContacts,
                                      ),
                                      Permission(
                                        permissionName: "Can create",
                                        objectId: "can_create_contacts",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canCreateContacts,
                                      ),
                                      Permission(
                                        permissionName: "Can manage",
                                        objectId: "can_manage_contacts",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canManageContacts,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Analysis",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_analyses",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole.canViewAnalyses,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Activity Log",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_activity_log",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canViewActivityLog,
                                      ),
                                      Permission(
                                        permissionName: "Can manage",
                                        objectId: "can_manage_activity_log",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canManageActivityLog,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                  PermissionClass(
                                    name: "Settings",
                                    permissions: [
                                      Permission(
                                        permissionName: "Can view.",
                                        objectId: "can_view_other_settings",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canViewOtherSettings,
                                      ),
                                      Permission(
                                        permissionName: "Can manage",
                                        objectId: "can_manage_other_settings",
                                        permissionValue: staffRoleModel
                                            .selectedUserRole
                                            .canManageOtherSettings,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ConstantValues.PadWide,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  !staffRoleModel.selectedUserRole.isDefault,
                              child: !staffRoleModel.selectedUserRole.compareTo(
                                      staffRoleModel.userRoles[
                                              staffRoleModel.selectedIndex]
                                          .toPermissionsMap())
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SmallSecondaryButton(
                                          text: "Cancel",
                                          onPressed: staffRoleModel.cancelEdit,
                                        ),
                                        SizedBox(
                                          width: ConstantValues.PadWide,
                                        ),
                                        SmallPrimaryButton(
                                          text: "Save",
                                          onPressed: staffRoleModel.onSave,
                                          // onPressed: ,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SmallSecondaryButton(
                                          text: "Delete",
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => DeleteUserRole(
                                                    staffRoleModel.onDelete));
                                          },
                                        ),
                                        SizedBox(
                                          width: ConstantValues.PadWide,
                                        ),
                                        SmallPrimaryButton(
                                          text: "Edit",
                                          onPressed: () async {
                                            bool result = await showDialog(
                                                context: context,
                                                builder: (_) => EditUserRole(
                                                    staffRoleModel
                                                        .selectedUserRole));
                                            if (result)
                                              staffRoleModel.getUserRoles();
                                          },
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
    });
  }
}

class StaffRoleHeader extends StatelessWidget {
  const StaffRoleHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StaffRoleViewModel>(
      builder: (context, staffRoleModel, _) {
        return BaseHeader(
          midSection: Text("User Roles"),
          button: Row(
            children: [
              SmallPrimaryButton(
                text: "+ user role",
                onPressed: () async {
                  bool reload = await showDialog(
                      context: context, builder: (context) => AddUserRole());

                  if (reload) staffRoleModel.getUserRoles();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class PermissionClass extends StatelessWidget {
  const PermissionClass({Key key, this.name, this.permissions})
      : super(key: key);
  final String name;
  final List<Permission> permissions;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          child: Text(
            name,
            style: LocalTextTheme.header,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 50),
          child: Row(
            children: permissions,
          ),
        ),
        Divider()
      ],
    );
  }
}

class Permission extends StatelessWidget {
  const Permission(
      {Key key,
      this.permissionName,
      this.permissionValue,
      this.onChanged,
      this.objectId})
      : super(key: key);
  final String permissionName;
  final bool permissionValue;
  final void Function({@required String permission, @required bool value})
      onChanged;
  final String objectId;

  @override
  Widget build(BuildContext context) {
    return Consumer<StaffRoleViewModel>(builder: (context, model, _) {
      return Container(
        padding: EdgeInsets.only(right: 15),
        child: Row(
          children: [
            Checkbox(
                value: permissionValue ?? false,
                onChanged: model.selectedUserRole.isDefault
                    ? null
                    : (value) {
                        model.updateUserModel(
                            permission: objectId, value: value);
                        // onChanged(permission: objectId, value: value);
                      }),
            Text(permissionName, style: TextStyle(fontFamily: "Montserrat"))
          ],
        ),
      );
    });
  }
}
