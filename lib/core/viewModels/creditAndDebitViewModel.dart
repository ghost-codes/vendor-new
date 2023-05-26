import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/tabModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class CreditViewModel extends BaseModel {
  Api _api = sl<Api>();

  List<TabModel> tabs = [];

  String branchId;

  bool isCreditDetail = false;
  bool isLoading = false;
  bool isRecordDetail = false;

  TabModel selectedTab;
  Record selectedRecord;

  setCreditDetail(bool x, {TabModel model}) {
    isCreditDetail = x;
    if (x) {
      selectedTab = model;
    }
    notifyListeners();
  }

  setRecordDetail(bool x, {Record record}) {
    isRecordDetail = x;
    if (x) {
      selectedRecord = record;
    }
    notifyListeners();
  }

  refresh() async {
    isLoading = true;
    notifyListeners();
    tabs = await _api.getAllTabs(branchId);
    if (isCreditDetail) {
      selectedTab = tabs.singleWhere((element) => element.id == selectedTab.id);
    }
    isLoading = false;
    notifyListeners();
  }

  init(String x) async {
    branchId = x;
    isLoading = true;
    notifyListeners();
    tabs = await _api.getAllTabs(branchId);

    isLoading = false;
    notifyListeners();
  }
}
