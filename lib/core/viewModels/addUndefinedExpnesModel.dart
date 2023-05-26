import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class AddUndefinedExpenseModel extends BaseModel {
  Api _api = sl<Api>();

  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

  init(String branchId) async {
    var x = await _api.getExpenses(branchId);
  }

  onSubmit(String branchId, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    var res = await _api.addExpense({
      "branch": branchId,
      "name": name.text,
      "description": description.text,
      "amount": amount.text
    });
    isLoading = false;
    notifyListeners();
    if (res) {
      Navigator.of(context).pop(true);
    }
  }
}
