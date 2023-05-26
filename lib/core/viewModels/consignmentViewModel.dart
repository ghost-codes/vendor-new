import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/consignmentModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class ConsignmentViewModel extends BaseModel {
  bool isConsignmentDetails = false;

  bool isLoading = false;
  Api _api = sl<Api>();
  List<ConsignmentModel> consignments = [];

  ConsignmentModel selectedConsignment;

  init(String branchid) async {
    isLoading = true;
    notifyListeners();
    consignments = await _api.getConsignments(branchid);

    isLoading = false;
    notifyListeners();
  }

  setConsignmentSelected(bool value, {ConsignmentModel consignment}) {
    isConsignmentDetails = value;
    if (consignment != null && isConsignmentDetails) {
      selectedConsignment = consignment;
    }
    notifyListeners();
  }

  dispose() {
    isConsignmentDetails = false;
    isLoading = false;
  }
}
