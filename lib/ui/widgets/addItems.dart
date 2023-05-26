import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/addItemsViewModel.dart';
import 'package:vendoorr/core/viewModels/placeOrderViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class AddItems extends StatelessWidget {
  final String branchId;
  final String orderId;
  final UserModel userModel;

  const AddItems({Key key, this.branchId, this.orderId, @required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddItemViewModel>(onModelReady: (model) {
      model.init(branchId);
    }, builder: (context, model, _) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          child: Material(
            child: Container(
              width: model.isReferenceInputPage ? 500 : 950,
              height: model.isReferenceInputPage ? 300 : 600,
              decoration: BoxDecoration(
                color: LocalColors.offWhite,
                boxShadow: ConstantValues.baseShadow,
              ),
              child: model.isLoading
                  ? Center(child: Loaders.fadingCube)
                  : Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ConstantValues.PadSmall),
                          color: LocalColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add Items",
                                style: TextStyle(
                                  color: LocalColors.primaryColor,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: SvgPicture.asset("assets/svgs/close.svg", width: 12),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: OrderSheetItems(
                                        userModel: userModel,
                                        orderId: orderId,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: LocalColors.grey,
                                width: 1,
                                thickness: 1,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Expanded(child: PlaceOrderProductsList()),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}

class OrderSheetItems extends StatefulWidget {
  final UserModel userModel;
  OrderSheetItems({Key key, this.orderId, @required this.userModel}) : super(key: key);

  final String orderId;

  @override
  State<OrderSheetItems> createState() => _OrderSheetItemsState();
}

class _OrderSheetItemsState extends State<OrderSheetItems> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddItemViewModel>(builder: (context, model, _) {
      return Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(
                      vertical: ConstantValues.PadSmall,
                      horizontal: ConstantValues.PadWide,
                    ),
                    child: ItemListTile(
                      flexes: [4, 3, 2, 2, 1],
                      children: [
                        Text(
                          "Name",
                          style: LocalTextTheme.tablebody,
                        ),
                        Text(
                          "Price(GH)",
                          textAlign: TextAlign.center,
                          style: LocalTextTheme.tablebody,
                        ),
                        Text(
                          "Qty",
                          textAlign: TextAlign.center,
                          style: LocalTextTheme.tablebody,
                        ),
                        Text(
                          "Tag",
                          textAlign: TextAlign.center,
                          style: LocalTextTheme.tablebody,
                        ),
                        Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: List.generate(
                      model.orderList.length,
                      (index) => Container(
                        // margin: EdgeInsets.only(bottom: ConstantValues.PadSmall),
                        margin: EdgeInsets.symmetric(
                          vertical: ConstantValues.PadSmall / 2,
                          horizontal: ConstantValues.PadWide,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: ConstantValues.PadSmall / 4,
                          horizontal: ConstantValues.PadSmall,
                        ),
                        decoration: BoxDecoration(
                          color: LocalColors.white,
                          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
                          boxShadow: ConstantValues.baseShadow,
                        ),
                        child: ItemListTile(
                          flexes: [4, 3, 2, 2, 1],
                          children: [
                            Text(
                              "${model.orderList[index].name}  ${model.orderList[index].tag == "" ? "" : "[${model.orderList[index].tag}]"}",
                              style: LocalTextTheme.tablebody,
                            ),
                            Material(
                              color: LocalColors.white,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: NumberInputField(
                                  isAutoValidate: true,
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                  validator: widget.userModel.userType == "Vendor"
                                      ? null
                                      : (String value) {
                                          if ((double.tryParse(model.orderList[index].price.text) ??
                                                  0) <
                                              double.tryParse(
                                                  model.orderList[index].product.unitMinimumPrice))
                                            return "Price Too Low";
                                          return null;
                                        },
                                  isEnabled: widget.userModel.userType == "Vendor" ||
                                      widget.userModel.userRole.canEditPriceForOrders,
                                  controller: model.orderList[index].price,
                                ),
                              ),
                            ),
                            Material(
                              color: LocalColors.white,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: NumberInputField(
                                    controller: model.orderList[index].quantity,
                                    isAutoValidate: true,
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    validator: (val) {
                                      print(model.orderList[index].product.quantityRemaining);
                                      if (model.orderList[index].product.autoTrackConsignment) {
                                        if ((double.tryParse(
                                                    model.orderList[index].quantity.text) ??
                                                0) >
                                            model.orderList[index].product.quantityRemaining)
                                          return "Too much";
                                      }
                                    }),
                              ),
                            ),
                            Material(
                              child: ThemeDropDown(
                                color: LocalColors.offWhite,
                                margin: 0,
                                padding: 1,
                                onChanged: (value) {
                                  model.onTag(value, index);
                                },
                                value: model.orderList[index].tag,
                                items: [
                                  DropdownMenuItem(
                                    value: "",
                                    child: Text(
                                      "None",
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: LocalTextTheme.tablebody,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "Takeaway",
                                    child: Text(
                                      "Takeaway",
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: LocalTextTheme.tablebody,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: LocalColors.white,
                              child: InkWell(
                                onTap: () {
                                  model.removeFromOrderList(index);
                                },
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: LocalColors.error.withOpacity(0.9),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: LocalColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(7.5),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryLongButton(
                        text:
                            "Add Items (GHS ${model.orderList.fold<double>(0, (previousValue, element) => previousValue + (double.tryParse(element.price.text) ?? 0) * (int.tryParse(element.quantity.text) ?? 1))})",
                        onPressed: () {
                          model.onPlaceOrder(widget.orderId, context);
                        },
                      ),
                    ),
                    SizedBox(width: ConstantValues.PadWide),
                    Expanded(
                      child: PrimaryLongButton(
                        text: "Clear Orders",
                        color: LocalColors.error,
                        onPressed: () {
                          model.onClearList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class PlaceOrderProductsList extends StatelessWidget {
  PlaceOrderProductsList({Key key}) : super(key: key);
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddItemViewModel>(builder: (context, model, _) {
      return Column(
        children: [
          Container(
            height: 50,
            child: Material(
              color: LocalColors.white,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(
                      ConstantValues.PadSmall * (2 / 3),
                    ),
                    child: TextField(
                      onChanged: model.onSearch,
                      decoration: inputDecoration(hintText: "Search Product"),
                    ),
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: LocalColors.white,
              child: model.isProductsLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: LocalColors.primaryColor,
                      ),
                    )
                  : Scrollbar(
                      controller: _controller,
                      isAlwaysShown: true,
                      child: ListView.separated(
                        controller: _controller,
                        itemCount: model.productsDisplay.length,
                        itemBuilder: (context, index) {
                          return Material(
                            color: LocalColors.white,
                            child: InkWell(
                              onTap: () {
                                model.updateOrderList(model.productsDisplay[index]);
                              },
                              child: Container(
                                color: model.productsDisplay[index].autoTrackConsignment &&
                                        model.productsDisplay[index].quantityRemaining == 0
                                    ? LocalColors.grey.withOpacity(0.5)
                                    : LocalColors.white,
                                padding: EdgeInsets.all(ConstantValues.PadSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        model.productsDisplay[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: LocalColors.black,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "GHS ${model.productsDisplay[index].unitSellingPrice}",
                                      style: TextStyle(
                                        color: LocalColors.black,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: LocalColors.grey,
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
