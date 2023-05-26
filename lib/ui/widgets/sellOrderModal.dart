import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/sellOrderModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class SellOrderModal extends Modal {
  final String amountPayable;
  final String orderId;

  SellOrderModal(this.amountPayable, this.orderId);
  @override
  Widget build(BuildContext context) {
    return BaseView<SellOrderViewModel>(
      onModelReady: (model) {
        model.setControllers(amountPayable);
      },
      builder: (context, model, _) {
        return buildBackdropFilter(
          header: "Sell Order",
          child: Form(
              key: model.formKey,
              child: model.isDone
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: PrimaryLongButton(
                        text: "Print",
                        onPressed: () async {
                          await model.printSale(context);
                        },
                      ),
                    )
                  : mainContent()),
          isLoading: model.isLoading,
          loader: Loaders.fadinCubeWhiteSmall,
          confirmText: model.isDone ? "Cancel" : "Sell",
          closeFunction: () {
            Navigator.of(context).pop();
          },
          submitFunction: model.isDone
              ? () {
                  Navigator.of(context).pop({"deleted": true, "reload": true});
                }
              : () {
                  final formState = model.formKey.currentState;
                  if (formState.validate()) model.onSellOrder(orderId);
                },
          width: 400,
        );
      },
    );
  }

  Widget _paymentMethodCard(
    int index, {
    Payment payment,
    void Function(PaymentMethod) onChanged,
    void Function() removePayment,
    void Function(String value) onAmountChanged,
    String Function(String value) total_amount_validator,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
              visible: index != 0,
              child: Container(
                alignment: Alignment.centerRight,
                height: 15,
                child: IconButton(
                  onPressed: removePayment,
                  icon: Icon(
                    Icons.close,
                    color: LocalColors.error,
                  ),
                  iconSize: 20,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    NumberInputField(
                      isAutoValidate: false,
                      validator: total_amount_validator,
                      controller: payment.amountController,
                      hintText: "Amount",
                      onChanged: onAmountChanged,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: payment.paymentMethod != PaymentMethod.cash,
                      child: TextFormField(
                        controller: payment.refController,
                        validator: (String value) {
                          if (value.isNotEmpty) return null;
                          return "Field Input Required";
                        },
                        decoration: inputDecoration(
                          hintText: "Reference Id",
                        ),
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 150,
                  child: DropdownButton<PaymentMethod>(
                    value: payment.paymentMethod,
                    onChanged: onChanged,
                    items: [
                      if (index == 0)
                        DropdownMenuItem(
                            value: PaymentMethod.cash, child: Text("Cash")),
                      DropdownMenuItem(
                          value: PaymentMethod.momo,
                          child: Text("Mobile Money")),
                      DropdownMenuItem(
                          value: PaymentMethod.card,
                          child: Text("Credit Card")),
                      DropdownMenuItem(
                          value: PaymentMethod.bankTransfer,
                          child: Text("Bank Transfer")),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent() {
    return Consumer<SellOrderViewModel>(builder: (context, model, _) {
      return Material(
        color: LocalColors.white,
        child: Column(
          children: [
            NumberInputField(
              controller: model.amountPayable,
              hintText: "Amount Payable",
              prefix: "GHS ",
              isEnabled: false,
            ),
            SizedBox(
              height: ConstantValues.PadWide,
            ),
            NumberInputField(
              controller: model.balance,
              hintText: "Balance",
              prefix: "GHS ",
              isEnabled: false,
            ),
            SizedBox(
              height: ConstantValues.PadWide,
            ),
            ...List.generate(
              model.payments.length,
              (index) => _paymentMethodCard(index,
                  total_amount_validator: model.total_validator,
                  payment: model.payments[index],
                  onChanged: (PaymentMethod paymentMethod) {
                    model.updatePaymentList(
                        index: index, paymentMethod: paymentMethod);
                  },
                  removePayment: () => model.removePayment(index),
                  onAmountChanged: model.balanceCalc),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            SmallSecondaryButton(
              // width: double.infinity,
              onPressed: model.addPayment,
              text: "Add Payment Method",
            )
          ],
        ),
      );
    });
  }
}
