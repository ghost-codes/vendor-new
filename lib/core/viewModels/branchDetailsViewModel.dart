import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import '../locator.dart';

class BranchDetailsViewModel extends BaseModel {
  Api _api = sl<Api>();
  BranchModel branch;

  Future<void> fetchCurrentBranch(String branchId) async {
    setState(ViewState.Busy);
    branch = await _api.getBranchInstance(branchId);
    print(branch.id);
    setState(ViewState.Idle);
  }

  void setBranch(BranchModel _branch) {
    branch = _branch;

    notifyListeners();
  }
}
