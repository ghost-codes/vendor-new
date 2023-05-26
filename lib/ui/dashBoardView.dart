import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/sideScroll.dart';
import 'package:vendoorr/core/util/textThemes.dart';

import 'package:vendoorr/core/viewModels/dashboardViewModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/layoutbuilder.dart';
import 'package:vendoorr/ui/widgets/mainDashboard.dart';
import 'package:vendoorr/ui/widgets/pocketDashBoard.dart';
import 'package:vendoorr/ui/widgets/shimmerLoader.dart';

class DashBoardView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BaseView<DashBoardViewModel>(
      onModelReady: (model) {
        if (Provider.of<HomeViewModel>(context, listen: false).isInitialLog) {
          model.highRevenuejsonFile();
          model.bestProductjsonFile();
          model.fetchOrRefreshData();
          Provider.of<HomeViewModel>(context, listen: false).setIsInitialLog();
        }
      },
      builder: (context, model, child) {
        return MainDashboard();
      },
    );
  }
}
