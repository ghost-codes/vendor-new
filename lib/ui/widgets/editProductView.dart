import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/productModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/editProductViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class EditProductView extends Modal {
  final ProductModel productModel;

  EditProductView({this.productModel});

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProductViewModel>(onModelReady: (model) {
      model.initModel(productModel);
    }, builder: (context, model, _) {
      return buildBackdropFilter(
        closeFunction: () {
          Navigator.of(context).pop();
        },
        header: "Edit Product",
        bottomButtons: model.isDelete
            ? Row(
                children: [
                  Expanded(
                    child: PrimaryLongButton(
                      text: "No",
                      onPressed: () {
                        model.setForDelete();
                      },
                    ),
                  ),
                  SizedBox(
                    width: ConstantValues.PadWide,
                  ),
                  Expanded(
                    child: PrimaryLongButton(
                      text: "Delete",
                      isLoading: model.isLoading,
                      loader: Loaders.fadinCubeWhiteSmall,
                      color: LocalColors.error,
                      onPressed: () async {
                        bool done = await model.onDelete();
                        if (done) {
                          Navigator.of(context).pop({"isDeleted": done});
                        }
                      },
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: PrimaryLongButton(
                      text: "Save",
                      onPressed: () {
                        model.onSave(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: ConstantValues.PadWide,
                  ),
                  Expanded(
                    child: PrimaryLongButton(
                      text: "Delete",
                      color: LocalColors.error,
                      onPressed: () {
                        model.setForDelete();
                      },
                    ),
                  ),
                ],
              ),
        width: 450,
        confirmText: "Save",
        child: Material(
          color: LocalColors.white,
          child: model.isDelete
              ? Text(
                  "Are you sure you want to DELETE this product",
                  style: LocalTextTheme.header,
                )
              : productDetails(),
        ),
      );
    });
  }

  Form productDetails() {
    return Form(
      child: Consumer<EditProductViewModel>(builder: (context, model, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image place holder
            Center(
              child: Container(
                width: 150,
                child: Stack(
                  children: [
                    (model.imageFile == null && model.deleteImage) ||
                            (model.product.image == null &&
                                model.imageFile == null)
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
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.upload,
                                        color: LocalColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : model.isImageReadyForUpload ||
                                model.isDoneUploadingImage
                            ? InkWell(
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
                                            image:
                                                MemoryImage(model.imageOutput),
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
                                                  onTap: model
                                                          .isDoneUploadingImage
                                                      ? model.onImageSelect
                                                      : model.uploadNewImage,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: LocalColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      model.isDoneUploadingImage
                                                          ? Icons.upload
                                                          : Icons.check,
                                                      color: LocalColors.white,
                                                    ),
                                                  ),
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
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: LocalColors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
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
                                            image: NetworkImage(
                                                "https://api.vendoorr.com${model.product.image}"),
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
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.upload,
                                                      color: LocalColors.white,
                                                    ),
                                                  ),
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
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: LocalColors.white,
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
                    model.isimageUploading
                        ? Container(
                            height: 150,
                            decoration: BoxDecoration(
                                color: LocalColors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(75)),
                            child: Center(
                              child: Loaders.fadinCubeWhiteSmall,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      enabled: model.isNameEnabled,
                      controller: model.nameController,
                      style: TextStyle(fontFamily: "Montserrat"),
                      decoration: inputDecoration(
                          hintText: "Product Name*",
                          isenabled: model.isNameEnabled)),
                ),
                model.isNameLoading
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: LocalColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                        ),
                        child: Loaders.fadinCubeWhiteSmall)
                    : Container(
                        decoration: BoxDecoration(
                            color: LocalColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius)),
                        child: IconButton(
                          tooltip: "Edit Field",
                          onPressed: () {
                            model.editName();
                          },
                          icon: model.isNameEnabled
                              ? SvgPicture.asset(
                                  "assets/svgs/check.svg",
                                  width: 18,
                                )
                              : SvgPicture.asset(
                                  "assets/svgs/pen.svg",
                                  width: 18,
                                ),
                          color: LocalColors.white,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: model.isBatchCodeEnabled,
                    controller: model.batchCode,
                    style: TextStyle(fontFamily: "Montserrat"),
                    decoration: inputDecoration(
                        hintText: "Batch Code",
                        isenabled: model.isBatchCodeEnabled),
                  ),
                ),
                model.isBatchCodeLoading
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: LocalColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                        ),
                        child: Loaders.fadinCubeWhiteSmall)
                    : Container(
                        decoration: BoxDecoration(
                            color: LocalColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius)),
                        child: IconButton(
                          tooltip: "Edit Field",
                          onPressed: () {
                            model.editBatchCode();
                          },
                          icon: model.isBatchCodeEnabled
                              ? SvgPicture.asset(
                                  "assets/svgs/check.svg",
                                  width: 18,
                                )
                              : SvgPicture.asset(
                                  "assets/svgs/pen.svg",
                                  width: 18,
                                ),
                          color: LocalColors.white,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NumberInputField(
                    controller: model.unitCostPrice,
                    isEnabled: model.isUnitCostPriceEnabled,
                    prefix: "GHS ",
                    hintText: "Unit Cost Price",
                  ),
                ),
                model.isUnitCPLoading
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: LocalColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                        ),
                        child: Loaders.fadinCubeWhiteSmall)
                    : Container(
                        decoration: BoxDecoration(
                            color: LocalColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius)),
                        child: IconButton(
                          tooltip: "Edit Field",
                          onPressed: () {
                            model.editCostPrice();
                          },
                          icon: model.isUnitCostPriceEnabled
                              ? SvgPicture.asset(
                                  "assets/svgs/check.svg",
                                  width: 18,
                                )
                              : SvgPicture.asset(
                                  "assets/svgs/pen.svg",
                                  width: 18,
                                ),
                          color: LocalColors.white,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NumberInputField(
                    isEnabled: model.isUnitMinimumPriceEnabled,
                    hintText: "Unit Minimum Price",
                    controller: model.unitMinimumPrice,
                    prefix: "GHS ",
                  ),
                ),
                model.isUnitMPLoading
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: LocalColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                        ),
                        child: Loaders.fadinCubeWhiteSmall)
                    : Container(
                        decoration: BoxDecoration(
                            color: LocalColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius)),
                        child: IconButton(
                          tooltip: "Edit Field",
                          onPressed: () {
                            model.editMiniPrice();
                          },
                          icon: model.isUnitMinimumPriceEnabled
                              ? SvgPicture.asset(
                                  "assets/svgs/check.svg",
                                  width: 18,
                                )
                              : SvgPicture.asset(
                                  "assets/svgs/pen.svg",
                                  width: 18,
                                ),
                          color: LocalColors.white,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NumberInputField(
                    isEnabled: model.isUnitSellingPriceEnabled,
                    hintText: "Unit Selling Price",
                    prefix: "GHS ",
                    controller: model.unitSellingPrice,
                    canBeEmpty: true,
                  ),
                ),
                model.isUnitSPLoading
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: LocalColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                        ),
                        child: Loaders.fadinCubeWhiteSmall)
                    : Container(
                        decoration: BoxDecoration(
                            color: LocalColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius)),
                        child: IconButton(
                          tooltip: "Edit Field",
                          onPressed: () {
                            model.editSellingPrice();
                          },
                          icon: model.isUnitSellingPriceEnabled
                              ? SvgPicture.asset(
                                  "assets/svgs/check.svg",
                                  width: 18,
                                )
                              : SvgPicture.asset(
                                  "assets/svgs/pen.svg",
                                  width: 18,
                                ),
                          color: LocalColors.white,
                        ),
                      ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              child: Row(
                children: [
                  model.isAutoTrackLoading
                      ? Loaders.fadinCubePrimSmall
                      : Checkbox(
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
            SizedBox(height: 10),
            editField(
              hint: "Description",
              enabled: model.isdescEnvled,
              isLoading: model.isDescLoading,
              controller: model.descController,
              function: model.editDesc,
            )
          ],
        );
      }),
    );
  }

  Widget editField(
      {bool enabled,
      bool isLoading,
      TextEditingController controller,
      String hint,
      Function function}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            style: TextStyle(fontFamily: "Montserrat"),
            maxLines: 3,
            decoration: inputDecoration(hintText: hint, isenabled: enabled),
          ),
        ),
        isLoading
            ? Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: LocalColors.primaryColor,
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                ),
                child: Loaders.fadinCubeWhiteSmall)
            : Container(
                decoration: BoxDecoration(
                    color: LocalColors.primaryColor,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius)),
                child: IconButton(
                  tooltip: "Edit Field",
                  onPressed: () {
                    function();
                  },
                  icon: enabled
                      ? SvgPicture.asset(
                          "assets/svgs/check.svg",
                          width: 18,
                        )
                      : SvgPicture.asset(
                          "assets/svgs/pen.svg",
                          width: 18,
                        ),
                  color: LocalColors.white,
                ),
              ),
      ],
    );
  }

  Widget mainContent() {
    return Consumer<EditProductViewModel>(builder: (context, model, _) {
      return Row(
        children: [
          Expanded(
            child: Container(
              child: Material(
                color: LocalColors.white,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          child: Stack(
                            children: [
                              (model.myFile == null ||
                                      model.imageOutput == null)
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
                                                  color:
                                                      LocalColors.primaryColor,
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
                                              borderRadius:
                                                  BorderRadius.circular(75),
                                              image: DecorationImage(
                                                  image: MemoryImage(
                                                      model.imageOutput),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          model.isImageHovered
                                              ? Container(
                                                  height: 150,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap:
                                                            model.onImageSelect,
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: LocalColors
                                                                  .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: SvgPicture
                                                                .asset(
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: LocalColors
                                                                .error,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/svgs/close.svg",
                                                            color: LocalColors
                                                                .white,
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
                          controller: model.nameController,
                          style: TextStyle(fontFamily: "Montserrat"),
                          decoration:
                              inputDecoration(hintText: "Product Name*")),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: model.batchCode,
                        style: TextStyle(fontFamily: "Montserrat"),
                        decoration: inputDecoration(hintText: "Batch Code"),
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
                      Container(
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: LocalColors.primaryColor,
                              value: model.trackExpiry,
                              onChanged: model.isTrackExpiryChanged,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "Track Expiry",
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
              ),
            ),
          ),
          VerticalDivider(
            color: LocalColors.grey,
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Container(),
          ),
        ],
      );
    });
  }
}
