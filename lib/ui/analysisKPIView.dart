import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/analysisTopViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';

class AnalysisKPIView extends StatelessWidget {
  const AnalysisKPIView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalysisViewModel>(builder: (context, model, _) {
      return Column(
        children: [
          Consumer<RootProvider>(
            builder: (context, rootProv, _) {
              return BaseHeader(
                backLogic: InkWell(
                  onTap: () {
                    model.setTypeOfAnalysis(AnalysisTypes.top);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                      color: LocalColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: LocalColors.white,
                      size: 20,
                    ),
                  ),
                ),
                midSection: Text(
                  "Analysis: KPI (${rootProv.header})",
                  style: LocalTextTheme.headerMain,
                ),
              );
            },
          ),
          SizedBox(height: ConstantValues.PadSmall),
        ],
      );
    });
  }
}
