import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/userRoleEditmodel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import '../locator.dart';

class AddStaffViewModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;

  bool isLoading = false;
  bool isImageHovered = false;
  bool isAutoTrackConsignment = false;
  bool trackExpiry = false;
  bool isPartitionable = false;

  String selectedUserId = "";

  List<UserRoleDisplayModel> userRoles = [];

  final formKey = GlobalKey<FormState>();

  Api _api = sl<Api>();

  TextEditingController nameController = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();

  Future<void> init() async {
    setState(ViewState.Busy);
    userRoles = await _api.getStaffRolesTrancated();
    setState(ViewState.Idle);
  }

  onUserRoleChanged(String value) {
    print(value);
    selectedUserId = value;
    print(selectedUserId);
    notifyListeners();
  }

  onImageSelect() async {
    myFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    imageOutput = File(myFile.files[0].path).readAsBytesSync();
    notifyListeners();
  }

  setIsImageHovered(value) {
    isImageHovered = value;
    notifyListeners();
  }

  onClearImage() {
    imageFile = null;
    imageOutput = null;

    notifyListeners();
  }

  onSubmit(BuildContext context, String branchId) async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      notifyListeners();
      Map<String, dynamic> submitMap = {
        "branch": branchId,
        "name": nameController.text,
        "phone": phone.text,
        "description": description.text,
        "user_role": selectedUserId,
        "username": username.text,
        "photo": myFile != null
            ? MultipartFile.fromFileSync(myFile.files[0].path)
            : null
      };
      print(submitMap);
      var response = await _api.addStff(submitMap);

      if (response) {
        Navigator.of(context).pop(true);
      } else {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
