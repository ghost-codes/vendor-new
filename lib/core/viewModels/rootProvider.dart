import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/tokenConfig.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

enum PaperType { A4, P72 }

enum BranchPages {
  Stock,
  Products,
  Orders,
  Sales,
  Staff,
  Activities,
  Analysis,
  CreditAndDebit,
  Contacts,
  Expenses,
  Services,
}

enum SettingsPages {
  StaffRoles,
  Accounts,
  Billing,
  Security,
  Printing,
  DataUnit
}

class RootProvider extends BaseModel {
  // BuildContext context;

  bool allowSnackDisplay = true;

  Api _api = sl<Api>();

  bool isBranchSelected = false;
  double selectedBranchTab = 2.0;
  bool isTokenAuthenticating = false;
  String header = "Dashboard";
  BranchModel branchModel;

  UserModel userModel;

  PaperType paperType = PaperType.P72;

  // SettingsPage Stream Controller
  StreamController<SettingsPages> _settingsController =
      StreamController.broadcast();
  Sink<SettingsPages> get settingsPagesSink => _settingsController.sink;
  Stream<SettingsPages> get settingsPagesStream => _settingsController.stream;

  // Branch Page Stream Controller
  StreamController<BranchPages> _branchConroller = StreamController.broadcast();
  Sink<BranchPages> get branchPagesSink => _branchConroller.sink;
  Stream<BranchPages> get branchPagesStream => _branchConroller.stream;
// AutoPrint Vars

  bool isDetailsRefreshing = false;

  bool isRefreshing = false;
  bool isOrderItemDeleting = false;
  int deletingItemIndex;
  bool onOrderPage = false;
  bool isOrderDetail = false;
  bool isDeleting = false;
  bool isDeactivatingPending = false;
  bool isDeactivatingPendingOrderItem = false;
  List<OrderModel> orders = [];
  PrintingService printingService = sl<PrintingService>();

  RootProvider() {
    branchPagesStream.listen((event) {
      if (event == BranchPages.Orders) onOrderPage = true;
      if (event != BranchPages.Orders) onOrderPage = false;
    });

    _api.authListener.stream.listen((event) {
      branchModel = null;
    });

    final mytimer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (branchModel == null || (onOrderPage && isBranchSelected)) return;
      if ((userModel.userRole.canRegulateOrders ?? false) ||
          userModel.userType == "Vendor") isLoading();
    });
  }
  setOnOrderPage(bool val) {
    onOrderPage = val;
    notifyListeners();
  }

  isLoading() async {
    int autoPrintChit = json
        .decode(await sharedPref.getStringValuesSF("isAutoChitPrint") ?? "0");
    if (autoPrintChit == 0) return;

    isRefreshing = true;
    notifyListeners();
    List<OrderModel> x = await _api.branchOrdersApi(branchModel.id);
    if (x.length != 0) {
      orders = x;
    }

    int printChit =
        json.decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");

    if (autoPrintChit == 1 && printChit == 1) {
      List<String> _pendingIds = getPendingOrders(x);
      if (_pendingIds.isNotEmpty)
        _pendingIds.forEach((element) async {
          await deactivatePendingOnOrder(element);
        });
    }
    isRefreshing = false;
    notifyListeners();
  }

  List<String> getPendingOrders(List<OrderModel> _orders) {
    List<String> orderIds = [];
    _orders.forEach((element) {
      if (element.isPending) {
        orderIds.add(element.id);
      }
    });
    return orderIds;
  }

  deactivatePendingOnOrder(String order_id) async {
    isDeactivatingPending = true;
    // deactivatingIndex = orders.indexWhere((element) => element.id == order_id);
    notifyListeners();
    OrderModel response = await _api.deactivatePendingOnOrder(order_id);
    if (response != null) {
      // CHit print
      OrderModel predeactivatedInstance =
          orders.firstWhere((element) => element.id == order_id);
      int printChit = json
          .decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");
      List<OrderItem> itemsToPrint = predeactivatedInstance.orderItems
          .where((element) => element.isPending)
          .toList();
      if (printChit == 1) {
        await chitPrintingOrderItems(itemsToPrint, response);
      }

      OrderModel tempUpdatedOrder =
          orders[orders.indexWhere((element) => element.id == order_id)];
      tempUpdatedOrder.isPending = false;
      orders[orders.indexWhere((element) => element.id == order_id)] =
          tempUpdatedOrder;
    }
    isDeactivatingPending = false;
    notifyListeners();
  }

  chitPrintingOrderItems(List<OrderItem> orderItems, OrderModel order) async {
    Map<String, List<OrderItem>> items = {};
    Map<String, dynamic> setPrinterA = json.decode(
        await sharedPref.getStringValuesSF("Printer A") ??
            """{"url": "", "categories": []}""");
    Map<String, dynamic> setPrinterB = json.decode(
        await sharedPref.getStringValuesSF("Printer B") ??
            """{"url": "", "categories": []}""");
    Map<String, dynamic> setPrinterC = json.decode(
        await sharedPref.getStringValuesSF("Printer C") ??
            """{"url": "", "categories": []}""");
    Map<String, dynamic> setPrinterD = json.decode(
        await sharedPref.getStringValuesSF("Printer D") ??
            """{"url": "", "categories": []}""");
    Map<String, dynamic> setPrinterE = json.decode(
        await sharedPref.getStringValuesSF("Printer E") ??
            """{"url": "", "categories": []}""");

    for (OrderItem element in orderItems) {
      if (setPrinterA["categories"].contains(element.ancestorCategory)) {
        if (items.containsKey(setPrinterA["url"])) {
          items[setPrinterA["url"]].add(element);
          continue;
        } else {
          items[setPrinterA["url"]] = [element];
          continue;
        }
      } else if (setPrinterB["categories"].contains(element.ancestorCategory)) {
        if (items.containsKey(setPrinterB["url"])) {
          items[setPrinterB["url"]].add(element);
          continue;
        } else {
          items[setPrinterB["url"]] = [element];
          continue;
        }
      } else if (setPrinterC["categories"].contains(element.ancestorCategory)) {
        if (items.containsKey(setPrinterC["url"])) {
          items[setPrinterC["url"]].add(element);
          continue;
        } else {
          items[setPrinterC["url"]] = [element];
          continue;
        }
      } else if (setPrinterD["categories"].contains(element.ancestorCategory)) {
        if (items.containsKey(setPrinterD["url"])) {
          items[setPrinterD["url"]].add(element);
          continue;
        } else {
          items[setPrinterD["url"]] = [element];
          continue;
        }
      } else if (setPrinterE["categories"].contains(element.ancestorCategory)) {
        if (items.containsKey(setPrinterE["url"])) {
          items[setPrinterE["url"]].add(element);
          continue;
        } else {
          items[setPrinterE["url"]] = [element];
          continue;
        }
      } else {
        if (items.containsKey(setPrinterA["url"])) {
          items[setPrinterA["url"]].add(element);
          continue;
        } else {
          items[setPrinterA["url"]] = [element];
          continue;
        }
      }
    }

    items.forEach((key, value) async {
      await printingService.printChit(
          orderItems: value, associatedPrinterUrl: key, orderObj: order);
    });
  }

  registerStream(BuildContext context) {
    if (allowSnackDisplay) {
      allowSnackDisplay = false;
      _api.snackBarStream.listen((event) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(event.message),
          backgroundColor: LocalColors.error,
          elevation: 999,
        ));
      });
    }
  }

  setShowSnackDisplay(bool value) {
    allowSnackDisplay = value;
    notifyListeners();
  }

  // Change Paper Type
  changePaperType(PaperType selected) {
    paperType = selected;
    notifyListeners();
  }

  setHeader(String _header) {
    header = _header;
    notifyListeners();
  }

  setBranchSelectedtrue(String _header) {
    header = _header;
    isBranchSelected = true;
    notifyListeners();
  }

  setBranchSelectedfalse() {
    isBranchSelected = false;
    notifyListeners();
  }

  setBranchModel(BranchModel model) {
    branchModel = model;
    notifyListeners();
  }

  setSelectedBranchTab(double item) {
    selectedBranchTab = item;
    notifyListeners();
  }

  dispose() {
    isBranchSelected = false;
  }
}
