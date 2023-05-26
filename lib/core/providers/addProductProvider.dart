import 'package:flutter/cupertino.dart';

class AddProductProvider extends ChangeNotifier {
  bool isQuantifiable = true;
  final addProductFormKey = GlobalKey<FormState>();

  setQuantifiableField(bool val) {
    isQuantifiable = val;
    notifyListeners();
  }

  //validate price input field for only numbers
  String priceInputValidator(String price) {
    if (price.length == 0) return "Please provide an input";
    final digitConfirmation = int.parse(price);

    if (digitConfirmation != null) {
      return null;
    }
    return "Numbers only";
  }

  //Done Button function to validate and save form Data
  done(BuildContext context) {
    var form = addProductFormKey.currentState;

    if (form.validate()) {
      Navigator.pop(context);
    }
  }

  //empty textfield validators
  String nullValidator(String val) {
    if (val.length == 0) {
      return "Please provide an input";
    }
    return null;
  }
}
