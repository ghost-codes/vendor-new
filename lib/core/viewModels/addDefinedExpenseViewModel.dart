import 'package:vendoorr/core/viewModels/baseModel.dart';

class AddDefinedExpenseViewModel extends BaseModel {
  bool isAddNew = false;

  setIsAddNew(bool value) {
    isAddNew = value;
    notifyListeners();
  }
}
