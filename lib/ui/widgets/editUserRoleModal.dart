import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/userRoleEditmodel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/viewModels/addNewUserRoleModel.dart';
import 'package:vendoorr/core/viewModels/editUserRoleModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class EditUserRole extends Modal {
  final UserRoleDisplayModel userRole;

  EditUserRole(this.userRole);

  @override
  Widget build(BuildContext context) {
    return BaseView<EditUserRoleModel>(
      onModelReady: (model) {
        model.init(userRole);
      },
      builder: (context, model, _) => buildBackdropFilter(
          header: "Add User Role",
          confirmText: "save",
          closeFunction: () {
            Navigator.pop(context, false);
          },
          submitFunction: () {
            model.onSubmit(context);
          },
          width: 400,
          child: model.state == ViewState.Busy
              ? Center(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: LocalColors.white),
                      child: Center(child: Loaders.fadingCube)),
                )
              : Material(
                  child: Form(
                    key: model.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            validator: model.requiredFieldValidator,
                            controller: model.name,
                            style: TextStyle(fontFamily: "Montserrat"),
                            decoration:
                                inputDecoration(hintText: "Product Name*")),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: model.description,
                          style: TextStyle(fontFamily: "Montserrat"),
                          maxLines: 3,
                          decoration: inputDecoration(hintText: "Description"),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
