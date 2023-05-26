import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/constants.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/addBranchModel.dart';
import 'package:vendoorr/core/viewModels/editBranchViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/dropzoneImage.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class EditBranch extends Modal {
  EditBranch({this.branch, this.vendorName});
  BranchModel branch;
  String vendorName;
  @override
  Widget build(BuildContext context) {
    return BaseView<EditBranchViewModel>(onModelReady: (model) {
      model.init(branch);
    }, builder: (context, model, _) {
      return buildBackdropFilter(
        confirmText: "Save",
        bottomButtons: model.isDelete
            ? PrimaryLongButton(
                loader: Loaders.fadinCubeWhiteSmall,
                isLoading: model.isDeleting,
                text: "Delete",
                color: LocalColors.error.withOpacity(0.7),
                onPressed: () {
                  model.onDelete(context, vendorName);
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
                      model.setIsDelete(true);
                    },
                    color: LocalColors.error.withOpacity(0.8),
                    text: "Delete",
                  )),
                ],
              ),
        width: 400,
        header: model.isDelete ? "Delete Branch" : "Edit Branch",
        closeFunction: () {
          Navigator.of(context).pop(false);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            !model.isDelete ? mainContent() : deleteContent(),
          ],
        ),
      );
    });
  }

  //form for new branch details
  mainContent() {
    return Consumer<EditBranchViewModel>(builder: (context, model, _) {
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
                            (branch.logo == null && model.imageFile == null)
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
                                                    child: model
                                                            .isDoneUploadingImage
                                                        ? SvgPicture.asset(
                                                            "assets/svgs/upload.svg",
                                                            width: 18,
                                                          )
                                                        : SvgPicture.asset(
                                                            "assets/svgs/close.svg",
                                                            width: 18,
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
                                                    child: SvgPicture.asset(
                                                      "assets/svgs/close.svg",
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
                                                "https://api.vendoorr.com${branch.logo}"),
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
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                InkWell(
                                                  onTap: model.onClearImage,
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
                              icon: model.isNameenabled
                                  ? SvgPicture.asset(
                                      "assets/svgs/check.svg",
                                      width: 18,
                                    )
                                  : SvgPicture.asset(
                                      "assets/svgs/pen.svg",
                                      width: 18,
                                    ),
                              color: LocalColors.white),
                        ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: "Montserrat"),
                      decoration: inputDecoration(
                          hintText: "Location",
                          isenabled: model.isLocationenabled),
                      controller: model.locationController,
                      enabled: model.isLocationenabled,
                    ),
                  ),
                  model.isLocationLoading
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
                                model.setEnableLoc();
                              },
                              icon: model.isLocationenabled
                                  ? SvgPicture.asset(
                                      "assets/svgs/check.svg",
                                      width: 18,
                                    )
                                  : SvgPicture.asset(
                                      "assets/svgs/pen.svg",
                                      width: 18,
                                    ),
                              color: LocalColors.white),
                        ),
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
                            icon: model.isDescenabled
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
            ],
          ),
        ),
      );
    });
  }

  deleteContent() {
    return Consumer<EditBranchViewModel>(builder: (context, model, child) {
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
