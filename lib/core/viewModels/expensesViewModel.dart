import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/expenseModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class ExpensesViewModel extends BaseModel {
  bool isLoading = false;
  Api _api = sl<Api>();
  List<ExpenseModel> expenses = [];

  init(String branch_id) async {
    isLoading = true;
    notifyListeners();
    expenses = await _api.getExpenses(branch_id);
    isLoading = false;
    notifyListeners();
  }
}
