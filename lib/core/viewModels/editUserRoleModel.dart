import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/userRoleEditmodel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class EditUserRoleModel extends BaseModel {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  Api _api = sl<Api>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserRoleDisplayModel userRoleDisplayModel;

  init(UserRoleDisplayModel userRoleDisplayModel) {
    name.text = userRoleDisplayModel.name;
    description.text = userRoleDisplayModel.description;
    this.userRoleDisplayModel = userRoleDisplayModel;
    notifyListeners();
  }

  String requiredFieldValidator(String value) {
    if (value.length == 0) {
      return "Please Enter Field";
    } else {
      return null;
    }
  }

  onSubmit(BuildContext context) async {
    setState(ViewState.Busy);
    final formState = formKey.currentState;
    userRoleDisplayModel.name = name.text;
    userRoleDisplayModel.description = description.text;
    if (formState.validate()) {
      bool result = await _api.updateUserRole(
        userRoleDisplayModel.id,
        userRoleDisplayModel.toJson(),
      );
      if (result) Navigator.pop(context, true);
    }
    setState(ViewState.Idle);
  }
}
