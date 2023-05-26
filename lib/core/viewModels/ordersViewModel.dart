import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/tokenConfig.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class OrdersViewModel extends BaseModel {
  String branchId = "";
  Api _api = sl<Api>();
  PrintingService printingService = sl<PrintingService>();
  List<OrderModel> orders;
  int deactivatingIndex;

  bool isDetailsRefreshing = false;

  bool isRefreshing = false;
  bool isOrderItemDeleting = false;
  int deletingItemIndex;

  bool isOrderDetail = false;
  bool isDeleting = false;
  bool isDeactivatingPending = false;
  bool isDeactivatingPendingOrderItem = false;
  OrderModel selectedOrder;

  getOrders() async {
    setState(ViewState.Busy);
    orders = await _api.branchOrdersApi(branchId);

    int autoPrintChit = json
        .decode(await sharedPref.getStringValuesSF("isAutoChitPrint") ?? "0");

    int printChit =
        json.decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");

    if (autoPrintChit == 1 && printChit == 1) {
      List<String> _pendingIds = getPendingOrders(orders);
      if (_pendingIds.isNotEmpty)
        _pendingIds.forEach((element) async {
          await deactivatePendingOnOrder(element);
        });
    }
    setState(ViewState.Idle);
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

  isLoading() async {
    isRefreshing = true;
    notifyListeners();
    List<OrderModel> x = await _api.branchOrdersApi(branchId);
    if (x.length != 0) {
      orders = x;
      if (selectedOrder != null) {
        selectedOrder = orders.singleWhere(
            (element) => element.id == selectedOrder.id, orElse: () {
          isOrderDetail = false;
          return null;
        });
      }
    }

    int autoPrintChit = json
        .decode(await sharedPref.getStringValuesSF("isAutoChitPrint") ?? "0");

    int printChit =
        json.decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");

    if (autoPrintChit == 1 && printChit == 1) {
      List<String> _pendingIds = getPendingOrders(x);
      if (_pendingIds.isNotEmpty)
        _pendingIds.forEach((element) async {
          await deactivatePendingOnOrder(element);
        });
    }
    selectedOrder =
        orders.firstWhere((element) => element.id == selectedOrder.id);
    isRefreshing = false;
    notifyListeners();
  }

  deactivatePendingOnOrder(String order_id) async {
    isDeactivatingPending = true;
    deactivatingIndex = orders.indexWhere((element) => element.id == order_id);
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

  deactivatePendingOnOrderDetail(String order_id) async {
    isDeactivatingPending = true;
    deactivatingIndex = orders.indexWhere((element) => element.id == order_id);
    notifyListeners();
    OrderModel response = await _api.deactivatePendingOnOrder(order_id);
    if (response != null) {
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
      selectedOrder = tempUpdatedOrder;

      // int printChit = json
      //     .decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");

      // if (printChit == 1) {
      //   await chitPrintingOrderItems(response.orderItems, response);
      // }
    }
    isDeactivatingPending = false;
    notifyListeners();
  }

  printSingleChit(OrderItem orderItem) async {
    int printChit =
        json.decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");

    if (printChit == 1) {
      await chitPrintingOrderItems([orderItem], selectedOrder);
    }
  }

  deactivatePendingOnOrderItem(int order_item_id) async {
    isDeactivatingPendingOrderItem = true;
    deactivatingIndex = selectedOrder.orderItems
        .indexWhere((element) => element.id == order_item_id);
    notifyListeners();
    List<OrderItem> response =
        await _api.deactivatePendingOnOrderItem(order_item_id);
    if (response != null && response.length != 0) {
      int printChit = json
          .decode(await sharedPref.getStringValuesSF("isChitEnabled") ?? "0");

      if (printChit == 1) {
        await chitPrintingOrderItems(response, selectedOrder);
      }

      OrderItem tempUpdatedOrder = selectedOrder.orderItems[selectedOrder
          .orderItems
          .indexWhere((element) => element.id == order_item_id)];
      tempUpdatedOrder.isPending = false;
      selectedOrder.orderItems[selectedOrder.orderItems
              .indexWhere((element) => element.id == order_item_id)] =
          tempUpdatedOrder;
    }
    isDeactivatingPendingOrderItem = false;
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

  setIsOrderDetail(bool x, {OrderModel model}) {
    isOrderDetail = x;
    if (x) {
      selectedOrder = model;
    }
    notifyListeners();
  }

  refresh(bool delete, bool reload) {
    if (delete) {
      isOrderDetail = false;
      orders.removeWhere((element) => element.id == selectedOrder.id);
    } else if (reload) {}

    notifyListeners();
  }

  discountSuccesful(Map<String, dynamic> map) {
    selectedOrder = OrderModel.fromJson(map);

    orders[orders.indexWhere((element) => element.id == selectedOrder.id)] =
        selectedOrder;
    notifyListeners();
  }

  deleteOrderItem(String orderItemId, int itemIndex) async {
    deletingItemIndex = itemIndex;
    isOrderItemDeleting = true;
    notifyListeners();
    bool result = await _api.deleteOrderItem(orderItemId);
    if (result) {
      if (selectedOrder.orderItems.length != 0) {
        selectedOrder = await _api.getOrderInstance(selectedOrder.id);
      }
    }
    isOrderItemDeleting = false;
    notifyListeners();
  }

  orderInstance() async {
    isDetailsRefreshing = true;
    notifyListeners();
    OrderModel x = await _api.getOrderInstance(selectedOrder.id);
    if (x != null) {
      selectedOrder = x;
    }
    isDetailsRefreshing = false;
    notifyListeners();
  }

  dispose() {
    branchId = "";

    orders = [];

    isOrderDetail = false;
    selectedOrder;
  }
}
