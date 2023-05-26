import 'package:flutter/material.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/userRoleEditmodel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class StaffRoleViewModel extends BaseModel {
  String branchId = "";
  Api _api = sl<Api>();
  List<UserRoleDisplayModel> userRoles = [];
  int selectedIndex = 0;
  UserRoleDisplayModel selectedUserRole;

  init({
    @required String branch,
  }) {
    branchId = branch;
    getUserRoles();
  }

  Future<void> getUserRoles() async {
    setState(ViewState.Busy);
    userRoles = await _api.getStaffRoles(branchId);
    if (userRoles.isNotEmpty || userRoles != null)
      selectedUserRole = userRoles[0];
    selectedIndex = 0;
    setState(ViewState.Idle);
  }

  void setSelectedUserRole(int index) {
    selectedIndex = index;
    if (userRoles.isNotEmpty && selectedIndex <= userRoles.length)
      selectedUserRole = userRoles[index];
    notifyListeners();
  }

  void updateUserModel({@required String permission, @required bool value}) {
    Map<String, dynamic> map = selectedUserRole.toJson();
    map[permission] = value;
    selectedUserRole = UserRoleDisplayModel.fromJson(map);
    notifyListeners();
  }

  Future<void> onSave() async {
    setState(ViewState.Busy);
    print(selectedUserRole.toJson());
    bool result = await _api.updateUserRole(
        selectedUserRole.id, selectedUserRole.toJson());
    if (result) getUserRoles();
    setState(ViewState.Idle);
  }

  Future<void> onDelete(BuildContext context) async {
    Navigator.pop(context);
    setState(ViewState.Busy);
    bool result = await _api.deleteUserRole(selectedUserRole.id);
    if (result) getUserRoles();
    setState(ViewState.Idle);
  }

  void cancelEdit() {
    selectedUserRole = userRoles[selectedIndex];
    notifyListeners();
  }
}
