import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class CreateConsignmentViewModel extends BaseModel {
  Api _api = sl<Api>();

  bool isProductsLoading = false;
  bool isReferenceInputPage = false;

  bool isLoading = false;

  List consignmentList = [];
  List<ProductModel> products = [];
  List<ProductModel> productsDisplay = [];

  TextEditingController referenceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  init(String branchId) async {
    isProductsLoading = true;
    notifyListeners();
    products = await _api.allProductsList(branchId);
    productsDisplay = products;
    isProductsLoading = false;
    notifyListeners();
  }

  onSearch(String value) {
    var regExp = RegExp("\w*$value\w*", caseSensitive: false);
    if (value == "") {
      productsDisplay = products;
    } else {
      productsDisplay = products.where((element) {
        return regExp.hasMatch(element.name);
      }).toList();
    }

    notifyListeners();
  }

  setIsReferenceInputPage() {
    isReferenceInputPage = !isReferenceInputPage;
    notifyListeners();
  }

  updateOrderList(ProductModel product) {
    if (consignmentList
            .every((element) => element["product"].id != product.id) ||
        consignmentList.length == 0) {
      consignmentList.add(
          {"product": product, "controller": TextEditingController(text: "1")});
    }
    notifyListeners();
  }

  onClearList() {
    consignmentList = [];
    notifyListeners();
  }

  onCreateConsignment(String branchId, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    List consigned_products = consignmentList
        .map((e) => {
              "product": e["product"].id,
              "quantity_consigned": double.parse(e["controller"].text)
            })
        .toList();
    Map<String, dynamic> consignment = {
      "branch": branchId,
      "reference": referenceController.text,
      "consigned_products": consigned_products,
      "description": descriptionController.text,
    };
    bool result = await _api.createConsignment(consignment);
    if (result) {
      Navigator.of(context).pop(true);
    }
    isLoading = false;
    notifyListeners();
  }

  removeFromOrderList(int index) {
    consignmentList.removeAt(index);
    notifyListeners();
  }
}
