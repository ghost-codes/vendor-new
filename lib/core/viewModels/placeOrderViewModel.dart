import 'package:flutter/material.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/ui/widgets/placeOrder.dart';

class PlaceOrderModel extends BaseModel {
  Api _api = sl<Api>();

  bool isProductsLoading = false;
  bool isReferenceInputPage = false;
  bool isDiscountPercentage = false;

  bool isLoading = false;

  List<ProductModel> products = [];
  List<ProductModel> productsDisplay = [];

  TextEditingController referenceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discount = TextEditingController(text: "0");

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

  onIsDiscountPercentageChanged(bool value) {
    isDiscountPercentage = value;
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

  onPlaceOrder(String branchId, context) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> order = {
      "branch": branchId,
      "name": referenceController.text,
      "client_phone": descriptionController.text,
      "discount_is_percentage": isDiscountPercentage ? 1 : 0,
      "discount": discount.text,
      "order_items": orderList
          .map((e) => {
                "item_id": e.product.id,
                "type": e.type,
                "name": e.product.name + " " + e.tag,
                "price": double.parse(e.price.text),
                "quantity": double.parse(e.quantity.text)
              })
          .toList()
    };
    bool result = await _api.placeOrder(order);
    if (result) {
      Navigator.of(context).pop(true);
    }
    isLoading = false;
    notifyListeners();
  }
}

class PlaceOrderItemModel {
  TextEditingController price;
  TextEditingController quantity;
  String tag = "";
  ProductModel product;
  String name = "";
  int type = 0;

  PlaceOrderItemModel(ProductModel product) {
    this.product = product;
    name = product.name;
    quantity = TextEditingController(
      text: "1",
    );
    price = TextEditingController(text: product.unitSellingPrice.toString());
  }
}
