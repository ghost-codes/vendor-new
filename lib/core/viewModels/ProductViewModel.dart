import 'package:flutter/material.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/productCategoryModel.dart';
import 'package:vendoorr/core/models/productHistoryModel.dart';

import 'package:vendoorr/core/models/productModel.dart';

import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/ui/widgets/productCategory.dart';
import 'package:vendoorr/ui/widgets/productList.dart';

import '../locator.dart';

class ProductViewModel extends BaseModel {
  Api _api = sl<Api>();
  List<ProductCategoryModel> categoryIds = [];

  bool isLoading = false;
  bool showUpdateStock = false;
  bool isAllProducts = false;
  bool isProductDetail = false;
  bool isProductHistoryLoading = false;

  ProductModel selectedProduct;
  List<ProductHistoryModel> selectedProductHistoryModel = [];

  dynamic currentData;
  dynamic currentDisplayData;

  ProductCategoryModel currentCategory;

  getRootCategory(String branchId) async {
    isLoading = true;
    notifyListeners();

    var response = await _api.productCategoriesApi(branchId);

    if (response is Map) {
      currentData = response['sub_items']
          .map((category) => ProductCategoryModel.fromJson(category))
          .toList();
    } else {
      currentData = [];
    }
    isLoading = false;
    notifyListeners();
  }

  getProductDetails(String product_id) async {
    isProductHistoryLoading = true;
    notifyListeners();
    selectedProductHistoryModel = await _api.getProdHistory(product_id);
    isProductHistoryLoading = false;
    notifyListeners();
  }

  onProductUpdate() {
    showUpdateStock = !showUpdateStock;
    notifyListeners();
  }

  setIsProductDetail(bool value,
      {@required bool canManageProduct,
      ProductModel product,
      bool reload = false}) async {
    isProductDetail = value;
    if (value) onSearchClear();
    if (product != null) {
      selectedProduct = product;
      if (canManageProduct) getProductDetails(product.id);
    }
    notifyListeners();
    if (reload) {
      isLoading = true;
      notifyListeners();
      String previousCategoryId = currentCategory.id;
      var response = await _api.productCategoriesApi(previousCategoryId);

      if (response['sub_items'] is List) {
        currentData = response['sub_items']
            .map((category) => ProductModel.fromJson(category))
            .toList();
        if (value && (currentData is List)) {
          selectedProduct = currentData
              .singleWhere((element) => element.id == selectedProduct.id);
        }
      }

      isLoading = false;
      notifyListeners();
    }
  }

  onProductSearch(String value) {
    var regExp = RegExp("\w*$value\w*", caseSensitive: false);
    if (value == "") {
      currentDisplayData = currentData;
    } else {
      currentDisplayData = currentData.where((element) {
        return regExp.hasMatch(element.name);
      }).toList();
    }
    notifyListeners();
  }

  onSearchClear() {
    currentDisplayData = currentData;
    notifyListeners();
  }

  onSelectedCategory(ProductCategoryModel category) async {
    isLoading = true;
    notifyListeners();
    var response = await _api.productCategoriesApi(category.id);

    if (response is Map && response['sub_items'] is List) {
      if (category.isEnd) {
        categoryIds.add(category);

        currentCategory = category;

        currentData =
            response['sub_items'].map((e) => ProductModel.fromJson(e)).toList();
        currentDisplayData = currentData;
      } else {
        categoryIds.add(category);

        currentCategory = category;

        currentData = response['sub_items']
            .map((e) => ProductCategoryModel.fromJson(e))
            .toList();
      }
    } else {
      currentData = [];
    }
    isLoading = false;
    notifyListeners();
  }

  onAllProductsSelected(String branchId) async {
    isLoading = true;
    notifyListeners();
    currentData = await _api.allProductsList(branchId);
    currentDisplayData = currentData;

    if (currentData is List<ProductModel>) {
      isAllProducts = true;
    }
    isLoading = false;

    notifyListeners();
  }

  refresh(String branchId) async {
    isLoading = true;
    print(branchId);

    notifyListeners();

    if (currentCategory != null) {
      var response = await _api.productCategoriesApi(currentCategory.id);

      if (response is Map && response['sub_items'] is List) {
        if (currentCategory.isEnd) {
          currentData = response['sub_items']
              .map((e) => ProductModel.fromJson(e))
              .toList();
        } else {
          currentData = response['sub_items']
              .map((e) => ProductCategoryModel.fromJson(e))
              .toList();
        }
      } else {
        currentData = [];
      }
    } else if (isAllProducts) {
      print("hell");
      await onAllProductsSelected(branchId);
    } else {
      await getRootCategory(branchId);
    }
    isLoading = false;

    notifyListeners();
  }

  refreshCategory(String branchId) async {
    isLoading = true;
    notifyListeners();
    String previousCategoryId =
        currentCategory == null ? branchId : currentCategory.id;
    var response = await _api.productCategoriesApi(previousCategoryId);

    if (response is Map && response['sub_items'] is List) {
      currentData = response['sub_items']
          .map((category) => ProductCategoryModel.fromJson(category))
          .toList();
    } else {
      currentData = [];
    }

    isLoading = false;
    notifyListeners();
  }

  productDetailsRefresh(String branchId) async {
    isLoading = true;
    notifyListeners();
    String previousCategoryId =
        currentCategory == null ? branchId : currentCategory.id;
    var response = await _api.productCategoriesApi(previousCategoryId);

    if (response['sub_items'] is List) {
      currentData = response['sub_items']
          .map((category) => ProductCategoryModel.fromJson(category))
          .toList();
    }

    isLoading = false;
    notifyListeners();
  }

  onBackPressed(String branchId) async {
    isLoading = true;
    notifyListeners();
    String previousCategoryId;
    if (isAllProducts) {
      previousCategoryId = branchId;
      var response = await _api.productCategoriesApi(previousCategoryId);

      if (response is Map<String, dynamic> && response['sub_items'] is List) {
        currentCategory = null;

        currentData = response['sub_items']
            .map((category) => ProductCategoryModel.fromJson(category))
            .toList();
      } else {
        currentData = [];
      }
      isAllProducts = false;
    } else {
      previousCategoryId = categoryIds.length - 2 < 0
          ? branchId
          : categoryIds[categoryIds.length - 2].id;

      var response = await _api.productCategoriesApi(previousCategoryId);

      categoryIds.removeLast();
      currentCategory = categoryIds.length == 0 ? null : categoryIds.last;
      if (response is Map<String, dynamic> && response['sub_items'] is List) {
        currentData = response['sub_items']
            .map((category) => ProductCategoryModel.fromJson(category))
            .toList();
      } else {
        currentData = [];
      }
      // if (response['sub_items'] is List) {

      //   currentData = response['sub_items']
      //       .map((category) => ProductCategoryModel.fromJson(category))
      //       .toList();
      // }
    }
    isLoading = false;
    notifyListeners();
  }
}
