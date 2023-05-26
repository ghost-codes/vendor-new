import 'package:flutter/material.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/ui/baseView.dart';

class BranchTopViewModel extends BaseModel {
  bool isBranchDetails = false;

  setIsBranchDetails() {
    isBranchDetails = !isBranchDetails;
    notifyListeners();
  }
}
