import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/addBranchModel.dart';
import 'package:vendoorr/core/viewModels/addCategoryModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/dropzoneImage.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class AddCategory extends Modal {
  String branchId;
  String categoryId;
  AddCategory({@required this.categoryId, @required this.branchId});

  @override
  Widget build(BuildContext context) {
    return BaseView<AddCategoryModel>(builder: (context, model, _) {
      return buildBackdropFilter(
        submitFunction: () {
          model.onSubmit(context, branchId, categoryId);
        },
        width: 400,
        loader: Loaders.fadinCubeWhiteSmall,
        isLoading: model.isLoading,
        header: "Add New Product Category",
        closeFunction: () {
          Navigator.of(context).pop(false);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mainContent(),
          ],
        ),
      );
    });
  }

  //form for new branch details
  mainContent() {
    return Consumer<AddCategoryModel>(builder: (context, model, _) {
      return Material(
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Name"),
                controller: model.nameController,
              ),
              SizedBox(height: 10),
              ThemeDropDown(
                onChanged: model.onDropDownChanged,
                value: model.isEnd,
                items: [
                  DropdownMenuItem(
                      value: true, child: Text("Contains only products")),
                  DropdownMenuItem(
                      value: false, child: Text("Contains only categories"))
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: model.descController,
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Description"),
                maxLines: 5,
              ),
            ],
          ),
        ),
      );
    });
  }
}
