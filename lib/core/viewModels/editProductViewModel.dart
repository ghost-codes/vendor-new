import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class EditProductViewModel extends BaseModel {
  File imageFile;
  Uint8List imageOutput;
  FilePickerResult myFile;
  String productId = '';

  ProductModel product;

  bool isLoading = false;
  bool isImageHovered = false;
  bool isAutoTrackConsignment = false;
  bool trackExpiry = false;

  bool isNameEnabled = false;
  bool isBatchCodeEnabled = false;
  bool isdescEnvled = false;
  bool isUnitCostPriceEnabled = false;
  bool isUnitMinimumPriceEnabled = false;
  bool isUnitSellingPriceEnabled = false;

  bool isDescLoading = false;
  bool isBatchCodeLoading = false;
  bool isNameLoading = false;
  bool isUnitCPLoading = false;
  bool isUnitMPLoading = false;
  bool isUnitSPLoading = false;
  bool deleteImage = false;
  bool isAutoTrackLoading = false;

  bool isImageReadyForUpload = false;
  bool isDoneUploadingImage = false;
  bool isimageUploading = false;

  bool isDelete = false;

  Api _api = sl<Api>();

  TextEditingController nameController = TextEditingController();
  TextEditingController batchCode = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController unitCostPrice = TextEditingController();
  TextEditingController unitMinimumPrice = TextEditingController();
  TextEditingController unitSellingPrice = TextEditingController();

  initModel(ProductModel productModel) {
    isAutoTrackConsignment = productModel.autoTrackConsignment ?? false;
    unitSellingPrice.text = productModel.unitSellingPrice;
    unitCostPrice.text = productModel.unitCostPrice;
    unitMinimumPrice.text = productModel.unitMinimumPrice;
    descController.text = productModel.description;
    nameController.text = productModel.name;
    batchCode.text = productModel.batchCode;
    product = productModel;
    notifyListeners();
  }

  setForDelete() {
    isDelete = !isDelete;
    notifyListeners();
  }

  Future<bool> onDelete() async {
    isLoading = true;
    notifyListeners();
    bool done = await _api.deleteProduct(product.id);
    isLoading = false;
    notifyListeners();
    return done;
  }

  onClearImage() {
    imageFile = null;
    imageOutput = null;
    deleteImage = true;
    notifyListeners();
  }

  onSave(BuildContext context) {
    if (!(isNameEnabled ||
        isdescEnvled ||
        isUnitCostPriceEnabled ||
        isUnitSellingPriceEnabled ||
        isBatchCodeEnabled ||
        isUnitMinimumPriceEnabled)) {
      Navigator.of(context).pop({"isDeleted": false, "reload": true});
    }
  }

  editDesc() async {
    if (isdescEnvled) {
      isDescLoading = true;
      notifyListeners();
      var response = await _api.updateProduct(
        map: {
          "description": descController.text,
        },
        product_id: product.id,
      );

      isDescLoading = false;
    }
    isdescEnvled = !isdescEnvled;

    notifyListeners();
  }

  editName() async {
    if (isNameEnabled) {
      isNameLoading = true;
      notifyListeners();
      var response = await _api.updateProduct(
        map: {
          "name": nameController.text,
        },
        product_id: product.id,
      );

      isNameLoading = false;
    }
    isNameEnabled = !isNameEnabled;
    notifyListeners();
  }

  editBatchCode() async {
    if (isBatchCodeEnabled) {
      isBatchCodeLoading = true;
      notifyListeners();
      var response = await _api.updateProduct(
        map: {
          "batch_code": batchCode.text,
        },
        product_id: product.id,
      );

      isBatchCodeLoading = false;
    }
    isBatchCodeEnabled = !isBatchCodeEnabled;

    notifyListeners();
  }

  editCostPrice() async {
    if (isUnitCostPriceEnabled) {
      isUnitCPLoading = true;
      notifyListeners();
      var response = await _api.updateProduct(
        map: {
          "unit_cost_price": double.parse(unitCostPrice.text),
        },
        product_id: product.id,
      );

      isUnitCPLoading = false;
    }
    isUnitCostPriceEnabled = !isUnitCostPriceEnabled;

    notifyListeners();
  }

  editMiniPrice() async {
    if (isUnitMinimumPriceEnabled) {
      isUnitMPLoading = true;
      notifyListeners();
      var response = await _api.updateProduct(
        map: {
          "unit_minimum_selling_price": double.parse(unitMinimumPrice.text),
        },
        product_id: product.id,
      );

      isUnitMPLoading = false;
    }
    isUnitMinimumPriceEnabled = !isUnitMinimumPriceEnabled;

    notifyListeners();
  }

  editSellingPrice() async {
    if (isUnitSellingPriceEnabled) {
      isUnitSPLoading = true;
      notifyListeners();
      var response = await _api.updateProduct(
        map: {
          "unit_selling_price": double.parse(unitSellingPrice.text),
        },
        product_id: product.id,
      );

      isUnitSPLoading = false;
    }
    isUnitSellingPriceEnabled = !isUnitSellingPriceEnabled;

    notifyListeners();
  }

  isAutoTrackConsignmentChanged(bool value) async {
    isAutoTrackLoading = true;
    notifyListeners();

    var response = await _api.updateProduct(
        map: {"auto_track_consignment": value ? 1 : 0}, product_id: product.id);

    if (response) {
      isAutoTrackConsignment = value;
    }
    isAutoTrackLoading = false;
    notifyListeners();
  }

  isTrackExpiryChanged(bool value) {
    trackExpiry = value;
    notifyListeners();
  }

  setIsImageHovered(value) {
    isImageHovered = value;
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

  uploadNewImage() async {
    isimageUploading = true;
    notifyListeners();
    var response = await _api.updateProduct(
        map: {"image": MultipartFile.fromFileSync(myFile.files[0].path)},
        product_id: product.id);

    if (response) {
      isImageReadyForUpload = false;
      isDoneUploadingImage = true;
    }
    isimageUploading = false;
    notifyListeners();
  }

  onSubmit(BuildContext context, String categoryId) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> submitMap = {
      "category": categoryId,
      "name": nameController.text,
      "batch_code": batchCode.text,
      "description": descController.text,
      "auto_track_consignment": isAutoTrackConsignment ? 1 : 0,
      "track_expiry": trackExpiry ? 1 : 0,
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
