import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nanoid/async.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/placeOrderViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class PlaceOrder extends StatelessWidget {
  final String branchId;
  final UserModel userModel;

  const PlaceOrder({Key key, this.branchId, @required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PlaceOrderModel>(onModelReady: (model) {
      model.init(branchId);
    }, builder: (context, model, _) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          child: Material(
            child: Container(
              width: model.isReferenceInputPage ? 500 : 950,
              height: model.isReferenceInputPage ? 400 : 600,
              decoration: BoxDecoration(
                color: LocalColors.offWhite,
                boxShadow: ConstantValues.baseShadow,
              ),
              child: model.isReferenceInputPage
                  ? model.isLoading
                      ? Center(child: Loaders.fadingCube)
                      : Center(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(ConstantValues.PadSmall),
                                  color: LocalColors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              model.setIsReferenceInputPage();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(right: 10),
                                              padding:
                                                  EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                          ),
                                          Text(
                                            "Place Order",
                                            style: TextStyle(
                                              color: LocalColors.primaryColor,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: SvgPicture.asset("assets/svgs/close.svg", width: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(ConstantValues.PadWide),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: model.referenceController,
                                                  decoration: inputDecoration(
                                                    hintText: "Name",
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async => model.referenceController.text =
                                                    await nanoid(8),
                                                child: Container(
                                                  width: 50,
                                                  child: Icon(Icons.text_snippet),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: ConstantValues.PadWide,
                                          ),
                                          TextField(
                                            controller: model.descriptionController,
                                            decoration: inputDecoration(
                                                prefix: Text("+233 ",
                                                    style: TextStyle(color: LocalColors.grey)),
                                                hintText: "Client Phone"),
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: model.isDiscountPercentage,
                                                onChanged: model.onIsDiscountPercentageChanged,
                                                activeColor: LocalColors.primaryColor,
                                              ),
                                              Text("Is Percentage"),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          TextField(
                                            controller: model.discount,
                                            decoration: inputDecoration(hintText: "Discount"),
                                          ),
                                          SizedBox(
                                            height: ConstantValues.PadWide,
                                          ),
                                          PrimaryLongButton(
                                            text: "Submit",
                                            onPressed: () {
                                              model.onPlaceOrder(branchId, context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                  : Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ConstantValues.PadSmall),
                          color: LocalColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Place Order",
                                style: TextStyle(
                                  color: LocalColors.primaryColor,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop(false);
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
                                child: OrderSheet(
                                    // branchId: widget.branchId,
                                    userModel: userModel),
                              ),
                              VerticalDivider(
                                color: LocalColors.grey,
                                width: 1,
                                thickness: 1,
                              ),
                              Expanded(
                                flex: 3,
                                child: PlaceOrderProductsList(
                                  branchId: branchId,
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

class OrderSheet extends StatefulWidget {
  final UserModel userModel;
  OrderSheet({Key key, @required this.userModel}) : super(key: key);

  @override
  State<OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends State<OrderSheet> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceOrderModel>(builder: (context, model, _) {
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
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          flexes: [4, 3, 2, 2, 1],
                          children: [
                            Text(
                              "${model.orderList[index].name}  ${model.orderList[index].tag == "" ? "" : "[${model.orderList[index].tag}]"}",
                              style: LocalTextTheme.tablebody,
                            ),
                            Material(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: NumberInputField(
                                    isAutoValidate: true,
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    validator: widget.userModel.userType == "Vendor"
                                        ? null
                                        : (String value) {
                                            if ((double.tryParse(
                                                        model.orderList[index].price.text) ??
                                                    0) <
                                                double.tryParse(model.orderList[index].product
                                                    .unitMinimumPrice)) return "Price Too Low";
                                            return null;
                                          },
                                    isEnabled: widget.userModel.userType == "Vendor" ||
                                        widget.userModel.userRole.canEditPriceForOrders,
                                    controller: model.orderList[index].price),
                              ),
                            ),
                            Material(
                              color: LocalColors.white,
                              child: Container(
                                  // width: 30,
                                  margin: EdgeInsets.only(right: 10),
                                  child: NumberInputField(
                                    isAutoValidate: true,
                                    controller: model.orderList[index].quantity,
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    validator: (value) {
                                      print(model.orderList[index].product.quantityRemaining);
                                      if (model.orderList[index].product.autoTrackConsignment) {
                                        if ((double.tryParse(
                                                    model.orderList[index].quantity.text) ??
                                                0) >
                                            model.orderList[index].product.quantityRemaining)
                                          return "Too much";
                                      }
                                      return null;
                                    },
                                  )),
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
                            "Place Order (GHS ${model.orderList.fold<double>(0, (previousValue, element) => previousValue + (double.tryParse(element.price.text) ?? 0) * (int.tryParse(element.quantity.text) ?? 1))})",
                        onPressed: model.orderList.isEmpty
                            ? null
                            : () {
                                final state = _formkey.currentState;
                                if (state.validate()) model.setIsReferenceInputPage();
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
            // SizedBox(
            //   height: 15,
            // ),
          ],
        ),
      );
    });
  }
}

class PlaceOrderProductsList extends StatelessWidget {
  PlaceOrderProductsList({Key key, this.branchId}) : super(key: key);

  final String branchId;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceOrderModel>(builder: (context, model, _) {
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
                  : model.products.length == 0
                      ? Center(
                          child: SmallSecondaryButton(
                            text: "Refresh",
                            onPressed: () {
                              model.init(branchId);
                            },
                          ),
                        )
                      : Scrollbar(
                          controller: _controller,
                          showTrackOnHover: true,
                          isAlwaysShown: true,
                          child: ListView.separated(
                            controller: _controller,
                            itemCount: model.productsDisplay.length,
                            // physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // Scrollbar()
                              ProductModel _product = model.productsDisplay[index];
                              return Material(
                                color: LocalColors.white,
                                child: InkWell(
                                  onTap: () {
                                    model.updateOrderList(_product);
                                  },
                                  child: Container(
                                    color: _product.autoTrackConsignment &&
                                            _product.quantityRemaining == 0
                                        ? LocalColors.grey.withOpacity(0.5)
                                        : LocalColors.white,
                                    padding: EdgeInsets.all(ConstantValues.PadSmall),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            model.productsDisplay[index].name,
                                            style: TextStyle(
                                                color: LocalColors.black,
                                                fontFamily: "Montserrat",
                                                overflow: TextOverflow.ellipsis),
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
