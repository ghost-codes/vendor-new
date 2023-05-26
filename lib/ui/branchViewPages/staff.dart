import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/staffModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/addStaffViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/staffViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/editStaffModal.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class StaffView extends StatefulWidget {
  final String branchId;

  const StaffView({Key key, this.branchId}) : super(key: key);

  @override
  _StaffViewState createState() => _StaffViewState();
}

class _StaffViewState extends State<StaffView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<StaffViewModel>(onModelReady: (model) {
      model.getStaff(widget.branchId);
    }, builder: (context, model, _) {
      return model.state == ViewState.Idle
          ? Container(
              // margin: EdgeInsets.symmetric(horizontal: ConstantValues.PadWide),
              child: Column(
                children: [
                  Consumer2<RootProvider, UserModel>(
                      builder: (context, rootProv, userModel, _) {
                    return BaseHeader(
                      backLogic: Visibility(
                        visible: (model.isStaffDetails &&
                            model.selectedStaff != null),
                        child: SmallPrimaryButton(
                            icon: Icons.arrow_back,
                            onPressed: () {
                              model.setStaffDetail();
                            }),
                      ),
                      button: (model.isStaffDetails &&
                              model.selectedStaff != null)
                          ? Row(
                              children: [
                                Visibility(
                                  visible: userModel.userType == "Vendor" ||
                                      userModel.userRole.canManageStaff,
                                  child: SmallPrimaryButton(
                                    text: "Edit",
                                    onPressed: () async {
                                      bool result = await showDialog(
                                          barrierColor: LocalColors.primaryColor
                                              .withOpacity(0.15),
                                          context: context,
                                          builder: (context) {
                                            return UpdateStaff(widget.branchId,
                                                model.selectedStaff);
                                          });
                                      // if (result) {
                                      await model.getStaff(widget.branchId);
                                      model.selectedStaff = model.staff
                                          .firstWhere((element) =>
                                              element.id ==
                                              model.selectedStaff.id);
                                      // }
                                    },
                                  ),
                                ),
                                SizedBox(width: 15),
                                Visibility(
                                  visible: userModel.userType == "Vendor" ||
                                      userModel.userRole.canManageStaff,
                                  child: SmallSecondaryButton(
                                    text: "Delete",
                                    onPressed: () async {
                                      bool result = await showDialog(
                                          barrierColor: LocalColors.primaryColor
                                              .withOpacity(0.15),
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: LocalColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.all(15),
                                                width: 400,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Are you sure you want to delete this staff",
                                                      style:
                                                          LocalTextTheme.header,
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              SmallPrimaryButton(
                                                            text: "Delete",
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  true);
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              SmallSecondaryButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  false);
                                                            },
                                                            text: "Cancel",
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                      if (result) {
                                        model.deleteStaff(widget.branchId);
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Visibility(
                                  visible: userModel.userType == "Vendor" ||
                                      userModel.userRole.canCreateStaff,
                                  child: SmallPrimaryButton(
                                    text: "+ Staff",
                                    onPressed: () async {
                                      bool result = await showDialog(
                                          barrierColor: LocalColors.primaryColor
                                              .withOpacity(0.15),
                                          context: context,
                                          builder: (context) {
                                            return AddStaff(
                                              widget.branchId,
                                            );
                                          });
                                      if (result) {
                                        model.getStaff(widget.branchId);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                      midSection: Text(
                        "Staff (${rootProv.header})",
                        style: LocalTextTheme.headerMain,
                      ),
                    );
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  (model.isStaffDetails && model.selectedStaff != null)
                      ? StaffDetails(branchId: widget.branchId)
                      : StaffList(
                          branchId: widget.branchId,
                        )
                ],
              ),
            )
          : Center(
              child: Loaders.fadingCube,
            );
    });
  }

  Widget staffCard(StaffModel staff) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        color: LocalColors.white,
      ),
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return CircleAvatar(
                radius: constraints.maxHeight / 2,
                backgroundColor: LocalColors.offWhite,
              );
            }),
          ),
          SizedBox(height: 15),
          Text(
            staff.name,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            staff.username,
            style: TextStyle(
              fontFamily: "Montserrat",
            ),
          ),
          Text(
            staff.phone,
            style: TextStyle(
              fontFamily: "Montserrat",
            ),
          ),
          SizedBox(height: 20),
          Text(
            staff.description,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AddStaffGroup extends Modal {
  @override
  Widget build(BuildContext context) {
    return buildBackdropFilter(
      width: 450,
      confirmText: "Create Group",
      header: "Add Staff Group",
      closeFunction: () {
        Navigator.pop(context);
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mainContent(),
            // SizedBox(height: 30),
            // confirmationsButtons(context),
          ],
        ),
      ),
    );
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
    return Material(
      color: LocalColors.white,
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFormField(
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Name")),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: LocalColors.grey, width: 1),
              ),
              child: ThemeDropDown(
                items: [
                  DropdownMenuItem(
                    child: DropdownMenuItem(
                      child: Text(
                        "Preset",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: LocalColors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddStaff extends Modal {
  final String branchId;

  AddStaff(this.branchId);
  @override
  Widget build(BuildContext context) {
    return BaseView<AddStaffViewModel>(onModelReady: (model) async {
      model.init();
    }, builder: (context, model, child) {
      return buildBackdropFilter(
        width: 450,
        loader: Loaders.fadinCubeWhiteSmall,
        isLoading: model.isLoading,
        header: "Add Product",
        closeFunction: () {
          Navigator.pop(context, false);
        },
        submitFunction: () {
          model.onSubmit(context, branchId);
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
    return Consumer<AddStaffViewModel>(builder: (context, model, child) {
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
                  // validator: model.requiredFieldValidator,
                  controller: model.username,
                  style: TextStyle(fontFamily: "Montserrat"),
                  decoration: inputDecoration(hintText: "Username *")),
              SizedBox(height: 10),
              TextFormField(
                  // validator: model.requiredFieldValidator,
                  controller: model.nameController,
                  style: TextStyle(fontFamily: "Montserrat"),
                  decoration: inputDecoration(hintText: "Name*")),
              SizedBox(height: 10),
              TextFormField(
                controller: model.phone,
                style: TextStyle(fontFamily: "Montserrat"),
                maxLength: 9,
                validator: (String val) {
                  if (val != null && val.length == 9) return null;
                  return "Number must be of 9 characters";
                },
                decoration: inputDecoration(
                  hintText: "Phone *",
                  prefix: Text(
                    "+233 ",
                    style: TextStyle(
                      color: LocalColors.grey,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
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
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name),
                            value: e.id,
                          ))
                      .toList()
                ],
                onChanged: model.onUserRoleChanged,
              ),
              SizedBox(height: 10),
              TextFormField(
                // validator: model.requiredNumbervalidator,
                controller: model.description,
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Description"),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class StaffList extends StatefulWidget {
  const StaffList({Key key, @required this.branchId}) : super(key: key);
  final String branchId;

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  final flexes = [1, 4, 2, 2, 1];

  bool isHovered = false;
  int hoveredIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<StaffViewModel>(builder: (_, model, __) {
      return model.staff.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Staff Available",
                    style: LocalTextTheme.headerMain,
                  ),
                  SizedBox(
                    height: ConstantValues.PadSmall,
                  ),
                  SmallSecondaryButton(
                    text: "Refresh",
                    onPressed: () {
                      model.getStaff(widget.branchId);
                    },
                  )
                ],
              ),
            )
          : Expanded(
              child: Container(
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
                          "Contact",
                          textAlign: TextAlign.center,
                          style: LocalTextTheme.tableHeader,
                        ),
                        Text(
                          "Username",
                          textAlign: TextAlign.center,
                          style: LocalTextTheme.tableHeader,
                        ),
                      ]),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: model.staff.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = index;
                                });
                              },
                              onTap: () {
                                model.setStaffDetail(staff: model.staff[index]);
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
                                        color:
                                            LocalColors.grey.withOpacity(0.3),
                                      ),
                                      child: model.staff[index].photo == null ||
                                              model.staff[index].photo == ''
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: SvgPicture.asset(
                                                "assets/svgs/person.svg",
                                                color: LocalColors.grey,
                                                width: 20,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                "https://api.vendoorr.com${model.staff[index].photo}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Text(
                                    model.staff[index].name,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.staff[index].phone,
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.staff[index].username,
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
            );
    });
  }
}

class StaffDetails extends StatefulWidget {
  const StaffDetails({Key key, @required this.branchId}) : super(key: key);
  final String branchId;

  @override
  _StaffDetailsState createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StaffViewModel>(
      builder: (_, model, __) {
        return Center(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                decoration: BoxDecoration(
                  boxShadow: ConstantValues.baseShadow,
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                  color: LocalColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Staff Details",
                          style: LocalTextTheme.pageHeader(),
                        ),
                      ],
                    ),
                    Container(
                      // height: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${model.selectedStaff.name}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "Username: ${model.selectedStaff.username}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "User Role: ${model.selectedStaff.userRole == null ? "None" : model.selectedStaff.userRoleName}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "Description: ${model.selectedStaff.description.isEmpty ? "None" : model.selectedStaff.description}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "Phone: ${model.selectedStaff.phone}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "Created: ${model.selectedStaff.created}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "Modified: ${model.selectedStaff.modified}",
                                style: LocalTextTheme.body,
                              )
                            ],
                          ),
                          model.selectedStaff.photo == null
                              ? Container(
                                  child: SvgPicture.asset(
                                    "assets/svgs/person.svg",
                                    color: LocalColors.grey,
                                    width: 130,
                                  ),
                                )
                              : Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70),
                                      color: LocalColors.offWhite,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "https://api.vendoorr.com/${model.selectedStaff.photo}"))),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ConstantValues.PadWide,
                    ),
                  ],
                ),
              ),
            ])));
      },
    );
  }
}
