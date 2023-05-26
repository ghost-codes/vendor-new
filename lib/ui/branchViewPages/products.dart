import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/ProductViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchViewPages/productsDetails.dart';
import 'package:vendoorr/ui/widgets/addCategory.dart';
import 'package:vendoorr/ui/widgets/addProducts.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/editProductView.dart';
import 'package:vendoorr/ui/widgets/productCategory.dart';
import 'package:vendoorr/ui/widgets/productList.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/updateStockView.dart';

class ProductsView extends StatefulWidget {
  final String branchId;
  final String rootCategory;

  const ProductsView({Key key, this.branchId, this.rootCategory})
      : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductViewModel>(
      onModelReady: (model) {
        model.getRootCategory(widget.branchId);
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: LocalColors.offWhite,
          body: model.isLoading
              ? Center(
                  child: Loaders.fadingCube,
                )
              : Column(
                  children: [
                    Consumer2<RootProvider, UserModel>(
                      builder: (context, rootProv, userModel, _) {
                        return BaseHeader(
                          backLogic: model.categoryIds.length > 0 ||
                                  model.isAllProducts
                              ? InkWell(
                                  onTap: () {
                                    isSearching = false;
                                    if (model.isProductDetail) {
                                      model.setIsProductDetail(
                                        false,
                                        canManageProduct:
                                            (userModel.userType == "Vendor" ||
                                                userModel.userRole
                                                    .canManageProducts),
                                      );
                                    } else {
                                      if (model.showUpdateStock)
                                        model.onProductUpdate();
                                      else
                                        model.onBackPressed(widget.branchId);
                                    }
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
                          button: Row(
                            children: [
                              if ((!model.isProductDetail &&
                                      model.currentCategory != null &&
                                      model.currentCategory.isEnd) ||
                                  model.isAllProducts) ...[
                                if (!isSearching)
                                  SmallPrimaryButton(
                                      icon: Icons.search,
                                      onPressed: () async {
                                        setState(() {
                                          isSearching = true;
                                        });
                                      }),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                              model.isAllProducts
                                  ? SizedBox.shrink()
                                  : (model.currentCategory == null ||
                                          !model.currentCategory.isEnd)
                                      ? Visibility(
                                          visible:
                                              userModel.userType == "Vendor" ||
                                                  userModel.userRole
                                                      .canCreateProducts,
                                          child: SmallPrimaryButton(
                                            onPressed: () async {
                                              bool result = await showDialog(
                                                  barrierColor: LocalColors
                                                      .primaryColor
                                                      .withOpacity(0.2),
                                                  context: context,
                                                  builder: (context) {
                                                    return AddCategory(
                                                      branchId: widget.branchId,
                                                      categoryId:
                                                          model.currentCategory ==
                                                                  null
                                                              ? widget.branchId
                                                              : model
                                                                  .currentCategory
                                                                  .id,
                                                    );
                                                  });

                                              if (result) {
                                                model.refreshCategory(
                                                    widget.branchId);
                                              }
                                            },
                                            text: "+ Category",
                                          ),
                                        )
                                      : model.isProductDetail
                                          ? Visibility(
                                              visible: userModel.userType ==
                                                      "Vendor" ||
                                                  userModel.userRole
                                                      .canManageProducts,
                                              child: SmallPrimaryButton(
                                                onPressed: () async {
                                                  Map<String, dynamic> result =
                                                      await showDialog(
                                                          barrierColor:
                                                              LocalColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.15),
                                                          context: context,
                                                          builder: (context) {
                                                            return EditProductView(
                                                              productModel: model
                                                                  .selectedProduct,
                                                            );
                                                          });

                                                  if (result["isDeleted"] ??
                                                      false) {
                                                    model.setIsProductDetail(
                                                        false,
                                                        canManageProduct: userModel
                                                            .userRole
                                                            .canManageProducts,
                                                        reload: true);
                                                  } else if (result["reload"] ??
                                                      false) {
                                                    model.setIsProductDetail(
                                                        true,
                                                        canManageProduct: (userModel
                                                                    .userType ==
                                                                "Vendor" ||
                                                            userModel.userRole
                                                                .canManageProducts),
                                                        reload: true);
                                                  }
                                                },
                                                text: "Edit",
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                Visibility(
                                                  visible: userModel.userType ==
                                                          "Vendor" ||
                                                      userModel.userRole
                                                          .canCreateProducts,
                                                  child: SmallPrimaryButton(
                                                    onPressed: () async {
                                                      bool result =
                                                          await showDialog(
                                                              barrierColor:
                                                                  LocalColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.15),
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AddProduct(
                                                                    categoryId: model
                                                                        .currentCategory
                                                                        .id);
                                                              });
                                                      if (result) {
                                                        model.setIsProductDetail(
                                                            false,
                                                            canManageProduct: (userModel
                                                                        .userType ==
                                                                    "Vendor" ||
                                                                userModel
                                                                    .userRole
                                                                    .canManageProducts),
                                                            reload: true);
                                                      }
                                                    },
                                                    text: "+ Product",
                                                  ),
                                                ),
                                              ],
                                            ),
                            ],
                          ),
                          midSection: isSearching && !model.isProductDetail
                              ? Row(
                                  children: [
                                    Container(
                                      width: 400,
                                      height: 40,
                                      child: Center(
                                        child: TextField(
                                          onChanged: model.onProductSearch,
                                          decoration: inputDecoration(
                                              hintText: "Search",
                                              suffix: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isSearching = false;
                                                    });
                                                    model.onSearchClear();
                                                  },
                                                  icon: Icon(Icons.close))),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  model.isAllProducts
                                      ? "All Product (${rootProv.header})"
                                      : model.currentCategory != null
                                          ? "${model.currentCategory.name} (${rootProv.header})"
                                          : "Product Categories (${rootProv.header})",
                                  style: LocalTextTheme.headerMain,
                                ),
                        );
                      },
                    ),
                    SizedBox(height: ConstantValues.PadSmall),
                    Expanded(
                      child: model.showUpdateStock
                          ? ProductDetails()
                          : (model.currentCategory == null ||
                                      !model.currentCategory.isEnd) &&
                                  !model.isAllProducts
                              ? ProductCategory(
                                  branchId: widget.branchId,
                                  subCategories: model.currentData == null
                                      ? []
                                      : model.currentData,
                                  isRoot: model.currentCategory == null,
                                )
                              : ProductList(
                                  branchId: widget.branchId,
                                  products: model.currentDisplayData,
                                ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductViewModel, RootProvider>(
        builder: (context, model, rootProv, child) {
      return Container(
        decoration: BoxDecoration(
          color: LocalColors.white,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          boxShadow: ConstantValues.baseShadow,
        ),
        child: Padding(
          padding: EdgeInsets.all(ConstantValues.PadSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // model.pageNumber > 0
              false
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, color: LocalColors.black),
                      onPressed: () {
                        // model.pageDecrement();
                      })
                  : SizedBox.shrink(),
              Expanded(
                  child: Text(
                "Product Categories (${rootProv.header})",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              )),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                        color: LocalColors.primaryColor,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "+ Add Category",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          color: LocalColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ConstantValues.PadSmall,
                  ),
                  Consumer<RootProvider>(builder: (context, rootProv, _) {
                    return IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          rootProv.setBranchSelectedtrue("Branches");
                        });
                  }),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
