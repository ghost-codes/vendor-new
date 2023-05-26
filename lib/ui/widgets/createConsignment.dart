import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/createConsignmentViewModel.dart';
import 'package:vendoorr/core/viewModels/placeOrderViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class CreateConsignment extends StatefulWidget {
  final String branchId;

  const CreateConsignment({Key key, this.branchId}) : super(key: key);
  @override
  _CreateConsignmentState createState() => _CreateConsignmentState();
}

class _CreateConsignmentState extends State<CreateConsignment>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<CreateConsignmentViewModel>(onModelReady: (model) {
      model.init(widget.branchId);
    }, builder: (context, model, _) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          child: Material(
            child: Container(
              width: model.isReferenceInputPage ? 500 : 950,
              height: model.isReferenceInputPage ? 350 : 600,
              decoration: BoxDecoration(
                color: LocalColors.offWhite,
                boxShadow: ConstantValues.baseShadow,
              ),
              child: model.isReferenceInputPage
                  ? model.isLoading
                      ? Center(child: Loaders.fadingCube)
                      : Center(
                          child: Container(
                            // width: 400,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.all(ConstantValues.PadSmall),
                                  color: LocalColors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              model.setIsReferenceInputPage();
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ConstantValues
                                                            .BorderRadius),
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
                                            "Register Consignment",
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
                                        child: SvgPicture.asset(
                                            "assets/svgs/close.svg",
                                            width: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(ConstantValues.PadWide),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                            controller:
                                                model.referenceController,
                                            decoration: inputDecoration(
                                                hintText: "Reference"),
                                          ),
                                          SizedBox(
                                            height: ConstantValues.PadWide,
                                          ),
                                          TextField(
                                            maxLines: 5,
                                            controller:
                                                model.descriptionController,
                                            decoration: inputDecoration(
                                                hintText: "Description"),
                                          ),
                                          SizedBox(
                                            height: ConstantValues.PadWide,
                                          ),
                                          PrimaryLongButton(
                                            text: "Submit",
                                            onPressed: () {
                                              model.onCreateConsignment(
                                                  widget.branchId, context);
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
                                "Register Consignment",
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
                                child: SvgPicture.asset("assets/svgs/close.svg",
                                    width: 12),
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
                                child: ConsignmentSheet(
                                  branchId: widget.branchId,
                                ),
                              ),
                              VerticalDivider(
                                color: LocalColors.grey,
                                width: 1,
                                thickness: 1,
                              ),
                              Expanded(
                                flex: 3,
                                child: ConsignmentProductsList(
                                  branchId: widget.branchId,
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

class ConsignmentSheet extends StatelessWidget {
  final String branchId;
  const ConsignmentSheet({Key key, this.branchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateConsignmentViewModel>(builder: (context, model, _) {
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
                      flexes: [4, 2, 2, 1],
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
                        Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    model.consignmentList.length,
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
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                        boxShadow: ConstantValues.baseShadow,
                      ),
                      child: ItemListTile(
                        flexes: [4, 2, 2, 1],
                        children: [
                          Text(
                            model.consignmentList[index]["product"].name,
                            style: LocalTextTheme.tablebody,
                          ),
                          Text(
                            model
                                .consignmentList[index]["product"].unitCostPrice
                                .toString(),
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tablebody,
                          ),
                          Material(
                            color: LocalColors.white,
                            child: Container(
                              // width: 30,
                              child: NumberInputField(
                                controller: model.consignmentList[index]
                                    ["controller"],
                              ),
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
                                backgroundColor:
                                    LocalColors.error.withOpacity(0.9),
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(7.5),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryLongButton(
                        text: "Register Consignment",
                        onPressed: () {
                          model.setIsReferenceInputPage();
                        },
                      ),
                    ),
                    SizedBox(width: ConstantValues.PadWide),
                    Expanded(
                      child: PrimaryLongButton(
                        text: "Clear Consignment",
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

class ConsignmentProductsList extends StatelessWidget {
  const ConsignmentProductsList({Key key, this.branchId}) : super(key: key);

  final String branchId;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateConsignmentViewModel>(builder: (context, model, _) {
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
                      : ListView.separated(
                          itemCount: model.productsDisplay.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: LocalColors.white,
                              child: InkWell(
                                onTap: () {
                                  model.updateOrderList(
                                      model.productsDisplay[index]);
                                },
                                child: Container(
                                  color: LocalColors.white,
                                  padding:
                                      EdgeInsets.all(ConstantValues.PadSmall),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        model.productsDisplay[index].name,
                                        style: TextStyle(
                                          color: LocalColors.black,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                      Text(
                                        "GHS ${model.productsDisplay[index].unitCostPrice}",
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
        ],
      );
    });
  }
}
