import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/viewModels/addNewUserRoleModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class AddUserRole extends Modal {
  @override
  Widget build(BuildContext context) {
    return BaseView<AddUserRoleModel>(
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
          child: Material(
            child: Form(
              key: model.formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: model.requiredFieldValidator,
                      controller: model.name,
                      style: TextStyle(fontFamily: "Montserrat"),
                      decoration: inputDecoration(hintText: "Product Name*")),
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
