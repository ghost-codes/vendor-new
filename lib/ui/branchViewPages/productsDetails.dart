import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/productHistoryModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/ProductViewModel.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: LocalColors.offWhite,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: LocalColors.white,
                    boxShadow: ConstantValues.baseShadow,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                  ),
                  padding: EdgeInsets.all(ConstantValues.PadWide),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Details", style: LocalTextTheme.headerMain),
                      SizedBox(
                        height: ConstantValues.PadSmall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: " + model.selectedProduct.name,
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Autotrack Consignment: " +
                                    model.selectedProduct.autoTrackConsignment
                                        .toString(),
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Cost Price: " +
                                    model.selectedProduct.unitCostPrice,
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Minimum Selling Price: " +
                                    model.selectedProduct.unitMinimumPrice,
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Selling Price: " +
                                    model.selectedProduct.unitSellingPrice,
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Batch Code: " +
                                    model.selectedProduct.batchCode,
                                style: LocalTextTheme.body,
                              ),
                            ],
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: ConstantValues.PadWide),
                            child: model.selectedProduct.image == null
                                ? Image.asset(
                                    "assets/images/collection.png",
                                    color: LocalColors.grey,
                                    width: 150,
                                  )
                                : Center(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: LocalColors.black, width: 1),
                                        borderRadius: BorderRadius.circular(75),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: Image.network(
                                          "https://api.vendoorr.com${model.selectedProduct.image}",
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ConstantValues.PadSmall,
                ),
                Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    color: LocalColors.white,
                    boxShadow: ConstantValues.baseShadow,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                  ),
                  padding: EdgeInsets.all(ConstantValues.PadWide),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product History", style: LocalTextTheme.headerMain),
                      Expanded(
                        child: model.isProductHistoryLoading
                            ? Center(child: Loaders.fadingCube)
                            : model.selectedProductHistoryModel.length == 0
                                ? Center(
                                    child: Text(
                                      "No Product History To Show",
                                      style: LocalTextTheme.tableHeader,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: model
                                        .selectedProductHistoryModel.length,
                                    itemBuilder: (context, index) {
                                      return ProductHistoryTile(
                                        productHistoryModel: model
                                            .selectedProductHistoryModel[index],
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProductHistoryTile extends StatelessWidget {
  const ProductHistoryTile({
    Key key,
    this.productHistoryModel,
  }) : super(key: key);

  final ProductHistoryModel productHistoryModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ConstantValues.PadWide),
        constraints: BoxConstraints(maxHeight: 200),
        width: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      color: LocalColors.grey.withOpacity(0.6),
                      width: 3,
                      height: double.infinity,
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: LocalColors.grey.withOpacity(0.15),
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: LocalColors.secodaryColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: LocalColors.white,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                    boxShadow: ConstantValues.baseShadow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Description: ",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${productHistoryModel.description}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Type: ",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${productHistoryModel.actionType}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Quantity: ",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${productHistoryModel.quantity}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Attendant: ",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${productHistoryModel.attendant}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Total Remaining Items: ",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${productHistoryModel.totalRemaining}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Autotrack Items: ",
                          style: TextStyle(
                            color: LocalColors.primaryColor,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${productHistoryModel.autoTracked}",
                          style: TextStyle(
                            color: LocalColors.black,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ]),
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        productHistoryModel.modified,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: LocalColors.black,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
