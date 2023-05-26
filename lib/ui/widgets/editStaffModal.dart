import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/staffModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/editStaffViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class UpdateStaff extends Modal {
  final String branchId;
  final StaffModel staffModel;

  UpdateStaff(this.branchId, this.staffModel);
  @override
  Widget build(BuildContext context) {
    return BaseView<EditStaffViewModel>(onModelReady: (model) async {
      model.init(staffModel);
    }, builder: (context, model, child) {
      return buildBackdropFilter(
        width: 450,
        loader: Loaders.fadinCubeWhiteSmall,
        isLoading: model.isLoading,
        header: "Edit Staff",
        closeFunction: () {
          Navigator.pop(context, false);
        },
        submitFunction: () {
          Navigator.pop(context);
        },
        child: model.state == ViewState.Busy
            ? Loaders.fadingCube
            : SingleChildScrollView(
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
          onPressed: () {},
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
    return Consumer<EditStaffViewModel>(builder: (context, model, child) {
      return Material(
        color: LocalColors.white,
        child: Form(
          key: model.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 150,
                  child: Stack(
                    children: [
                      (model.imageFile == null && model.deleteImage) ||
                              (model.staffModel.photo == null &&
                                  model.imageFile == null)
                          ? Stack(
                              children: [
                                SvgPicture.asset(
                                  "assets/svgs/person.svg",
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
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        model.isDoneUploadingImage
                                                            ? Icons.upload
                                                            : Icons.check,
                                                        color:
                                                            LocalColors.white,
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
                                                        color:
                                                            LocalColors.error,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.close,
                                                        color:
                                                            LocalColors.white,
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
                                          borderRadius:
                                              BorderRadius.circular(75),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://api.vendoorr.com${model.staffModel.photo}"),
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
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.upload,
                                                        color:
                                                            LocalColors.white,
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
                                                        color:
                                                            LocalColors.error,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.close,
                                                        color:
                                                            LocalColors.white,
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
                            hintText: "Name*", isenabled: model.isNameEnabled)),
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
                        enabled: model.isUsernameEnabled,
                        controller: model.username,
                        style: TextStyle(fontFamily: "Montserrat"),
                        decoration: inputDecoration(
                            hintText: "Username*",
                            isenabled: model.isUsernameEnabled)),
                  ),
                  model.isUsernameLoading
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
                              model.editUsername();
                            },
                            icon: model.isUsernameEnabled
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
                        enabled: model.isPhoneEnabled,
                        controller: model.phone,
                        style: TextStyle(fontFamily: "Montserrat"),
                        validator: (String val) {
                          if (val != null && val.length == 9) return null;
                          return "Number must be of 9 characters";
                        },
                        decoration: inputDecoration(
                            prefix: Text(
                              "+233 ",
                              style: TextStyle(
                                color: LocalColors.grey,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            hintText: "Phone*",
                            isenabled: model.isPhoneEnabled)),
                  ),
                  model.isPhoneLoading
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
                              final state = model.formKey.currentState;
                              if (state.validate()) model.editPhone();
                            },
                            icon: model.isPhoneEnabled
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  !model.isIsActiveLoading
                      ? Checkbox(
                          value: model.staffStatus,
                          onChanged: model.onIsActiveChanged)
                      : Loaders.fadinCubePrimSmall,
                  SizedBox(
                    width: 15,
                  ),
                  Text("Staff Active Status"),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: model.selectedUserId,
                validator: (String value) {
                  if (value.isEmpty) return "Please select a user role";
                  return null;
                },
                items: [
                  DropdownMenuItem(
                    child: Text(""),
                    value: "",
                  ),
                  ...model.userRoles
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e.id,
                        ),
                      )
                      .toList()
                ],
                onChanged: model.onUserRoleChanged,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        enabled: model.isDescriptionEnabled,
                        controller: model.description,
                        style: TextStyle(fontFamily: "Montserrat"),
                        decoration: inputDecoration(
                            hintText: "Description*",
                            isenabled: model.isDescriptionEnabled)),
                  ),
                  model.isDescriptionLoading
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
                              model.editDescription();
                            },
                            icon: model.isDescriptionEnabled
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
}
