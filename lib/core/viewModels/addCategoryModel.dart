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

class AddCategoryModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;

  bool isLoading = false;

  Api _api = sl<Api>();

  bool isImageReadyForUpload = false;
  bool isEnd = true;
  bool isImageHovered = false;

  TextEditingController nameController = TextEditingController();

  TextEditingController descController = TextEditingController();

  onImageSelect() async {
    Directory tempDir = (await getApplicationDocumentsDirectory());

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

  void onDropDownChanged(value) {
    isEnd = value;
    notifyListeners();
  }

  onSubmit(BuildContext context, String branchId, String categoryId) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> submitMap = {
      "name": nameController.text,
      "is_end": isEnd ? 1 : 0,
      "description": descController.text,
      "image": myFile != null
          ? MultipartFile.fromFileSync(myFile.files[0].path)
          : "",
      // "branch_id": branchId,
      "category_id": categoryId
    };

    var response = await _api.addProductCategory(submitMap);

    if (await response) {
      Navigator.of(context).pop(true);
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
