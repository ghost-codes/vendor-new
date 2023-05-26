import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class AddUserRoleModel extends BaseModel {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  Api _api = sl<Api>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    if (formState.validate()) {
      bool result = await _api
          .createUserRole({"name": name.text, "description": description.text});
      if (result) Navigator.pop(context, true);
    }
    setState(ViewState.Idle);
  }
}
