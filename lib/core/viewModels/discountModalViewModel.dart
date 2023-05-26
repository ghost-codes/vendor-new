import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class DiscountModalViewModel extends BaseModel {
  bool isDiscountPercentage = false;
  bool isLoading = false;
  bool isDelete = false;
  Api _api = sl<Api>();
  TextEditingController discount = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController clientPhone = TextEditingController();

  init(OrderModel orderModel) {
    discount.text = orderModel.discount.split("%")[0];
    name.text = orderModel.name;
    clientPhone.text =
        orderModel.clientPhone.length == 0 || orderModel.clientPhone == null
            ? ""
            : orderModel.clientPhone.split("+233")[1];
    isDiscountPercentage = orderModel.discountIsPercentage;
    notifyListeners();
  }

  onSubmitDiscount(BuildContext context, String order_id) async {
    isLoading = true;
    notifyListeners();

    bool result = await _api.editOrder({
      "name": name.text,
      "client_phone": clientPhone.text.startsWith("0")
          ? clientPhone.text.split("0")[1]
          : clientPhone.text,
      "discount_is_percentage": isDiscountPercentage ? 1 : 0,
      "discount": discount.text,
    }, order_id);
    isLoading = false;

    notifyListeners();
    if (result) {
      Navigator.of(context).pop({"refresh": true, "isDelete": false});
    }
  }

  onSetDelete() {
    isDelete = true;
    notifyListeners();
  }

  deleteOrder(String order_id, context) async {
    isLoading = true;
    notifyListeners();
    bool result = await _api.deleteOrder(order_id);
    if (result) {
      print(result);
      Navigator.of(context).pop({"refresh": true, "isDelete": true});
    }
    isLoading = false;
    notifyListeners();
  }

  onIsDiscountPercentageChanged(bool value) {
    isDiscountPercentage = value;
    notifyListeners();
  }
}
