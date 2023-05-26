import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/branch_productsViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchViewPages/productsDetails.dart';
import 'package:vendoorr/ui/widgets/addProducts.dart';
import 'package:vendoorr/ui/widgets/productTableRow.dart';

class CategoryProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BProductViewModel>(builder: (context, model, _) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Search",
                            labelStyle: TextStyle(
                              color: LocalColors.grey,
                              fontFamily: "Montserrat",
                              fontSize: 13,
                            ),
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: LocalColors.black.withOpacity(0.15),
                            builder: (context) => AddProduct(),
                          );
                        },
                        color: LocalColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius)),
                        child: Text(
                          "Add Product",
                          style: TextStyle(
                              color: LocalColors.white,
                              fontFamily: "Montserrat"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  tableHead(),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return individualProduct(context);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  //Individual Product Display in list
  Widget individualProduct(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetails(),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          color: LocalColors.white,
        ),
        child: LocalTableRow(
          flexes: [1, 5, 2, 2],
          tableRows: [
            CircleAvatar(
              backgroundColor: LocalColors.grey,
            ),
            Text("{Product Name}"),
            Text("{Price.00}"),
            Text("{Quantity}"),
          ],
        ),
      ),
    );
  }

  Widget addProduct(context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          width: 400,
          decoration: BoxDecoration(
            color: LocalColors.white,
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: LocalColors.black.withOpacity(0.4),
                offset: Offset(5, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<BProductViewModel>(builder: (context, model, _) {
                return Material(
                  color: LocalColors.white,
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Product",
                          style: TextStyle(
                              color: LocalColors.primaryColor,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(fontFamily: "Montserrat"),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: UnderlineInputBorder(),
                            labelText: "Product Name",
                            labelStyle: TextStyle(
                              color: LocalColors.grey,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(fontFamily: "Montserrat"),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: UnderlineInputBorder(),
                            labelText: "Price",
                            labelStyle: TextStyle(
                              color: LocalColors.grey,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: model.isQuantifiable
                              ? TextField(
                                  style: TextStyle(fontFamily: "Montserrat"),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: UnderlineInputBorder(),
                                    labelText: "Quantity",
                                    labelStyle: TextStyle(
                                      color: LocalColors.grey,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                )
                              : FocusScope(
                                  node: FocusScopeNode(),
                                  child: TextField(
                                    style: TextStyle(fontFamily: "Montserrat"),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      border: UnderlineInputBorder(),
                                      labelText: "Quantity",
                                      labelStyle: TextStyle(
                                        color: LocalColors.grey,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(fontFamily: "Montserrat"),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: UnderlineInputBorder(),
                            labelText: "Description",
                            labelStyle: TextStyle(
                              color: LocalColors.grey,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: LocalColors.primaryColor,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                    ),
                    color: LocalColors.primaryColor,
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: LocalColors.white,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tableHead() {
    return Container(
      child: LocalTableRow(flexes: [
        1,
        5,
        2,
        2
      ], tableRows: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
              bottom: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
            ),
          ),
          child: Text(
            "Image",
            style: LocalTextTheme.tableHeader,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
              bottom: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
            ),
          ),
          padding: EdgeInsets.all(5),
          child: Text(
            "Name",
            style: LocalTextTheme.tableHeader,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
              bottom: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
            ),
          ),
          padding: EdgeInsets.all(5),
          child: Text(
            "Price(GH)",
            style: LocalTextTheme.tableHeader,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
              bottom: BorderSide(
                style: BorderStyle.solid,
                color: LocalColors.grey,
              ),
            ),
          ),
          padding: EdgeInsets.all(5),
          child: Text(
            "Quantity",
            style: LocalTextTheme.tableHeader,
          ),
        ),
      ]),
    );
  }
}
