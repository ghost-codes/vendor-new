import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class CreateTabViewModel extends BaseModel {
  Api _api = sl<Api>();

  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  onCreateTab(String branchId, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    var res = await _api.createCreditTab({
      "branch": branchId,
      "name": name.text,
      "description": description.text,
    });
    isLoading = false;
    if (res != null) {
      Navigator.of(context).pop(true);
    }
    notifyListeners();
  }
}
