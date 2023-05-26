import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/addContactViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class AddContact extends Modal {
  final String branchId;

  AddContact(this.branchId);

  @override
  Widget build(BuildContext context) {
    return BaseView<AddContactViewModel>(builder: (context, model, child) {
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

  mainContent() {
    return Consumer<AddContactViewModel>(builder: (context, model, child) {
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
              TextFormField(
                // validator: model.requiredNumbervalidator,
                controller: model.email,
                style: TextStyle(fontFamily: "Montserrat"),
                decoration: inputDecoration(hintText: "Email"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
