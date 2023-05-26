import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class CreditOrDebitModalViewModel extends BaseModel {
  bool isLoading = false;
  TextEditingController amount = TextEditingController(text: "0.00");
  TextEditingController description = TextEditingController();

  Api _api = sl<Api>();

  onSubmit(String tabId, int type, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    bool result = await _api.addRecord({
      "value": amount.text,
      "record_type": type,
      "description": description.text,
    }, tabId);
    if (result) {
      Navigator.of(context).pop(true);
    }
    isLoading = false;
    notifyListeners();
  }
}
