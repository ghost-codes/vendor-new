import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/printDebtsandCreditsViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class PrintDebtorsOrCreditors extends Modal {
  PrintDebtorsOrCreditors({this.branchId});
  final String branchId;

  @override
  Widget build(BuildContext context) {
    return BaseView<PrintDebtorsAndCreditorsViewModel>(
      builder: (context, model, _) {
        return buildBackdropFilter(
          width: 300,
          header: "Print Debtors or Creditors",
          child: Padding(
            padding: const EdgeInsets.all(ConstantValues.PadSmall / 2),
            child: PrimaryLongButton(
              onPressed: () {
                model.printCreditors(branchId);
              },
              loader: Loaders.fadinCubeWhiteSmall,
              text: "Creditors",
              isLoading: model.isCreditorsLoading,
            ),
          ),
          confirmText: "Debtors",
          loader: Loaders.fadinCubeWhiteSmall,
          isLoading: model.isDebtorsLoading,
          submitFunction: () {
            model.printDebtors(branchId);
          },
          closeFunction: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
