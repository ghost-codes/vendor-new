import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import '../locator.dart';

class AddProductViewModel extends BaseModel {
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
  TextEditingController batchCode = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController unitCostPrice = TextEditingController();
  TextEditingController unitMinimumPrice = TextEditingController();
  TextEditingController unitSellingPrice = TextEditingController();

  onIsPartitionChanged(bool value) {
    isPartitionable = value;
    notifyListeners();
  }

  isAutoTrackConsignmentChanged(bool value) {
    isAutoTrackConsignment = value;
    notifyListeners();
  }

  isTrackExpiryChanged(bool value) {
    trackExpiry = value;
    notifyListeners();
  }

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
    // Directory tempDir = (await getApplicationDocumentsDirectory());
    myFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    imageOutput = File(myFile.files[0].path).readAsBytesSync();
    notifyListeners();
  }

  onSubmit(BuildContext context, String categoryId) async {
    if (formKey.currentState.validate()) {
      isLoading = true;
      notifyListeners();
      Map<String, dynamic> submitMap = {
        "category": categoryId,
        "name": nameController.text,
        "batch_code": batchCode.text,
        "description": descController.text,
        "auto_track_consignment": isAutoTrackConsignment,
        // "track_expiry": trackExpiry ? 1 : 0,
        "unit_cost_price": double.parse(unitCostPrice.text),
        "unit_minimum_selling_price": double.parse(unitMinimumPrice.text),
        "unit_selling_price": unitSellingPrice.text == ''
            ? ''
            : double.parse(unitSellingPrice.text),
        // "image": '',
        "image": myFile != null
            ? MultipartFile.fromFileSync(myFile.files[0].path)
            : null
      };

      var response = await _api.createProduct(submitMap);

      if (response) {
        Navigator.of(context).pop(true);
      } else {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  String requiredFieldValidator(String value) {
    if (value.length == 0) {
      return "Please Enter Field";
    } else {
      return null;
    }
  }

  String numberInputValidator(String value) {
    double errMessage;
    errMessage = double.tryParse(value);

    return errMessage == null ? "Please input a number" : null;
  }

  String requiredNumbervalidator(String value) {
    String errMessage;
    errMessage = requiredFieldValidator(value);
    if (errMessage != null) {
      return errMessage;
    }
    errMessage = numberInputValidator(value);
    return errMessage;
  }
}
