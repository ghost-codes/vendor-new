import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/staffModel.dart';
import 'package:vendoorr/core/models/userRoleEditmodel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import '../locator.dart';

class EditStaffViewModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;

  bool isLoading = false;
  bool isImageHovered = false;

  bool isImageReadyForUpload = false;
  bool isDoneUploadingImage = false;
  bool isimageUploading = false;
  bool isNameLoading = false;
  bool isUsernameLoading = false;
  bool isPhoneLoading = false;
  bool isDescriptionLoading = false;
  bool isIsActiveLoading = false;

  bool isNameEnabled = false;
  bool isUsernameEnabled = false;
  bool isPhoneEnabled = false;
  bool isDescriptionEnabled = false;

  bool isDelete = false;
  bool deleteImage = false;

  uploadNewImage() async {
    isimageUploading = true;
    notifyListeners();
    var response = await _api.updateStaff(
      staffModel.id,
      {
        "photo": MultipartFile.fromFileSync(myFile.files[0].path),
        "vendor_username": staffModel.vendorUsername,
      },
    );

    if (response) {
      isImageReadyForUpload = false;
      isDoneUploadingImage = true;
    }
    isimageUploading = false;
    notifyListeners();
  }

  editName() async {
    if (isNameEnabled) {
      isNameLoading = true;
      notifyListeners();
      var response = await _api.updateStaff(staffModel.id, {
        "name": nameController.text,
        "vendor_username": staffModel.vendorUsername,
      });

      isNameLoading = false;
    }
    isNameEnabled = !isNameEnabled;
    notifyListeners();
  }

  editPhone() async {
    if (isPhoneEnabled) {
      isPhoneLoading = true;
      notifyListeners();
      var response = await _api.updateStaff(staffModel.id, {
        "phone": phone.text,
        "vendor_username": staffModel.vendorUsername,
      });

      isPhoneLoading = false;
    }
    isPhoneEnabled = !isPhoneEnabled;
    notifyListeners();
  }

  editUsername() async {
    if (isUsernameEnabled) {
      print(staffModel.username.split("."));
      isUsernameLoading = true;
      notifyListeners();
      var response = await _api.updateStaff(staffModel.id, {
        "username": username.text,
        "vendor_username": staffModel.vendorUsername,
      });

      isUsernameLoading = false;
    }
    isUsernameEnabled = !isUsernameEnabled;
    notifyListeners();
  }

  editDescription() async {
    if (isDescriptionEnabled) {
      isDescriptionLoading = true;
      notifyListeners();
      var response = await _api.updateStaff(staffModel.id, {
        "description": description.text,
        "vendor_username": staffModel.vendorUsername,
      });

      isDescriptionLoading = false;
    }
    isDescriptionEnabled = !isDescriptionEnabled;
    notifyListeners();
  }

  String selectedUserId = "";

  List<UserRoleDisplayModel> userRoles = [];
  StaffModel staffModel;

  final formKey = GlobalKey<FormState>();

  Api _api = sl<Api>();

  TextEditingController nameController = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  bool staffStatus;

  Future<void> init(StaffModel staffModel) async {
    setState(ViewState.Busy);
    userRoles = await _api.getStaffRolesTrancated();
    this.staffModel = staffModel;
    nameController.text = staffModel.name;
    print(staffModel.vendorUsername);
    username.text = staffModel.username;
    phone.text = staffModel.phone.replaceAll("+233", "");
    description.text = staffModel.description;
    selectedUserId = staffModel.userRole == null ? "" : staffModel.userRole;
    staffStatus = staffModel.isActive;
    setState(ViewState.Idle);
  }

  onUserRoleChanged(String value) async {
    print(value);
    selectedUserId = value;
    var response = await _api.updateStaff(staffModel.id, {
      "user_role": selectedUserId,
      "vendor_username": staffModel.vendorUsername,
    });
    notifyListeners();
  }

  // onImageSelect() async {
  //   myFile = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //   imageOutput = File(myFile.files[0].path).readAsBytesSync();
  //   notifyListeners();
  // }

  onIsActiveChanged(bool value) async {
    print(value);
    isIsActiveLoading = true;
    notifyListeners();
    var response = await _api.updateStaff(staffModel.id, {
      "is_active": value ? 1 : 0,
      "vendor_username": staffModel.vendorUsername,
    });
    if (response) staffStatus = value;
    isIsActiveLoading = false;
    notifyListeners();
  }

  onImageSelect() async {
    Directory tempDir = (await getApplicationDocumentsDirectory());
    // imageFile = File("");
    imageFile = File(tempDir.path + "/vendoorr/addbranchlogo");
    myFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    imageOutput = File(myFile.files[0].path).readAsBytesSync();
    isImageReadyForUpload = true;
    isDoneUploadingImage = false;
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
}
