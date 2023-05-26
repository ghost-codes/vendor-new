import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/branchesViewModel.dart';

class EditBranchViewModel extends BaseModel {
  Api _api = sl<Api>();

  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;

  bool isNameenabled = false;
  bool isLocationenabled = false;
  bool isDescenabled = false;
  bool isImageHovered = false;
  bool deleteImage = false;
  bool isimageUploading = false;

  bool isNameLoading = false;
  bool isLocationLoading = false;
  bool isDesLoading = false;
  bool isImageReadyForUpload = false;
  bool isDeleting = false;
  bool isDoneUploadingImage = false;

  TextEditingController nameController;
  TextEditingController locationController;
  TextEditingController descController;

  TextEditingController deleteController = TextEditingController();

  BranchModel branchModel;
  bool isDelete = false;

  setIsImageHovered(value) {
    isImageHovered = value;
    notifyListeners();
  }

  init(BranchModel x) {
    branchModel = x;
    nameController = TextEditingController(text: x.branchName);
    locationController = TextEditingController(text: x.location);
    descController = TextEditingController(text: x.description);

    notifyListeners();
  }

  uploadNewLogo() async {
    isimageUploading = true;
    var response = await _api.updateBranch(
      branchDetails: {"logo": MultipartFile.fromFileSync(myFile.files[0].path)},
      branchId: branchModel.id,
    );

    if (response) {
      isImageReadyForUpload = false;
      isDoneUploadingImage = true;
    }
    isimageUploading = false;
    notifyListeners();
  }

  onClearImage() {
    imageFile = null;
    imageOutput = null;
    deleteImage = true;
    notifyListeners();
  }

  setEnablename() async {
    if (isNameenabled) {
      isNameLoading = true;
      notifyListeners();

      var response = await _api.updateBranch(
        branchDetails: {
          "name": nameController.text,
        },
        branchId: branchModel.id,
      );
      isNameLoading = false;
    }
    isNameenabled = !isNameenabled;
    notifyListeners();
  }

  setEnableLoc() async {
    if (isLocationenabled) {
      isLocationLoading = true;
      notifyListeners();

      var response = await _api.updateBranch(
        branchDetails: {
          "location": locationController.text,
        },
        branchId: branchModel.id,
      );

      isLocationLoading = false;
    }
    isLocationenabled = !isLocationenabled;
    notifyListeners();
  }

  setEnableDesc() async {
    if (isDescenabled) {
      isDesLoading = true;
      notifyListeners();
      var response = await _api.updateBranch(
        branchDetails: {
          "description": descController.text,
        },
        branchId: branchModel.id,
      );

      isDesLoading = false;
    }
    isDescenabled = !isDescenabled;

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

  onSave(BuildContext context) async {
    if (imageOutput == null && deleteImage) {
      var response = await _api.updateBranch(
        branchDetails: {"logo": ""},
        branchId: branchModel.id,
      );

      if (response) {
        Navigator.of(context).pop(true);
      }
    } else {
      Navigator.of(context).pop(true);
    }
  }

  setIsDelete(x) {
    isDelete = x;
    notifyListeners();
  }

  onDelete(BuildContext context, String vendorUsername) async {
    isDeleting = true;
    notifyListeners();
    var response = await _api.deleteBranch(
        cred: {"password": deleteController.text}, branchId: branchModel.id);

    if (response) {
      Navigator.of(context).pop(true);
    }
  }
}
