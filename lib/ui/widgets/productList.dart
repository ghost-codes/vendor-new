import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/models/user.dart';

import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/ProductViewModel.dart';
import 'package:vendoorr/ui/branchViewPages/productsDetails.dart';
import 'package:vendoorr/ui/widgets/editProductView.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';

class ProductList extends StatefulWidget {
  ProductList({Key key, this.products, this.branchId}) : super(key: key);
  List<dynamic> products;
  String branchId;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isHovered = false;
  int hoveredIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(builder: (context, model, _) {
      return Navigator(
        onPopPage: (route, result) {
          return route.didPop(result);
        },
        pages: [
          MaterialPage(
              child: ListOfProducts(
            products: widget.products,
            branchId: widget.branchId,
          )),
          if (model.isProductDetail) MaterialPage(child: ProductDetails()),
        ],
      );
    });
  }
}

class ListOfProducts extends StatefulWidget {
  ListOfProducts({Key key, this.products, this.branchId}) : super(key: key);
  List<dynamic> products;
  String branchId;

  @override
  _ListOfProductsState createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  final flexes = [1, 4, 2, 2, 1];

  bool isHovered = false;
  int hoveredIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductViewModel, UserModel>(
        builder: (context, model, userModel, _) {
      return Container(
        decoration: BoxDecoration(
          color: LocalColors.white,
          boxShadow: ConstantValues.baseShadow,
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.all(ConstantValues.PadSmall),
              decoration: BoxDecoration(
                  color: LocalColors.white,
                  boxShadow: ConstantValues.baseShadow),
              child: ItemListTile(flexes: flexes, children: [
                Text(
                  "Image",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Name",
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Minimum Price",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Quantity",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Auto-Track",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
              ]),
            ),
            Expanded(
              child: widget.products.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Products To Show",
                              style: LocalTextTheme.tableHeader),
                          SmallSecondaryButton(
                            text: "Refresh",
                            onPressed: () {
                              model.refresh(widget.branchId);
                            },
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.products.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onHover: (value) {
                            setState(() {
                              isHovered = value;
                              hoveredIndex = index;
                            });
                          },
                          onTap: () {
                            model.setIsProductDetail(
                              true,
                              product: widget.products[index],
                              canManageProduct:
                                  (userModel.userType == "Vendor" ||
                                      userModel.userRole.canManageProducts),
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                                border: isHovered && hoveredIndex == index
                                    ? Border(
                                        left: BorderSide(
                                        width: 7,
                                        color: LocalColors.primaryColor,
                                      ))
                                    : Border(),
                                color: isHovered && hoveredIndex == index
                                    ? LocalColors.black.withOpacity(0.02)
                                    : Colors.transparent),
                            height: 80,
                            margin: EdgeInsets.only(
                                bottom: ConstantValues.PadSmall),
                            padding: EdgeInsets.symmetric(
                              vertical: ConstantValues.PadSmall,
                              horizontal: ConstantValues.PadWide,
                            ),
                            child: ItemListTile(flexes: flexes, children: [
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: LocalColors.grey.withOpacity(0.3),
                                  ),
                                  child: widget.products[index].image == null
                                      ? null
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            "https://api.vendoorr.com${widget.products[index].image}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                              Text(
                                widget.products[index].name,
                                style: LocalTextTheme.tablebody,
                              ),
                              Text(
                                widget.products[index].unitMinimumPrice,
                                textAlign: TextAlign.center,
                                style: LocalTextTheme.tablebody,
                              ),
                              Text(
                                widget.products[index].quantityRemaining
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: LocalTextTheme.tablebody,
                              ),
                              Text(
                                widget.products[index].autoTrackConsignment
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: LocalTextTheme.tablebody,
                              ),
                            ]),
                          ),
                        );
                      }),
            )
          ],
        ),
      );
    });
  }
}
