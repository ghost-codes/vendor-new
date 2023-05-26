import 'dart:convert';

import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/staffModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class StaffViewModel extends BaseModel {
  Api _api = sl<Api>();
  List<StaffModel> staff;
  bool isStaffDetails = false;
  StaffModel selectedStaff;

  getStaff(branchId) async {
    setState(ViewState.Busy);
    staff = await _api.branchStaffApi(branchId);

    setState(ViewState.Idle);
  }

  deleteStaff(branchId) async {
    setState(ViewState.Busy);
    bool deleted = await _api.deleteStaff(selectedStaff.id);
    print(deleted);
    if (deleted) {
      isStaffDetails = false;
      staff.removeWhere((element) => element.id == selectedStaff.id);
      selectedStaff = null;
    }
    setState(ViewState.Idle);
  }

  setStaffDetail({StaffModel staff}) {
    isStaffDetails = !isStaffDetails;
    selectedStaff = staff;
    notifyListeners();
  }
}
