import 'package:flutter/material.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/placeOrderViewModel.dart';
import 'package:vendoorr/ui/widgets/placeOrder.dart';

class AddItemViewModel extends BaseModel {
  Api _api = sl<Api>();

  bool isProductsLoading = false;
  bool isReferenceInputPage = false;

  bool isLoading = false;

  List<ProductModel> products = [];
  List<ProductModel> productsDisplay = [];

  TextEditingController referenceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<PlaceOrderItemModel> orderList = [];

  init(String branchId) async {
    isProductsLoading = true;
    products = await _api.allProductsList(branchId);
    productsDisplay = products;
    // if (result != null) {
    //   products = result.map((e) => ProductModel.fromJson(e)).toList();
    //   productsDisplay = products;
    // }
    isProductsLoading = false;
    notifyListeners();
  }

  onClearList() {
    orderList = [];
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

  onTag(String value, int index) {
    orderList[index].tag = value;
    notifyListeners();
  }

  updateOrderList(ProductModel product) {
    if (product.autoTrackConsignment && product.quantityRemaining == 0)
      return null;
    PlaceOrderItemModel orderItem = PlaceOrderItemModel(product);
    if (orderList
        .every((element) => (element.name + element.tag) != orderItem.name)) {
      orderList.add(orderItem);
    }
    notifyListeners();
  }

  removeFromOrderList(int index) {
    orderList.removeAt(index);
    notifyListeners();
  }

  onPlaceOrder(String order_id, context) async {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> order = orderList
        .map((e) => {
              "item_id": e.product.id,
              "type": e.type,
              "name": e.product.name + " " + e.tag,
              "client_phone": descriptionController.text,
              "price": double.parse(e.price.text),
              "quantity": double.parse(e.quantity.text)
            })
        .toList();
    OrderModel result = await _api.addItems(order, order_id);
    if (result != null) {
      Navigator.of(context).pop(result);
    }
    isLoading = false;
    notifyListeners();
  }
}
