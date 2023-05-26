import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
// import 'package:vendoorr/core/models/orderItemModel.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/ordersViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/addItems.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/creditOrderModal.dart';
import 'package:vendoorr/ui/widgets/deleteQueryDialogue.dart';
import 'package:vendoorr/ui/widgets/discountModal.dart';
import 'package:vendoorr/ui/widgets/placeOrder.dart';
import 'package:vendoorr/ui/widgets/productTableRow.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/sellOrderModal.dart';

class OrdersView extends StatefulWidget {
  final String branchId;

  OrdersView({Key key, this.branchId}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  TextStyle normalDisplay = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 14,
    color: LocalColors.black,
  );
  Timer mytimer;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, _) {
      return BaseView<OrdersViewModel>(onModelReady: (model) {
        model.branchId = widget.branchId;
        model.getOrders();
        mytimer = Timer.periodic(Duration(seconds: 15), (timer) {
          // if (model.isOrderDetail) {
          //   model.orderInstance();
          // } else {
          if (userModel.userType == "Vendor" ||
              (userModel.userRole.canRegulateOrders ?? false))
            model.isLoading();
          // }
        });
      }, builder: (context, model, _) {
        return model.state == ViewState.Busy && model.orders == null
            ? Center(
                child: Loaders.fadingCube,
              )
            : Column(
                children: [
                  Consumer2<RootProvider, UserModel>(
                      builder: (context, rootProv, userModel, _) {
                    return BaseHeader(
                        backLogic: model.isOrderDetail
                            ? InkWell(
                                onTap: () {
                                  model.setIsOrderDetail(false);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ConstantValues.BorderRadius),
                                    color: LocalColors.primaryColor,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: LocalColors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        midSection: Text(
                          "Orders (${rootProv.header})",
                          style: LocalTextTheme.headerMain,
                        ),
                        button: model.isOrderDetail
                            ? Visibility(
                                visible: userModel.userType == "Vendor" ||
                                    userModel.userRole.canManageOrders,
                                child: Row(
                                  children: [
                                    SmallSecondaryButton(
                                      text: "Edit",
                                      onPressed: () async {
                                        Map<String, dynamic> res =
                                            await showDialog(
                                          barrierColor: LocalColors.primaryColor
                                              .withOpacity(0.15),
                                          context: context,
                                          builder: (context) {
                                            return EditOrderModal(
                                              order: model.selectedOrder,
                                            );
                                          },
                                        );

                                        if (res != null && res["isDelete"]) {
                                          model.refresh(true, true);
                                        } else if (res != null) {
                                          model.orderInstance();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SmallPrimaryButton(
                                      text: "+ Items",
                                      onPressed: () async {
                                        OrderModel res = await showDialog(
                                          context: context,
                                          barrierColor: LocalColors.black
                                              .withOpacity(0.2),
                                          builder: (context) => AddItems(
                                            orderId: model.selectedOrder.id,
                                            branchId: widget.branchId,
                                            userModel: userModel,
                                          ),
                                        );

                                        if (res != null) {
                                          model.setIsOrderDetail(true,
                                              model: res);
                                          model.getOrders();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Visibility(
                                visible: userModel.userType == "Vendor" ||
                                    userModel.userRole.canCreateOrders,
                                child: SmallPrimaryButton(
                                  onPressed: () async {
                                    bool res = await showDialog(
                                      context: context,
                                      barrierColor:
                                          LocalColors.black.withOpacity(0.2),
                                      builder: (context) => PlaceOrder(
                                        branchId: widget.branchId,
                                        userModel: userModel,
                                      ),
                                    );

                                    if (res) {
                                      model.getOrders();
                                    }
                                  },
                                  text: "+ Order",
                                ),
                              ));
                  }),
                  SizedBox(height: ConstantValues.PadSmall),
                  Expanded(
                    child: Navigator(
                      onPopPage: (route, result) {
                        return route.didPop(result);
                      },
                      pages: [
                        MaterialPage(child: OrderListView()),
                        if (model.isOrderDetail)
                          MaterialPage(child: OrderDetailView()),
                      ],
                    ),
                  ),
                ],
              );
      });
    });
  }

  @override
  void dispose() {
    mytimer.cancel();
    super.dispose();
  }
}

class OrderListView extends StatefulWidget {
  OrderListView({Key key}) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  List<int> flexes = [4, 2, 1, 1, 3, 2];

  bool isHovered = false;
  int hoveredIndex = 0;

  PrintingService printServ = sl<PrintingService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersViewModel>(builder: (context, model, _) {
      return Scaffold(
        body: Container(
          child: Column(
            children: [
              model.isRefreshing || model.state == ViewState.Busy
                  ? LinearProgressIndicator()
                  : SizedBox.shrink(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: LocalColors.white,
                    boxShadow: ConstantValues.baseShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(
                          vertical: ConstantValues.PadSmall,
                          horizontal: ConstantValues.PadWide,
                        ),
                        decoration: BoxDecoration(
                            color: LocalColors.white,
                            boxShadow: ConstantValues.baseShadow),
                        child: ItemListTile(
                          flexes: flexes,
                          children: [
                            Text(
                              "Name",
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Client Phone",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Status",
                              style: LocalTextTheme.tableHeader,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Total",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Modified",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Attendant",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                          ],
                        ),
                      ),
                      Consumer<UserModel>(builder: (context, userModel, _) {
                        return Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: model.orders.length == 0
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "No Orders Yet",
                                            style: LocalTextTheme.headerMain,
                                          ),
                                          SmallSecondaryButton(
                                            onPressed: () {
                                              model.getOrders();
                                            },
                                            text: "Refresh",
                                          )
                                        ],
                                      )
                                    : ListView.builder(
                                        itemCount: model.orders.length,
                                        itemBuilder: (context, index) {
                                          OrderModel orderModel =
                                              model.orders[index];
                                          return InkWell(
                                            onHover: (value) {
                                              setState(() {
                                                isHovered = value;
                                                hoveredIndex = index;
                                              });
                                            },
                                            onTap: () {
                                              model.setIsOrderDetail(true,
                                                  model: orderModel);
                                            },
                                            child: Material(
                                              color: LocalColors.white,
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                    border: isHovered &&
                                                            hoveredIndex ==
                                                                index
                                                        ? Border(
                                                            left: BorderSide(
                                                            width: 7,
                                                            color: LocalColors
                                                                .primaryColor,
                                                          ))
                                                        : Border(),
                                                    color: isHovered &&
                                                            hoveredIndex ==
                                                                index
                                                        ? LocalColors.black
                                                            .withOpacity(0.02)
                                                        : Colors.transparent),
                                                height: 50,
                                                margin: EdgeInsets.only(
                                                    bottom: ConstantValues
                                                        .PadSmall),
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      ConstantValues.PadSmall,
                                                  horizontal:
                                                      ConstantValues.PadWide,
                                                ),
                                                child: ItemListTile(
                                                  flexes: flexes,
                                                  children: [
                                                    Text(
                                                      orderModel.name,
                                                      style: LocalTextTheme
                                                          .tableHeader,
                                                    ),
                                                    Text(
                                                      orderModel.clientPhone,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Visibility(
                                                      visible: userModel
                                                                  .userType ==
                                                              "Vendor" ||
                                                          (userModel.userRole
                                                                  .canRegulateOrders ??
                                                              false),
                                                      child: Container(
                                                        child: model.isDeactivatingPending &&
                                                                model.deactivatingIndex ==
                                                                    index
                                                            ? Loaders
                                                                .fadinCubePrimSmall
                                                            : orderModel
                                                                    .isPending
                                                                ? InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      model.deactivatePendingOnOrder(
                                                                          orderModel
                                                                              .id);
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .refresh,
                                                                      color: LocalColors
                                                                          .grey,
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      printServ
                                                                          .printProformer(
                                                                              orderModel);
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .print,
                                                                      color: LocalColors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                      ),
                                                    ),
                                                    Text(
                                                      orderModel.amountPayable,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      orderModel.modified,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      orderModel.attendant,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class OrderDetailView extends StatefulWidget {
  OrderDetailView({Key key}) : super(key: key);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  List<int> flexes = [2, 1, 1, 1, 1, 1];

  bool isHovered = false;

  int hoveredIndex;
  PrintingService printServ = sl<PrintingService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer2<OrdersViewModel, UserModel>(
            builder: (context, model, userModel, _) {
              return Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                        decoration: BoxDecoration(
                          boxShadow: ConstantValues.baseShadow,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                          color: LocalColors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Details",
                                  style: LocalTextTheme.pageHeader(),
                                ),
                              ],
                            ),
                            Container(
                              height: 130,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name: ${model.selectedOrder.name}",
                                        style: LocalTextTheme.body,
                                      ),
                                      SizedBox(
                                        height: ConstantValues.PadSmall / 4,
                                      ),
                                      Text(
                                        "Client Phone: ${model.selectedOrder.clientPhone}",
                                        style: LocalTextTheme.body,
                                      ),
                                      Text(
                                        "OrderId: ${model.selectedOrder.id}",
                                        style: LocalTextTheme.body,
                                      ),
                                      SizedBox(
                                        height: ConstantValues.PadSmall / 4,
                                      ),
                                      Text(
                                        "Attendant: ${model.selectedOrder.attendant}",
                                        style: LocalTextTheme.body,
                                      ),
                                      SizedBox(
                                        height: ConstantValues.PadSmall / 4,
                                      ),
                                      Text(
                                        "Created: ${model.selectedOrder.created}",
                                        style: LocalTextTheme.body,
                                      ),
                                      SizedBox(
                                        height: ConstantValues.PadSmall / 4,
                                      ),
                                      Text(
                                        "Modified: ${model.selectedOrder.modified}",
                                        style: LocalTextTheme.body,
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: SvgPicture.asset(
                                      "assets/svgs/invoice.svg",
                                      color: LocalColors.grey,
                                      width: 130,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ConstantValues.PadWide,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: LocalTextTheme.header,
                                ),
                                Text(
                                  "GHS ${model.selectedOrder.total}",
                                  style: LocalTextTheme.body,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Discount",
                                      style: LocalTextTheme.header,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Text(
                                  "${model.selectedOrder.discount.contains("%") ? "" : "GHS"} ${model.selectedOrder.discount}",
                                  style: LocalTextTheme.body,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Amount Payable",
                                  style: LocalTextTheme.header,
                                ),
                                Text(
                                  "GHS ${model.selectedOrder.amountPayable}",
                                  style: LocalTextTheme.body,
                                )
                              ],
                            ),
                            SizedBox(
                              height: ConstantValues.PadWide,
                            ),
                            Visibility(
                              child: Material(
                                color: LocalColors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: userModel.userType == "Vendor" ||
                                          (userModel
                                                  .userRole.canRegulateOrders ||
                                              userModel
                                                  .userRole.canManageOrders),
                                      child: model.selectedOrder.isPending
                                          ? model.isDeactivatingPending
                                              ? Loaders.fadingCube
                                              : IconButton(
                                                  onPressed: () {
                                                    model
                                                        .deactivatePendingOnOrderDetail(
                                                            model.selectedOrder
                                                                .id);
                                                  },
                                                  icon: Icon(
                                                    Icons.refresh,
                                                    color: LocalColors.grey,
                                                  ),
                                                )
                                          : IconButton(
                                              onPressed: () async {
                                                await printServ.printProformer(
                                                    model.selectedOrder);
                                              },
                                              icon: Icon(
                                                Icons.print,
                                                color: LocalColors.green,
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    model.selectedOrder.isPending
                                        ? SizedBox.shrink()
                                        : Row(
                                            children: [
                                              Visibility(
                                                visible: userModel.userType ==
                                                        "Vendor" ||
                                                    userModel.userRole
                                                        .canManageAccountTabs,
                                                child: SmallSecondaryButton(
                                                  text: "+ Credit",
                                                  onPressed: () async {
                                                    Map<String, dynamic> res =
                                                        await showDialog(
                                                      context: context,
                                                      barrierColor: LocalColors
                                                          .primaryColor
                                                          .withOpacity(0.15),
                                                      builder: (context) =>
                                                          CreditOrderModal(
                                                              model
                                                                  .selectedOrder
                                                                  .id,
                                                              model.branchId),
                                                    );
                                                    model.refresh(
                                                        res["deleted"],
                                                        res["reload"]);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: ConstantValues.PadSmall,
                                              ),
                                              Visibility(
                                                visible: userModel.userType ==
                                                        "Vendor" ||
                                                    userModel
                                                        .userRole.canMakeSales,
                                                child: SmallPrimaryButton(
                                                  text: "Sell",
                                                  onPressed: () async {
                                                    Map<String, dynamic> res =
                                                        await showDialog(
                                                      context: context,
                                                      barrierColor: LocalColors
                                                          .primaryColor
                                                          .withOpacity(0.15),
                                                      builder: (context) =>
                                                          SellOrderModal(
                                                              model
                                                                  .selectedOrder
                                                                  .amountPayable,
                                                              model
                                                                  .selectedOrder
                                                                  .id),
                                                    );
                                                    if (res["deleted"]) {
                                                      // printServ.printReceipt(sale)
                                                    }
                                                    model.refresh(
                                                        res["deleted"],
                                                        res["reload"]);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ConstantValues.PadWide,
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: 500),
                        padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                        decoration: BoxDecoration(
                          boxShadow: ConstantValues.baseShadow,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                          color: LocalColors.white,
                        ),
                        child: model.selectedOrder.orderItems.length == 0
                            ? Center(
                                child: Text(
                                "No Order Items",
                                style: LocalTextTheme.headerMain,
                              ))
                            : SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    model.selectedOrder.orderItems.length + 1,
                                    (index) {
                                      OrderItem item =
                                          model.selectedOrder.orderItems[
                                              index > 0 ? index - 1 : 0];
                                      if (index == 0) {
                                        return Container(
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                            vertical: ConstantValues.PadSmall,
                                            horizontal: ConstantValues.PadWide,
                                          ),
                                          decoration: BoxDecoration(
                                            color: LocalColors.white,
                                            // boxShadow: ConstantValues.baseShadow,
                                          ),
                                          child: ItemListTile(
                                            flexes: flexes,
                                            children: [
                                              Text(
                                                "Name",
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                              Text(
                                                "Unit Price",
                                                textAlign: TextAlign.center,
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                              Text(
                                                "Quantity",
                                                textAlign: TextAlign.center,
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                              Text(
                                                "Amount",
                                                textAlign: TextAlign.center,
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                              Text(
                                                "Status",
                                                textAlign: TextAlign.center,
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                              Text(
                                                "Modified",
                                                textAlign: TextAlign.center,
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      return InkWell(
                                        onHover: (value) {
                                          setState(() {
                                            isHovered = value;
                                            hoveredIndex = index;
                                          });
                                        },
                                        onTap: () {},
                                        child: Stack(
                                          children: [
                                            Material(
                                              color: LocalColors.white,
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                    border: isHovered &&
                                                            hoveredIndex ==
                                                                index
                                                        ? Border(
                                                            left: BorderSide(
                                                            width: 7,
                                                            color: LocalColors
                                                                .primaryColor,
                                                          ))
                                                        : Border(),
                                                    color: model.isOrderItemDeleting &&
                                                            model.deletingItemIndex ==
                                                                index
                                                        ? LocalColors
                                                            .primaryColor
                                                            .withOpacity(0.8)
                                                        : isHovered &&
                                                                hoveredIndex ==
                                                                    index
                                                            ? LocalColors.black
                                                                .withOpacity(
                                                                    0.02)
                                                            : Colors
                                                                .transparent),
                                                margin: EdgeInsets.only(
                                                    bottom: ConstantValues
                                                        .PadSmall),
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      ConstantValues.PadSmall,
                                                  horizontal:
                                                      ConstantValues.PadWide,
                                                ),
                                                child: ItemListTile(
                                                  flexes: flexes,
                                                  children: [
                                                    Text(
                                                      item.name,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      item.price,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      item.quantity.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      item.price,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Visibility(
                                                      visible: userModel
                                                                  .userType ==
                                                              "Vendor" ||
                                                          (userModel.userRole
                                                                  .canRegulateOrders ||
                                                              userModel.userRole
                                                                  .canManageOrders),
                                                      child: model.isDeactivatingPendingOrderItem &&
                                                              model.deactivatingIndex +
                                                                      1 ==
                                                                  index
                                                          ? Loaders
                                                              .fadinCubePrimSmall
                                                          : item.isPending
                                                              ? Center(
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      model.deactivatePendingOnOrderItem(
                                                                          item.id);
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .refresh,
                                                                      color: LocalColors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Center(
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      model.printSingleChit(
                                                                          item);
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .check_circle_outline_sharp,
                                                                      color: LocalColors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                ),
                                                    ),
                                                    Text(
                                                      item.modified,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: userModel.userType ==
                                                      "Vendor" ||
                                                  userModel
                                                      .userRole.canManageOrders,
                                              child: Positioned(
                                                top: -2,
                                                right: -2,
                                                child: InkWell(
                                                  onTap:
                                                      model.isOrderItemDeleting
                                                          ? null
                                                          : () {
                                                              model.deleteOrderItem(
                                                                  item.id
                                                                      .toString(),
                                                                  index);
                                                            },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(2.5),
                                                    decoration: BoxDecoration(
                                                      color: LocalColors.error,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 15,
                                                      color: LocalColors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // model.isOrderItemDeleting &&
                                            //         model.deletingItemIndex == index
                                            //     ? Container(
                                            //         height: double.infinity,
                                            //         width: double.infinity,
                                            //         color: LocalColors.primaryColor
                                            //             .withOpacity(0.3))
                                            //     : SizedBox.shrink(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
