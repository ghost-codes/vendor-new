import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductDetailsProvider extends ChangeNotifier {
  bool isQuantifiable = true;
  final addProductFormKey = GlobalKey<FormState>();

  //set field to be quantifiable or not
  setQuantifiableField(bool val) {
    isQuantifiable = val;
    notifyListeners();
  }

  //done to validate
  done(BuildContext context) {
    var form = addProductFormKey.currentState;

    if (form.validate()) {
      Navigator.pop(context);
    }
  }

  // nullValidator for required fields
  String nullValidator(String val) {
    if (val.length == 0) {
      return "Please provide an input";
    }
    return null;
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
}
