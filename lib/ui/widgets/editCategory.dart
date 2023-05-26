import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/productCategoryModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';

import 'package:vendoorr/core/util/textThemes.dart';

import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/editCategoryModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class EditCategory extends Modal {
  ProductCategoryModel category;
  bool isRoot = false;
  EditCategory({@required this.category, this.isRoot});

  @override
  Widget build(BuildContext context) {
    return BaseView<EditCategoryModel>(onModelReady: (model) async {
      await model.init(category);
    }, builder: (context, model, _) {
      return buildBackdropFilter(
        bottomButtons: model.isDelete
            ? PrimaryLongButton(
                loader: Loaders.fadinCubeWhiteSmall,
                isLoading: model.isDeleting,
                text: "Delete",
                color: LocalColors.error.withOpacity(0.7),
                onPressed: () {
                  model.onDelete(context);
                },
              )
            : Row(
                children: [
                  Expanded(
                      child: PrimaryLongButton(
                    onPressed: () {
                      model.onSave(context);
                    },
                    text: "Ok",
                  )),
                  SizedBox(
                    width: ConstantValues.PadSmall,
                  ),
                  Expanded(
                      child: PrimaryLongButton(
                    onPressed: () {
                      model.setIsDelete();
                    },
                    color: LocalColors.error.withOpacity(0.8),
                    text: "Delete",
                  )),
                ],
              ),
        width: 400,
        loader: Loaders.fadinCubeWhiteSmall,
        isLoading: model.isLoading,
        header: model.isDelete
            ? "Delete Product Category"
            : "Edit Product Category",
        closeFunction: () {
          Navigator.of(context).pop(false);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            model.isDelete ? deleteContent() : mainContent(),
          ],
        ),
      );
    });
  }

  //form for new branch details
  mainContent() {
    return Consumer<EditCategoryModel>(builder: (context, model, _) {
      return Material(
        color: LocalColors.white,
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: Stack(
                  children: [
                    (model.imageFile == null && model.deleteImage) ||
                            (category.image == null && model.imageFile == null)
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
                                                  onTap:
                                                      model.isDoneUploadingImage
                                                          ? model.onImageSelect
                                                          : model.uploadNewLogo,
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
                                                "https://api.vendoorr.com${model.category.image}"),
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: "Montserrat"),
                      decoration: inputDecoration(
                          hintText: "Branch Name",
                          isenabled: model.isNameenabled),
                      controller: model.nameController,
                      enabled: model.isNameenabled,
                    ),
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
                              model.setEnablename();
                            },
                            icon: Icon(
                              model.isNameenabled
                                  ? Icons.check
                                  : Icons.edit_outlined,
                              color: LocalColors.white,
                            ),
                          ),
                        )
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: "Montserrat"),
                      decoration: inputDecoration(
                          hintText: "Description",
                          isenabled: model.isDescenabled),
                      controller: model.descController,
                      maxLines: 5,
                      enabled: model.isDescenabled,
                    ),
                  ),
                  model.isDesLoading
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
                                model.setEnableDesc();
                              },
                              icon: Icon(
                                  model.isDescenabled
                                      ? Icons.check
                                      : Icons.edit_outlined,
                                  color: LocalColors.white)),
                        ),
                ],
              ),
              SizedBox(
                height: ConstantValues.PadWide,
              ),
              isRoot
                  ? Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Set Printer",
                        style: LocalTextTheme.tableHeader,
                        textAlign: TextAlign.left,
                      ),
                    )
                  : SizedBox.shrink(),
              isRoot
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 1,
                          color: LocalColors.grey,
                        ),
                      ),
                      child: ThemeDropDown(
                        value: model.assignedPrinter,
                        onChanged: (value) {
                          model.onChange(value);
                        },
                        items: List.generate(
                            model.printerVars.length,
                            (index) => DropdownMenuItem(
                                  child: Text(model.printerVars[index]),
                                  value: model.printerVars[index],
                                )),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }

  deleteContent() {
    return Consumer<EditCategoryModel>(builder: (context, model, child) {
      return Material(
        color: LocalColors.white,
        child: Column(
          children: [
            TextField(
              style: TextStyle(fontFamily: "Montserrat"),
              obscureText: true,
              decoration: inputDecoration(hintText: "Delete"),
              controller: model.deleteController,
            ),
          ],
        ),
      );
    });
  }
}
