import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:vendoorr/core/constants.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/models/consignmentModel.dart';
import 'package:vendoorr/core/models/contactModel.dart';
import 'package:vendoorr/core/models/analysisTransactionModel.dart';
import 'package:vendoorr/core/models/expenseModel.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/models/popUpModel.dart';
import 'package:vendoorr/core/models/productHistoryModel.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/models/productSummaryData.dart';
import 'package:vendoorr/core/models/saleModel.dart';
import 'package:vendoorr/core/models/salesQueryResponse.dart';
import 'package:vendoorr/core/models/staffModel.dart';
import 'package:vendoorr/core/models/tabModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/models/userRoleEditmodel.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/util/tokenConfig.dart';

class Api {
  http.Client client = http.Client();
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();

  Dio dio = Dio(BaseOptions(baseUrl: Constants.API_HOST));

  StreamController<bool> authListener = StreamController.broadcast();
  Sink<bool> get authSink => authListener.sink;
  Stream<bool> get authStream => authListener.stream;

  StreamController<bool> slowInternetPopup = StreamController<bool>.broadcast();
  Sink<bool> get slowInternetPopupSink => slowInternetPopup.sink;
  Stream<bool> get slowInternetPopupStream => slowInternetPopup.stream;

  StreamController<PopUp> snackBarController =
      StreamController<PopUp>.broadcast();
  Sink<PopUp> get snackBarSink => snackBarController.sink;
  Stream<PopUp> get snackBarStream => snackBarController.stream;

  disposeStreams() {
    authListener.close();
    slowInternetPopup.close();
    snackBarController.close();
  }

  Api() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (res, handler) {
          slowInternetPopupSink.add(false);
          handler.next(res);
        },
        onError: (err, handler) async {
          if (err.error != null && err.type == DioErrorType.other) {
            if (err.error is SocketException) {
              try {
                final opts = new Options(
                    method: err.requestOptions.method,
                    headers: err.requestOptions.headers);

                slowInternetPopupSink.add(true);
                // snackBarSink.add(PopUp(
                //     type: PopUpType.error,
                //     message: "Slow or No internet Connectivity"));
                final cloneReq = await dio.request(err.requestOptions.path,
                    options: opts,
                    data: err.requestOptions.data,
                    queryParameters: err.requestOptions.queryParameters);
                return handler.resolve(cloneReq);
              } catch (e) {
                print(e);
              }
              // } else if (err.error is HttpException) {
            } else {
              try {
                final opts = new Options(
                    method: err.requestOptions.method,
                    headers: err.requestOptions.headers);
                final cloneReq = await dio.request(err.requestOptions.path,
                    options: opts,
                    data: err.requestOptions.data,
                    queryParameters: err.requestOptions.queryParameters);
                return handler.resolve(cloneReq);
              } catch (e) {
                print(e);
              }
            }
          }
          handler.next(err);
        },
      ),
    );
  }

  snackHandler(String message, PopUpType type) {
    snackBarSink.add(PopUp(type: type, message: message, action: true));
    final myTime = Timer(Duration(seconds: 3), () {
      snackBarSink.add(PopUp(type: type, message: message, action: false));
    });
  }

  errorHandler(dynamic err) async {
    print(err);
    print(err.response.data);
    if (err is DioError) {
      // (err.response == HttpException);
      if (err.error != null &&
          err.type == DioErrorType.other &&
          err.error is SocketException) {
      } else if (err is DioError && err.type == DioErrorType.other) {
        snackHandler("Error occured", PopUpType.error);
      } else if (err.response.statusCode == 401) {
        snackHandler("Authentication error", PopUpType.error);
        logout();
      } else {
        snackHandler(err.response.data, PopUpType.error);
      }
    } else {
      snackBarSink.add(PopUp(
          message: "Error Occurred", action: false, type: PopUpType.error));
    }
  }

  logout() async {
    try {
      Map<String, String> token = await tokenConfig();
      http.Response response = await client.post(
          Uri.parse("${Constants.API_HOST}/users/logout/"),
          headers: token);

      if ((response.statusCode >= 200 && response.statusCode <= 300) ||
          response.statusCode == 401) {
        authSink.add(true);
      }
    } catch (e) {
      errorHandler(e);
    }
  }

  Future<bool> _internetConnect() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      return false;
    }
  }

  Future<UserModel> loginApi(Map<String, String> userCred) async {
    try {
      http.Response response = await client.post(
          Uri.parse("${Constants.API_HOST}/users/login/"),
          body: userCred);

      //on successful login store token and userModel String in SharedPreferences
      if (response.statusCode >= 200 && response.statusCode < 300) {
        //Authentication token
        await sharedPref.addStringToSF(
            key: "token", value: json.decode(response.body)["token"]);
        //Json UserModel
        await sharedPref.addStringToSF(
            key: "userModel",
            value: json.encode(json.decode(response.body)["user"]));
        // snackBarSink.add({"content": "hey"});
        print(json.encode(json.decode(response.body)["user"]));
        return UserModel.fromJson(json.decode(response.body)["user"]);
      } else if (response.statusCode == 401) {
        return Future.error("Unauthorized: Invalid Credentials");
      } else {
        return Future.error("Internal Server Error");
      }
    } catch (e) {
      return Future.error("Error: Please check Internet Connectivity");
    }
  }

  Future<List> utilityInfo(String vendor_username) async {
    Map<String, String> token = await tokenConfig();
    Map<String, String> utilityEndpoints = {
      "Branches": "/branches/branch/${vendor_username}/branches_count/",
      "Products": "/products/product/${vendor_username}/products_count/",
      "Staff": "/staff/staff/${vendor_username}/staff_count/",
      "Sales": "/records/sale/${vendor_username}/sales_count/",
    };
    List result =
        await Future.wait<String>(utilityEndpoints.values.map((endPoint) async {
      try {
        Response response =
            await dio.get("$endPoint", options: Options(headers: token));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response.data;
        } else if (response.statusCode == 401) {
          logout();
          return Future.error("Unauthorized: Invalid Credentials");
        } else {
          return "--";
        }
      } catch (e) {
        errorHandler(e);
        return "--";
      }
    }));
    return [result, utilityEndpoints.keys.toList()];
  }

// Branch Specific Api
  Future<List<BranchModel>> branchesApi(String vendor_username) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> response = await dio.get(
          "/branches/branch/${vendor_username}/vendor_branches/",
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<BranchModel> x =
            response.data.map((e) => BranchModel.fromJson(e)).toList();
        return x;
      }
      return [];
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<BranchModel> getBranchInstance(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> response = await dio.get(
          "/branches/branch/${branch_id}/get_branch/",
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return BranchModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      errorHandler(e);
      return null;
    }
  }

  Future<bool> addBranch(Map<String, dynamic> branch, List<int> logo) async {
    try {
      Map<String, String> token = await tokenConfig();
      final formdata = FormData.fromMap({...branch, 'vendor': 't8o8o'});

      var response = await dio.post("/branches/branch/create_branch/",
          data: formdata, options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Branch created successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> updateBranch(
      {Map<String, dynamic> branchDetails, String branchId}) async {
    try {
      Map<String, String> token = await tokenConfig();
      final formdata = FormData.fromMap(branchDetails);

      var response = await dio.put("/branches/branch/$branchId/branch_details/",
          data: formdata, options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Branch successfully updated", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteBranch({Map<String, String> cred, String branchId}) async {
    try {
      Map<String, String> token = await tokenConfig();

      Response response = await dio.put(
        "/branches/branch/$branchId/delete_branch/",
        data: json.encode(cred),
        options:
            Options(headers: {...token, "content-type": "application/json"}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        snackHandler("Branch deleted successfully", PopUpType.success);
        return true;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<List<OrderModel>> branchOrdersApi(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map> response = await dio.get(
          "/records/order/$branch_id/branch_orders_filter/",
          options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<dynamic> x = response.data["branch_orders"];
        List<OrderModel> orders = x.map((e) => OrderModel.fromJson(e)).toList();
        return orders;
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<SalesQueryResponse> branchSalseApi(String branch_id,
      {String url}) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> response = await dio.get(
          url ?? "/records/sale/${branch_id}/branch_sales_cursor_pagination/",
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        SalesQueryResponse sales = SalesQueryResponse.fromJson(response.data);
        print(sales.next);
        return sales;
      }
    } catch (e) {
      errorHandler(e);
      return SalesQueryResponse(results: []);
    }
  }

  Future<List<StaffModel>> branchStaffApi(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.get("/staff/staff/$branch_id/branch_staff/",
          options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.data);
        List resultMap = response.data["branch_staff_s"];
        List<StaffModel> sales =
            resultMap.map((e) => StaffModel.fromJson(e)).toList();
        return sales;
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<dynamic> branchActivityApi(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> response = await dio.get(
          "/branches/activity_log/${branch_id}/branch_activity_log/",
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.data;
      }
    } catch (e) {
      errorHandler(e);
      return null;
    }
  }

  Future<dynamic> branchLoadMoreAcitivityApi(String nextUrl) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response =
          await dio.get(nextUrl, options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.data;
      }
    } catch (e) {
      errorHandler(e);
      return null;
    }
  }

  // Get all branch Consignments
  Future<List<ConsignmentModel>> getConsignments(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> response = await dio.get(
          "/products/consignment/$branch_id/branch_consignments/",
          options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<ConsignmentModel> consignments =
            response.data.map((e) => ConsignmentModel.fromJson(e)).toList();
        return consignments;
      } else {
        return [];
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  // Create Consignment
  Future<bool> createConsignment(Map<String, dynamic> consignment) async {
    try {
      Map<String, String> token = await tokenConfig();

      var response = await dio.post(
          "/products/consignment/register_consignment/",
          data: consignment,
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Consignment created successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);

      return false;
    }
  }

  // Product Apis ------------------------------->>>

// Products And Product Category Api Calls
  Future<List<ProductModel>> allProductsList(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> response = await dio.get(
        "/products/category_product/$branch_id/branch_products/",
        options: Options(headers: token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // print(json.encode(response.data[0]));
        List<ProductModel> products =
            response.data.map((e) => ProductModel.fromJson(e)).toList();
        return products;
      } else {
        return [];
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<bool> createProduct(Map<String, dynamic> map) async {
    try {
      Map<String, String> token = await tokenConfig();
      final formdata = FormData.fromMap(map);

      var response = await dio.post(
          "${Constants.API_HOST}/products/category_product/create_product/",
          data: formdata,
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Product successfully created", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> updateProduct(
      {Map<String, dynamic> map, String product_id}) async {
    try {
      Map<String, String> token = await tokenConfig();
      final formdata = FormData.fromMap(map);

      var response = await dio.put(
          "/products/category_product/$product_id/product_details/",
          data: formdata,
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Product successfully updated", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteProduct(String product_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.delete(
        "/products/category_product/$product_id/delete_product/",
        options:
            Options(headers: {...token, "content-type": "application/json"}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        snackHandler("Product deleted successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<List<ProductHistoryModel>> getProdHistory(String product_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> response = await dio.get(
        "/products/category_product/$product_id/get_product_history/",
        options: Options(headers: token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<ProductHistoryModel> products =
            response.data.map((e) => ProductHistoryModel.fromJson(e)).toList();
        return products;
      } else {
        return [];
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  // Category Apis ------------------------------------------>>>>

  Future<dynamic> productCategoriesApi(String category_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.get(
          "/products/category/$category_id/get_category/",
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.data;
      } else {
        return [];
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<bool> addProductCategory(Map<String, dynamic> category) async {
    try {
      Map<String, String> token = await tokenConfig();

      final formdata = FormData.fromMap(category);

      Response response = await dio.post("/products/category/create_category/",
          data: formdata, options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler(
            "Product Category created successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> updateProductCategory(
      Map<String, dynamic> category, String categoryId) async {
    try {
      Map<String, String> token = await tokenConfig();
      final formdata = FormData.fromMap(category);
      Response response = await dio.put(
          "/products/category/$categoryId/category_details/",
          data: formdata,
          options: Options(headers: token));
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Update product category0", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteCategory(
      {Map<String, String> cred, String categoryId}) async {
    try {
      Map<String, String> token = await tokenConfig();

      Response response = await dio.put(
        "/products/category/$categoryId/delete_category/",
        data: json.encode(cred),
        options:
            Options(headers: {...token, "content-type": "application/json"}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        snackHandler(
            "Product Category deleted successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  // Order APIs ----------------------------------->>>>>>>>
  Future<bool> placeOrder(Map<String, dynamic> orderList) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.post("/records/order/place_order/",
          data: orderList, options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Placed Order successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      errorHandler(err);
      return false;
    }
  }

  Future<OrderModel> addItems(
      List<Map<String, dynamic>> orderList, String order_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> response = await dio.put(
          "/records/order/$order_id/add_order_items/",
          data: orderList,
          options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        OrderModel ordermodel = OrderModel.fromJson(response.data);
        snackHandler("Items added successfully", PopUpType.success);
        return ordermodel;
      } else {
        return null;
      }
    } catch (err) {
      errorHandler(err);
      return null;
    }
  }

  Future<bool> deleteOrderItem(String order_item_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.delete(
          "/records/order/$order_item_id/delete_order_item/",
          options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        snackHandler("Order item deleted successfully", PopUpType.success);
        return true;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteOrder(String order_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.delete(
          "/records/order/$order_id/delete_order/",
          options: Options(headers: token));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        snackHandler("Order deleted successfully", PopUpType.success);
        return true;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> editOrder(Map<String, dynamic> map, String order_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response response = await dio.put(
        "/records/order/$order_id/update_information/",
        data: map,
        options: Options(headers: token),
      );

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        snackHandler("Order editted successfully", PopUpType.success);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      errorHandler(err);
      return false;
    }
  }

  Future<SaleModel> createSale(
      Map<String, dynamic> map, String order_id) async {
    try {
      print(map);
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> result = await dio.put(
          "/records/sale/$order_id/make_sale/",
          data: map,
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        SaleModel sale = SaleModel.fromJson(result.data);
        snackHandler("Created sale successfully", PopUpType.success);
        return sale;
      } else {
        return null;
      }
    } catch (err) {
      errorHandler(err);
      return null;
    }
  }

  Future<OrderModel> deactivatePendingOnOrder(String order_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> response = await dio.put(
        "/records/order/$order_id/deactivate_pending_order/",
        options: Options(headers: token),
      );

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        OrderModel orderModel = OrderModel.fromJson(response.data);
        snackHandler("Pending deactivated successfully", PopUpType.success);
        return orderModel;
      } else {
        return null;
      }
    } catch (err) {
      errorHandler(err);
      return null;
    }
  }

  Future<OrderModel> getOrderInstance(String order_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> response = await dio.get(
        "/records/order/$order_id/",
        options: Options(headers: token),
      );

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        OrderModel orderModel = OrderModel.fromJson(response.data);
        return orderModel;
      } else {
        return null;
      }
    } catch (err) {
      errorHandler(err);
      return null;
    }
  }

  Future<List<OrderItem>> deactivatePendingOnOrderItem(
      int order_item_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> response = await dio.put(
        "/records/order/$order_item_id/deactivate_pending_item/",
        options: Options(headers: token),
      );

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        List<OrderItem> orderItems =
            response.data.map((e) => OrderItem.fromJson(e)).toList();
        snackHandler("Pending deactivated successfully", PopUpType.success);

        return orderItems;
      } else {
        return null;
      }
    } catch (err) {
      errorHandler(err);
      return null;
    }
  }

  // Credit And Debit Apis
  Future<dynamic> createCreditTab(Map<String, dynamic> map) async {
    try {
      Map<String, String> token = await tokenConfig();

      Response result = await dio.post("/records/credit/create_tab/",
          data: map, options: Options(headers: token));
      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Tab created successfully", PopUpType.success);

        return result;
      }
      return null;
    } catch (err) {
      errorHandler(err);
    }
  }

  Future<List<TabModel>> getAllTabs(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      print(branch_id);
      Response<List<dynamic>> result = await dio.get(
          "/records/credit/$branch_id/branch_credit_tabs/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        return result.data.map((e) => TabModel.fromJson(e)).toList();
      }
      return [];
    } catch (err) {
      errorHandler(err);
      return [];
    }
  }

  Future<List<TabModel>> getBranchDebtors(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> result = await dio.get(
          "/records/credit/${branch_id}/branch_debtors/",
          options: Options(headers: token));
      if (result.statusCode >= 200 && result.statusCode <= 300) {
        print(result.data);
        return result.data.map((e) => TabModel.fromJson(e)).toList();
      }
    } catch (err) {
      errorHandler(err);
      return [];
    }
  }

  Future<List<TabModel>> getBranchCreditors(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> result = await dio.get(
          "/records/credit/${branch_id}/branch_creditors/",
          options: Options(headers: token));
      if (result.statusCode >= 200 && result.statusCode <= 300) {
        print(result.data);
        return result.data.map((e) => TabModel.fromJson(e)).toList();
      }
    } catch (err) {
      errorHandler(err);
      return [];
    }
  }

  Future<bool> addRecord(Map<String, dynamic> map, String credit_tab_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response result = await dio.put(
          "/records/credit/$credit_tab_id/add_record/",
          data: map,
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Record added successfully", PopUpType.success);

        return true;
      }
      return false;
    } catch (err) {
      errorHandler(err);
      return false;
    }
  }

  Future<bool> addOrderToCredit(
      Map<String, dynamic> map, String credit_tab_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response result = await dio.put(
          "/records/credit/$credit_tab_id/credit_order/",
          data: map,
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Order credited successfully", PopUpType.success);

        return true;
      }
      return false;
    } catch (err) {
      errorHandler(err);
      return false;
    }
  }

// Branch Expenses
  Future<bool> addExpense(Map<String, dynamic> map) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response result = await dio.post("/expenses/expense/add_expense/",
          data: map, options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Expense created successfully", PopUpType.success);

        return true;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<List<ExpenseModel>> getExpenses(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<List<dynamic>> result = await dio.get(
          "/expenses/expense/$branch_id/branch_expenses/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        List<ExpenseModel> expenses =
            result.data.map((e) => ExpenseModel.fromJson(e)).toList();
        return expenses;
      }
      return [];
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

// Branch Contact Apis
// add Contact
  Future<bool> addContact(Map<String, dynamic> map) async {
    try {
      FormData data = FormData.fromMap(map);
      Map<String, String> token = await tokenConfig();
      Response result = await dio.post("/contacts/contact/create_contact/",
          data: data, options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Contacted created successfully", PopUpType.success);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

// Get branch Contact
  Future<List<ContactModel>> getContacts(String branch_id) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response<Map<String, dynamic>> result = await dio.get(
          "/contacts/contact/$branch_id/branch_contacts/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        var x = result.data["branch_contacts"];
        if (x is List) {
          List<ContactModel> contacts =
              x.map((e) => ContactModel.fromJson(e)).toList();
          return contacts;
        }
      }
      return [];
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

// Branch Staff Apis
  // Add Staff
  Future<bool> addStff(Map<String, dynamic> map) async {
    try {
      FormData data = FormData.fromMap(map);
      Map<String, String> token = await tokenConfig();
      Response result = await dio.post("/staff/staff/create_staff/",
          data: data, options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Staff added successfully", PopUpType.success);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> updateStaff(int staff_id, Map<String, dynamic> map) async {
    try {
      FormData data = FormData.fromMap(map);
      print(map);
      Map<String, String> token = await tokenConfig();
      Response result = await dio.put("/staff/staff/${staff_id}/staff_details/",
          data: data, options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Staff updated successfully", PopUpType.success);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteStaff(
    int staff_id,
  ) async {
    try {
      Map<String, String> token = await tokenConfig();
      Response result = await dio.delete(
          "/staff/staff/${staff_id}/delete_staff/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        snackHandler("Staff deleted successfully", PopUpType.success);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<AnalysisTransactionModel> getTimelinedTransactions(
      {Map<String, dynamic> data, String branch_id}) async {
    Map<String, String> token = await tokenConfig();
    print(data);
    try {
      Response<Map<String, dynamic>> result = await dio.put(
          "/transactions/transaction/${branch_id}/transactionsnrecords/",
          data: data,
          options: Options(headers: token));
      print(json.encode(result.data));
      if (result.statusCode >= 200 && result.statusCode <= 300) {
        print("here");
        AnalysisTransactionModel model =
            AnalysisTransactionModel.fromJson(result.data);

        return model;
      }
    } catch (e) {
      errorHandler(e);
    }
  }

  Future<List<ProductSummaryData>> getTimelinedProductSummary(
      {Map<String, dynamic> data, String branch_id}) async {
    Map<String, String> token = await tokenConfig();
    print(data);
    try {
      Response<List<dynamic>> result = await dio.put(
          "/products/category_product/${branch_id}/products_summary_timeline/",
          data: data,
          options: Options(headers: token));
      print(json.encode(result.data));
      if (result.statusCode >= 200 && result.statusCode <= 300) {
        List<ProductSummaryData> model =
            result.data.map((e) => ProductSummaryData.fromMap(e)).toList();

        return model;
      }
    } catch (e) {
      errorHandler(e);
    }
  }

  //Get Staff

  // Settings --------------->>>

  Future<List<UserRoleDisplayModel>> getStaffRoles(String branchId) async {
    Map<String, String> token = await tokenConfig();

    try {
      Response<List<dynamic>> result = await dio.get(
          "/users/user_role/vendor_user_roles/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        List<UserRoleDisplayModel> model =
            result.data.map((e) => UserRoleDisplayModel.fromJson(e)).toList();

        return model;
      }
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<List<UserRoleDisplayModel>> getStaffRolesTrancated() async {
    Map<String, String> token = await tokenConfig();

    try {
      Response<List<dynamic>> result = await dio.get(
          "/users/user_role/vendor_user_roles_only/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        List<UserRoleDisplayModel> model =
            result.data.map((e) => UserRoleDisplayModel.fromJson(e)).toList();

        return model;
      }
      return [];
    } catch (e) {
      errorHandler(e);
      return [];
    }
  }

  Future<bool> createUserRole(Map<String, dynamic> data) async {
    Map<String, String> token = await tokenConfig();

    try {
      Response result = await dio.post("/users/user_role/create_user_role/",
          data: data, options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        print(result.data);

        return true;
      }
      return false;
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> updateUserRole(
      String user_role_id, Map<String, dynamic> data) async {
    Map<String, String> token = await tokenConfig();

    try {
      Response result = await dio.put(
          "/users/user_role/${user_role_id}/update_user_role/",
          data: data,
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        print(result.data);

        return true;
      }
      return false;
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }

  Future<bool> deleteUserRole(String user_role_id) async {
    Map<String, String> token = await tokenConfig();

    try {
      Response result = await dio.delete(
          "/users/user_role/${user_role_id}/delete_user_role/",
          options: Options(headers: token));

      if (result.statusCode >= 200 && result.statusCode <= 300) {
        print(result.data);

        return true;
      }
      return false;
    } catch (e) {
      errorHandler(e);
      return false;
    }
  }
}

// Done--------------------------------->>>
