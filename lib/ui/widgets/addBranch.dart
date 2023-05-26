import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/addBranchModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/dropzoneImage.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class AddBranch extends Modal {
  String vendorName;
  AddBranch({this.vendorName});

  @override
  Widget build(BuildContext context) {
    return BaseView<AddBranchModel>(builder: (context, model, _) {
      return buildBackdropFilter(
        submitFunction: () {
          model.onSubmit(context, vendorName);
        },
        width: 400,
        loader: Loaders.fadinCubeWhiteSmall,
        isLoading: model.isLoading,
        header: "Add New Branch",
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

  //buttons to indicate process being done and cancelled
  confirmationsButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
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
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
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
    );
  }

  //form for new branch details
  mainContent() {
    return Consumer<AddBranchModel>(builder: (context, model, _) {
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
                                  "assets/images/branch1.png",
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
              TextField(
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Branch Name"),
                controller: model.nameController,
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Location"),
                controller: model.locationController,
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
