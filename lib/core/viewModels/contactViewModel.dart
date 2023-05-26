import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/contactModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class ContactsViewModel extends BaseModel {
  Api _api = sl<Api>();

  List<ContactModel> contacts;

  bool isLoading = false;

  init(String branchId) async {
    isLoading = true;
    notifyListeners();
    contacts = await _api.getContacts(branchId);
    isLoading = false;
    notifyListeners();
  }
}
