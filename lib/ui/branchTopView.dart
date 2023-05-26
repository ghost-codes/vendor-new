import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/viewModels/branchTopViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchesView.dart';
import 'package:vendoorr/ui/widgets/branchDetailsVew.dart';

class BranchTopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(builder: (context, rootProv, _) {
      return BaseView<BranchTopViewModel>(
          onModelReady: (model) {},
          builder: (context, model, _) {
            return Navigator(
              pages: [
                MaterialPage(child: BranchesView()),
                if (rootProv.isBranchSelected)
                  MaterialPage(
                      child: BranchDetail(branch: rootProv.branchModel)),
              ],
              onPopPage: (route, result) {
                return route.didPop(result);
              },
            );
          });
    });
  }
}
