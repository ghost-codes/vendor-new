import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/tabModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class CreditModalViewModel extends BaseModel {
  Api _api = sl<Api>();

  TabModel selectedTab;

  List<TabModel> displayTabs = [];
  List<TabModel> tabs = [];

  bool isLoading = false;
  bool isTabsLoading = false;

  init(String branchId) async {
    isTabsLoading = true;
    notifyListeners();
    tabs = await _api.getAllTabs(branchId);
    displayTabs = tabs;

    isTabsLoading = false;
    notifyListeners();
  }

  onSelectTab(TabModel tab) {
    selectedTab = tab;
    notifyListeners();
  }

  search(String value) {
    var regExp = RegExp("\w*$value\w*", caseSensitive: false);
    if (value == "") {
      displayTabs = tabs;
    } else {
      displayTabs = tabs.where((element) {
        return regExp.hasMatch(element.name);
      }).toList();
    }
    notifyListeners();
  }

  submit(String orderId, BuildContext context) async {
    isLoading = true;
    notifyListeners();
    print(orderId);
    print(selectedTab.id);
    bool result =
        await _api.addOrderToCredit({"order": orderId}, selectedTab.id);
    if (result) {
      Navigator.of(context).pop({"deleted": true, "reload": true});
    }
    isLoading = false;
    notifyListeners();
  }
}
