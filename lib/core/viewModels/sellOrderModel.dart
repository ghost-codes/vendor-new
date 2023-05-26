import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/saleModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

enum PaymentMethod { cash, momo, bankTransfer, card }

class Payment {
  TextEditingController amountController = TextEditingController(text: "0.0");
  TextEditingController refController = TextEditingController();
  PaymentMethod paymentMethod;

  Payment({this.paymentMethod = PaymentMethod.momo});
}

class SellOrderViewModel extends BaseModel {
  Api _api = sl<Api>();
  PrintingService printServ = sl<PrintingService>();

  List<Payment> payments = [Payment(paymentMethod: PaymentMethod.cash)];

  bool isLoading = false;

  TextEditingController amountPayable;
  TextEditingController amountReceived;
  TextEditingController balance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SaleModel createdModel;
  bool isDone = false;

  void updatePaymentList({int index, PaymentMethod paymentMethod}) {
    payments[index].paymentMethod = paymentMethod;
    notifyListeners();
  }

  void addPayment() {
    payments.add(Payment());
    notifyListeners();
  }

  void removePayment(int index) {
    payments.removeAt(index);
    balanceCalc("");
    notifyListeners();
  }

  setControllers(String amount) {
    amountPayable = TextEditingController(text: amount);
    balance = TextEditingController(text: amount);
    amountReceived = TextEditingController(text: "0.0");
    notifyListeners();
  }

  balanceCalc(String value) {
    double bal = -double.parse(amountPayable.text);
    ;

    payments.forEach((e) {
      print(e.amountController.text);
      bal = double.parse(
              e.amountController.text == "" ? "0" : e.amountController.text) +
          bal;
    });
    balance.text = bal < 0 ? "0" : bal.toStringAsFixed(2);
    notifyListeners();
  }

  String total_validator(String val) {
    double amount = 0;
    payments.forEach((element) {
      amount += double.parse(element.amountController.text.isEmpty
          ? "0"
          : element.amountController.text);
    });
    if (amount >= double.parse(amountPayable.text)) return null;
    return "Amounts not enough";
  }

  onSellOrder(String orderId) async {
    double amount = 0;
    payments.forEach((element) {
      amount += double.parse(element.amountController.text);
    });
    if (amount < double.parse(amountPayable.text)) return;
    isLoading = true;
    notifyListeners();
    final sale_payments = payments.map((e) {
      int _paymentMethod;
      switch (e.paymentMethod) {
        case PaymentMethod.cash:
          _paymentMethod = 0;
          break;
        case PaymentMethod.momo:
          _paymentMethod = 1;
          break;
        case PaymentMethod.card:
          _paymentMethod = 2;
          break;
        case PaymentMethod.bankTransfer:
          _paymentMethod = 3;
          break;
        default:
          _paymentMethod = 0;
      }
      return {
        "payment_mode": _paymentMethod,
        "amount_received": e.amountController.text,
        "reference_id": _paymentMethod == 0 ? "" : e.refController.text,
      };
    }).toList();
    SaleModel res = await _api.createSale({
      "amount_received": amount,
      "sale_payments": sale_payments,
      "balance": balance.text
    }, orderId);
    if (res != null) {
      print(res);
      isDone = true;
      createdModel = res;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  void printSale(BuildContext context) async {
    await printServ.printReceipt(createdModel);
    Navigator.of(context).pop({"deleted": true, "reload": true});
  }
}
