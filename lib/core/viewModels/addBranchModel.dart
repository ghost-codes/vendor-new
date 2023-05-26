import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/branchesViewModel.dart';

class AddBranchModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;

  bool isLoading = false;
  bool isImageHovered = false;

  Api _api = sl<Api>();

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descController = TextEditingController();

  onClearImage() {
    imageFile = null;
    imageOutput = null;

    notifyListeners();
  }

  setIsImageHovered(value) {
    isImageHovered = value;
    notifyListeners();
  }

  onImageSelect() async {
    Directory tempDir = (await getApplicationDocumentsDirectory());
    myFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    imageOutput = File(myFile.files[0].path).readAsBytesSync();
    notifyListeners();
  }

  onSubmit(BuildContext context, String vendorUsername) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> submitMap = {
      "name": nameController.text,
      "location": locationController.text,
      "description": descController.text,
      "logo": myFile != null
          ? MultipartFile.fromFileSync(myFile.files[0].path)
          : null
    };

    // if (myFile != null) {
    //   submitMap.addAll({"logo": MultipartFile.fromFileSync(myFile.path)});
    // }

    var response = await _api.addBranch(
        submitMap, imageOutput == null ? null : imageOutput.toList());

    if (response) {
      Navigator.of(context).pop(true);
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
