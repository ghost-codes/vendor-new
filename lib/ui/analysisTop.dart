import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/viewModels/analysisTopViewModel.dart';
import 'package:vendoorr/core/viewModels/branchTopViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/analysisTransactionsView.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchViewPages/exportBranchViews.dart';
import 'package:vendoorr/ui/branchesView.dart';
import 'package:vendoorr/ui/widgets/branchDetailsVew.dart';

class AnalysisTopView extends StatelessWidget {
  final String branchId;

  const AnalysisTopView({Key key, this.branchId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(
      builder: (context, rootProv, _) {
        return BaseView<AnalysisViewModel>(
          onModelReady: (model) {},
          builder: (context, model, _) {
            // return Center(child: Text("Helo"));
            return Navigator(
              pages: [
                MaterialPage(child: AnalysisView()),
                if (rootProv.isBranchSelected)
                  MaterialPage(
                      child: AnalysisTransactionsView(
                    branchId: "",
                  )),
              ],
              onPopPage: (route, result) {
                return route.didPop(result);
              },
            );
          },
        );
      },
    );
  }
}
