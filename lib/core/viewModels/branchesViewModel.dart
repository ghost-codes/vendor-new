import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/util/dummyJsonData.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class BranchesViewModel extends BaseModel {
  Api _api = sl<Api>();

  String selectedBranchId = "";
  bool isBranchSelected = false;
  List<BranchModel> branches = [];
  int selectedBranchIndex;
  int selectedTab = 2;
  double totalRevenue;
  ScrollController listViewController = ScrollController();
  bool isbranchList = false;
  bool isBranchListItemHovered = false;
  int hoveredIndex;

  bool _isQuantifiable = true;

  bool get isQuantifiable => _isQuantifiable;

  StreamController<bool> refreshpage = StreamController<bool>.broadcast();
  Stream<bool> get refreshPageStream => refreshpage.stream;
  StreamSink<bool> get refreshPageSink => refreshpage.sink;

  setBranchList() {
    isbranchList = !isbranchList;
    notifyListeners();
  }

  setBranchItemIsHovered(bool isHovered, int index) {
    isBranchListItemHovered = isHovered;
    hoveredIndex = index;
    notifyListeners();
  }

  setSelectedBranchId(String id) {
    selectedBranchId = id;
    notifyListeners();
  }

  getBranches(String vendorUsername) async {
    setState(ViewState.Busy);
    totalRevenue = 0;
    branches = await _api.branchesApi(vendorUsername);

    setState(ViewState.Idle);
  }

  setIsBranchTrue(int branchIndex) {
    isBranchSelected = true;
    selectedBranchIndex = branchIndex;
    BranchModel removedItem = branches.removeAt(selectedBranchIndex);
    branches.insert(0, removedItem);
    notifyListeners();
  }

  setIsBranchFalse() {
    BranchModel removedItem = branches.removeAt(0);
    branches.insert(selectedBranchIndex, removedItem);
    isBranchSelected = false;
    notifyListeners();
  }

  branchChange(int index) {
    BranchModel removedItem = branches.removeAt(0);
    branches.insert(selectedBranchIndex, removedItem);
    selectedBranchIndex = index;
    removedItem = branches.removeAt(selectedBranchIndex - 1);
    branches.insert(0, removedItem);
    listViewController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    notifyListeners();
  }
}
