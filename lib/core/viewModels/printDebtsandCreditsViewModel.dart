import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class PrintDebtorsAndCreditorsViewModel extends BaseModel {
  PrintingService _printingService = sl<PrintingService>();
  Api _api = sl<Api>();

  bool isDebtorsLoading = false;
  bool isCreditorsLoading = false;

  printDebtors(String branch_id) async {
    isDebtorsLoading = true;
    notifyListeners();
    final tabs = await _api.getBranchDebtors(branch_id);
    _printingService.printDebtorOrCreditorTabs(tabs);
    isDebtorsLoading = false;
    notifyListeners();
  }

  printCreditors(String branch_id) async {
    isCreditorsLoading = true;
    notifyListeners();
    final tabs = await _api.getBranchCreditors(branch_id);
    _printingService.printDebtorOrCreditorTabs(tabs);
    isCreditorsLoading = false;
    notifyListeners();
  }
}
