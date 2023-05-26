import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/productCategoryModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/branchesViewModel.dart';

class EditCategoryModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;
  ProductCategoryModel category;

  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();

  bool isImageHovered = false;

  bool isLoading = false;

  Api _api = sl<Api>();

  bool isEnd = true;
  bool isDelete = false;
  bool isDeleting = false;
  bool deleteImage = false;
  bool isImageReadyForUpload = false;
  bool isDoneUploadingImage = false;
  bool isimageUploading = false;

  bool isDescenabled = false;
  bool isDesLoading = false;
  bool isNameenabled = false;
  bool isNameLoading = false;

  String assignedPrinter = "Printer A";
  String prevPrinter = '';

  List<String> printerVars = [];

  Map<String, dynamic> printerA = {};
  Map<String, dynamic> printerB = {};
  Map<String, dynamic> printerC = {};
  Map<String, dynamic> printerD = {};
  Map<String, dynamic> printerE = {};

  TextEditingController nameController;
  TextEditingController deleteController = TextEditingController();
  TextEditingController descController;

  init(ProductCategoryModel x) async {
    category = x;
    nameController = TextEditingController(text: x.name);
    isEnd = x.isEnd;
    descController = TextEditingController(text: x.description);

    printerA = json.decode((await sharedPref.getStringValuesSF("Printer A")) ??
        """{"url": "", "categories": []}""");
    printerB = json.decode((await sharedPref.getStringValuesSF("Printer B")) ??
        """{"url": "", "categories": []}""");
    printerC = json.decode((await sharedPref.getStringValuesSF("Printer C")) ??
        """{"url": "", "categories": []}""");
    printerD = json.decode((await sharedPref.getStringValuesSF("Printer D")) ??
        """{"url": "", "categories": []}""");
    printerE = json.decode((await sharedPref.getStringValuesSF("Printer E")) ??
        """{"url": "", "categories": []}""");

    notifyListeners();

    // Check which printer has the category id
    if (printerA["categories"] != null &&
        printerA["categories"].contains(x.id)) {
      assignedPrinter = "Printer A";
      prevPrinter = "Printer A";
    } else if (printerB["categories"] != null &&
        printerB["categories"].contains(x.id)) {
      assignedPrinter = "Printer B";
      prevPrinter = "Printer B";
    } else if (printerC["categories"] != null &&
        printerC["categories"].contains(x.id)) {
      assignedPrinter = "Printer C";
      prevPrinter = "Printer C";
    } else if (printerD["categories"] != null &&
        printerD["categories"].contains(x.id)) {
      assignedPrinter = "Printer D";
      prevPrinter = "Printer D";
    } else if (printerE["categories"] != null &&
        printerE["categories"].contains(x.id)) {
      assignedPrinter = "Printer E";
      prevPrinter = "Printer E";
    } else {
      assignedPrinter = "Printer A";
      prevPrinter = "Printer A";
    }

    // ddd

    if (printerA["url"] != "") {
      printerVars.add("Printer A");
    }
    if (printerB["url"] != "") {
      printerVars.add("Printer B");
    }
    if (printerC["url"] != "") {
      printerVars.add("Printer C");
    }
    if (printerD["url"] != "") {
      printerVars.add("Printer D");
    }
    if (printerE["url"] != "") {
      printerVars.add("Printer E");
    }

    notifyListeners();
  }

  onChange(String value) {
    assignedPrinter = value;
    notifyListeners();
  }

  setIsDelete() {
    isDelete = !isDelete;
    notifyListeners();
  }

  onSave(BuildContext context) async {
    ///dd

    if (printerA["categories"] == null) {
      printerA["categories"] = [];
    }
    if (printerB["categories"] == null) {
      printerB["categories"] = [];
    }
    if (printerC["categories"] == null) {
      printerC["categories"] = [];
    }
    if (printerD["categories"] == null) {
      printerD["categories"] = [];
    }
    if (printerE["categories"] == null) {
      printerE["categories"] = [];
    }

    if (printerA["url"] == null) {
      printerA["url"] = '';
    }
    if (printerB["url"] == null) {
      printerB["url"] = '';
    }
    if (printerC["url"] == null) {
      printerC["url"] = '';
    }
    if (printerD["url"] == null) {
      printerD["url"] = '';
    }
    if (printerE["url"] == null) {
      printerE["url"] = '';
    }

    switch (prevPrinter) {
      case "Printer A":
        printerA["categories"].remove(category.id);
        break;
      case "Printer B":
        printerB["categories"].remove(category.id);
        break;
      case "Printer C":
        printerC["categories"].remove(category.id);
        break;
      case "Printer D":
        printerD["categories"].remove(category.id);
        break;
      case "Printer E":
        printerE["categories"].remove(category.id);
        break;
    }
    switch (assignedPrinter) {
      case "Printer A":
        printerA["categories"].add(category.id);
        break;
      case "Printer B":
        printerB["categories"].add(category.id);
        break;
      case "Printer C":
        printerC["categories"].add(category.id);
        break;
      case "Printer D":
        printerD["categories"].add(category.id);
        break;
      case "Printer E":
        printerE["categories"].add(category.id);
        break;
    }

    if (imageOutput == null && deleteImage) {
      var response =
          await _api.updateProductCategory({"image": ""}, category.id);

      if (response) {
        Navigator.of(context).pop(true);
      }
    } else {
      Navigator.of(context).pop(true);
    }
    await sharedPref.addStringToSF(
        key: "Printer A", value: json.encode(printerA));
    await sharedPref.addStringToSF(
        key: "Printer B", value: json.encode(printerB));
    await sharedPref.addStringToSF(
        key: "Printer C", value: json.encode(printerC));
    await sharedPref.addStringToSF(
        key: "Printer D", value: json.encode(printerD));
    await sharedPref.addStringToSF(
        key: "Printer E", value: json.encode(printerE));
  }

  onDelete(BuildContext context) async {
    isDeleting = true;
    notifyListeners();
    var response = await _api.deleteCategory(
        cred: {"password": deleteController.text}, categoryId: category.id);

    if (response) {
      Navigator.of(context).pop(true);
    }
  }

  setIsImageHovered(value) {
    isImageHovered = value;
    notifyListeners();
  }

  imageSubmit(String categoryId) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> submitMap = {
      "image": MultipartFile.fromFileSync(myFile.files[0].path),
    };

    var response = await _api.updateProductCategory(submitMap, categoryId);

    if (response) {
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  onClearImage() {
    imageFile = null;
    imageOutput = null;
    deleteImage = true;
    notifyListeners();
  }

  uploadNewLogo() async {
    isimageUploading = true;
    notifyListeners();
    var response = await _api.updateProductCategory(
        {"image": MultipartFile.fromFileSync(myFile.files[0].path)},
        category.id);

    if (response) {
      isImageReadyForUpload = false;
      isDoneUploadingImage = true;
    }
    isimageUploading = false;
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

  void onDropDownChanged(value) {
    isEnd = value;
    notifyListeners();
  }

  setEnableDesc() async {
    if (isDescenabled) {
      isDesLoading = true;
      notifyListeners();
      var response = await _api.updateProductCategory({
        "description": descController.text,
      }, category.id);

      isDesLoading = false;
    }
    isDescenabled = !isDescenabled;

    notifyListeners();
  }

  setEnablename() async {
    if (isNameenabled) {
      isNameLoading = true;
      notifyListeners();

      var response = await _api
          .updateProductCategory({"name": nameController.text}, category.id);
      isNameLoading = false;
    }
    isNameenabled = !isNameenabled;
    notifyListeners();
  }

  onSubmit(BuildContext context, String categoryId) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> submitMap = {
      "name": nameController.text,
      "is_end": isEnd ? 1 : 0,
      "description": descController.text,
      "image": myFile != null
          ? MultipartFile.fromFileSync(myFile.files[0].path)
          : "",
    };

    var response = await _api.updateProductCategory(submitMap, categoryId);

    if (response) {
      Navigator.of(context).pop(true);
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
