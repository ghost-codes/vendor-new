import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/addProductViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class AddProduct extends Modal {
  final String categoryId;

  AddProduct({this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BaseView<AddProductViewModel>(builder: (context, model, child) {
      return buildBackdropFilter(
        width: 450,
        loader: Loaders.fadinCubeWhiteSmall,
        isLoading: model.isLoading,
        header: "Add Product",
        closeFunction: () {
          Navigator.pop(context, false);
        },
        submitFunction: () {
          model.onSubmit(context, categoryId);
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              mainContent(),
            ],
          ),
        ),
      );
    });
  }

  //form for new branch details
  mainContent() {
    return Consumer<AddProductViewModel>(builder: (context, model, child) {
      return Material(
        color: LocalColors.white,
        child: Form(
          key: model.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image place holder
              Center(
                child: Container(
                  width: 150,
                  child: Stack(
                    children: [
                      (model.myFile == null || model.imageOutput == null)
                          ? Stack(
                              children: [
                                Image.asset(
                                  "assets/images/collection.png",
                                  color: LocalColors.grey,
                                  width: 150,
                                ),
                                Container(
                                  height: 150,
                                  child: Center(
                                    child: InkWell(
                                      onTap: model.onImageSelect,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: LocalColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: SvgPicture.asset(
                                          "assets/svgs/upload.svg",
                                          width: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () {},
                              onHover: model.setIsImageHovered,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          color: LocalColors.grey,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(75),
                                      image: DecorationImage(
                                          image: MemoryImage(model.imageOutput),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  model.isImageHovered
                                      ? Container(
                                          height: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: model.onImageSelect,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: LocalColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child: SvgPicture.asset(
                                                      "assets/svgs/upload.svg",
                                                      width: 18,
                                                    )),
                                              ),
                                              SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  model.onClearImage();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: LocalColors.error,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  child: SvgPicture.asset(
                                                    "assets/svgs/close.svg",
                                                    color: LocalColors.white,
                                                    width: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                  validator: model.requiredFieldValidator,
                  controller: model.nameController,
                  style: TextStyle(fontFamily: "Montserrat"),
                  decoration: inputDecoration(hintText: "Product Name*")),
              SizedBox(height: 10),
              TextFormField(
                controller: model.batchCode,
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Batch Code"),
              ),
              SizedBox(height: 10),
              NumberInputField(
                controller: model.unitCostPrice,
                hintText: "Unit Cost Price *",
              ),

              SizedBox(height: 10),
              NumberInputField(
                controller: model.unitMinimumPrice,
                hintText: "Unit Minimum Price *",
              ),

              SizedBox(height: 10),
              NumberInputField(
                controller: model.unitSellingPrice,
                hintText: "Unit Selling Price",
                canBeEmpty: true,
              ),
              SizedBox(height: 10),
              Container(
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: LocalColors.primaryColor,
                      value: model.isAutoTrackConsignment,
                      onChanged: model.isAutoTrackConsignmentChanged,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Auto Track Consignment",
                        style: LocalTextTheme.body,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: model.descController,
                style: TextStyle(fontFamily: "Montserrat"),
                maxLines: 3,
                decoration: inputDecoration(hintText: "Description"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
