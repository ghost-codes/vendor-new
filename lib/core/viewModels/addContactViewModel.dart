import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import '../locator.dart';

class AddContactViewModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;

  bool isLoading = false;
  bool isImageHovered = false;
  bool isAutoTrackConsignment = false;
  bool trackExpiry = false;
  bool isPartitionable = false;

  final formKey = GlobalKey<FormState>();

  Api _api = sl<Api>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

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
        "email": email.text,
        "photo": myFile != null
            ? MultipartFile.fromFileSync(myFile.files[0].path)
            : null
      };
      var response = await _api.addContact(submitMap);

      if (response) {
        Navigator.of(context).pop(true);
      } else {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
