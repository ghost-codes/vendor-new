import 'package:fdottedline/fdottedline.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/productCategoryModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';

import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';

import 'package:vendoorr/core/viewModels/ProductViewModel.dart';
import 'package:vendoorr/ui/widgets/editCategory.dart';

class ProductCategory extends StatelessWidget {
  bool isRoot = false;
  final List<dynamic> subCategories;
  final String branchId;
  ProductCategory({Key key, this.isRoot, this.subCategories, this.branchId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(builder: (context, model, _) {
      return model.isLoading
          ? Center(
              child: Loaders.fadingCube,
            )
          : subCategories.length == 0
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Product Categories To Show",
                      style: LocalTextTheme.tableHeader,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SmallSecondaryButton(
                      onPressed: () async {
                        model.refresh(branchId);
                        // model.refreshTest();
                      },
                      text: "Refresh",
                    ),
                  ],
                ))
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                          itemCount: isRoot
                              ? subCategories.length + 1
                              : subCategories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1 / 1.3,
                            crossAxisSpacing: ConstantValues.PadSmall,
                            mainAxisSpacing: ConstantValues.PadSmall,
                          ),
                          itemBuilder: (context, index) {
                            int x = isRoot ? index - 1 : index;

                            //All Product Card
                            if (index == 0 && isRoot) {
                              return InkWell(
                                  onTap: () {
                                    model.onAllProductsSelected(branchId);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    child: FDottedLine(
                                      color: LocalColors.primaryColor,
                                      width: 2,
                                      strokeWidth: 2,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            ConstantValues.BorderRadius,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/collection.png",
                                              color: LocalColors.grey,
                                              width: 150,
                                            ),
                                            SizedBox(
                                              height: ConstantValues.PadWide,
                                            ),
                                            Center(
                                              child: Text(
                                                "All products",
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            }

                            return InkWell(
                              onTap: () {
                                model.onSelectedCategory(subCategories[x]);
                              },
                              child: Container(
                                padding: EdgeInsets.all(ConstantValues.PadWide),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ConstantValues.BorderRadius),
                                  color: LocalColors.white,
                                  boxShadow: ConstantValues.baseShadow,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            bool response = await showDialog(
                                              barrierColor: LocalColors
                                                  .primaryColor
                                                  .withOpacity(0.15),
                                              context: context,
                                              builder: (context) {
                                                return EditCategory(
                                                  category: subCategories[x],
                                                  isRoot: isRoot,
                                                );
                                              },
                                            );
                                            if (response) {
                                              model.refreshCategory(branchId);
                                            }
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svgs/expand.svg',
                                            width: 18,
                                            color: LocalColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: subCategories[x].image == null
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
                                                      color: LocalColors.black,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(75),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(75),
                                                  child: Image.network(
                                                    "https://api.vendoorr.com${subCategories[x].image}",
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child, progress) {
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
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subCategories[
                                                    isRoot ? index - 1 : index]
                                                .name,
                                            style: TextStyle(
                                              color: LocalColors.primaryColor,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: ConstantValues.PadSmall / 2,
                                          ),
                                          Text(
                                              "No. of ${subCategories[isRoot ? index - 1 : index].isEnd ? "Products" : "SubCategories"}: ${subCategories[isRoot ? index - 1 : index].numchild}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 45,
                    )
                  ],
                );
    });
  }
}

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 50,
      // height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        color: Colors.white,
      ),
    );
  }
}
