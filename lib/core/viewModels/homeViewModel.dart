import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/branchesViewModel.dart';

class HomeViewModel extends BaseModel {
  int _selectedTab = 1;
  double _selectedBranchTab = 0;
  BranchesViewModel _branchesViewModel = sl<BranchesViewModel>();
  bool isInitialLog = true;
  bool expanded = false;
  // bool get isBranchSelected => Provider.of(context);

  ToolBarState _toolBar = ToolBarState.Min;

  setSideBarExapnd() {
    expanded = !expanded;
    notifyListeners();
  }

  setIsInitialLog() {
    isInitialLog = false;
    // notifyListeners();
  }

  int get selectedTab => _selectedTab;
  double get selectedBranchTab => _selectedBranchTab;
  ToolBarState get toolBar => _toolBar;

  setSelectedTab(int newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }

  setToolBarState() {
    if (_toolBar == ToolBarState.Max) {
      _toolBar = ToolBarState.Min;
    } else {
      _toolBar = ToolBarState.Max;
    }

    notifyListeners();
  }
}
