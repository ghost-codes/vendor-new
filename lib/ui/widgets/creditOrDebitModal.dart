import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/viewModels/creditOrDebitModalViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class CreditOrDebitModal extends Modal {
  final int creditOrDebit;
  final String tabId;

  CreditOrDebitModal(this.creditOrDebit, this.tabId);

  @override
  Widget build(BuildContext context) {
    return BaseView<CreditOrDebitModalViewModel>(builder: (context, model, _) {
      return buildBackdropFilter(
        closeFunction: () {
          Navigator.of(context).pop(false);
        },
        header: creditOrDebit == 1 ? "Debit Tab" : "Credit Tab",
        confirmText: creditOrDebit == 1 ? "Debit" : "Credit",
        isLoading: model.isLoading,
        loader: Loaders.fadinCubeWhiteSmall,
        width: 400,
        submitFunction: () {
          model.onSubmit(tabId, creditOrDebit, context);
        },
        child: Material(
          color: LocalColors.white,
          child: Container(
            child: Column(
              children: [
                NumberInputField(
                  controller: model.amount,
                  hintText: "Amount",
                  prefix: "GHS ",
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: model.description,
                  decoration: inputDecoration(
                    hintText: "Description",
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
