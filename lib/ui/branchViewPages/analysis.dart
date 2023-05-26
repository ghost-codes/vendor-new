import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/analysisTopViewModel.dart';
import 'package:vendoorr/ui/analysisKPIView.dart';
import 'package:vendoorr/ui/analysisProductSummary.dart';
import 'package:vendoorr/ui/analysisTransactionsView.dart';
import 'package:vendoorr/ui/baseView.dart';

class AnalysisView extends StatelessWidget {
  final String branchId;

  const AnalysisView({Key key, this.branchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AnalysisViewModel>(builder: (context, model, _) {
      return Container(
        child: Center(
          child: model.selectedAnalysisType == AnalysisTypes.top
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnalysisCard(
                        title: "Transactions and Records",
                        onPressed: () {
                          model.setTypeOfAnalysis(AnalysisTypes.transactions);
                        }),
                    SizedBox(
                      width: ConstantValues.PadWide,
                    ),
                    AnalysisCard(
                      title: "KPIs",
                      onPressed: () {
                        model.setTypeOfAnalysis(AnalysisTypes.kpi);
                      },
                    ),
                    SizedBox(
                      width: ConstantValues.PadWide,
                    ),
                    AnalysisCard(
                      title: "Product Summary",
                      onPressed: () {
                        model.setTypeOfAnalysis(AnalysisTypes.productSummary);
                      },
                    ),
                  ],
                )
              : model.selectedAnalysisType == AnalysisTypes.transactions
                  ? AnalysisTransactionsView(
                      branchId: branchId,
                    )
                  : model.selectedAnalysisType == AnalysisTypes.productSummary
                      ? AnalysisProductSummary(
                          branchId: branchId,
                        )
                      : Center(
                          child: Container(),
                        ),
        ),
      );
    });
  }
}

class AnalysisCard extends StatelessWidget {
  const AnalysisCard({Key key, this.title, this.onPressed}) : super(key: key);
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 300,
        width: 250,
        padding: EdgeInsets.all(ConstantValues.PadWide * 2),
        decoration: BoxDecoration(
          boxShadow: ConstantValues.baseShadow,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          color: LocalColors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: LocalColors.grey,
              ),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            Text(
              title,
              style: LocalTextTheme.headerMain,
            )
          ],
        ),
      ),
    );
  }
}
