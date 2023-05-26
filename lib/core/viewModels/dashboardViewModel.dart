import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/dummyModels.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/authenticationService.dart';
import 'package:vendoorr/core/util/dummyJsonData.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

class DashBoardViewModel extends BaseModel {
  Api _api = sl<Api>();
  AuthenticationService _authService = sl<AuthenticationService>();
  RootProvider _rootProvider = sl<RootProvider>();

  List utilityInfo = [];

  GlobalKey _timelineKey = LabeledGlobalKey("button_icon");
  OverlayEntry _overlayEntry;
  Offset buttonPosition;
  Size buttonSize;
  bool isMenuOpen = false;

  GlobalKey get timlineKey => _timelineKey;

  final data = [
    new SalesData(0, 1500000),
    new SalesData(1, 1735000),
    new SalesData(2, 1678000),
    new SalesData(3, 1890000),
    new SalesData(4, 1907000),
    new SalesData(5, 2300000),
    new SalesData(6, 2360000),
    new SalesData(7, 1980000),
    new SalesData(8, 2654000),
    new SalesData(9, 2789070),
    new SalesData(10, 3020000),
    new SalesData(11, 3245900),
    new SalesData(12, 4098500),
  ];
  final data2 = [
    new SalesData(0, 1550000),
    new SalesData(1, 1725000),
    new SalesData(2, 1668000),
    new SalesData(3, 1900000),
    new SalesData(4, 2007000),
    new SalesData(5, 2000000),
    new SalesData(6, 2560000),
    new SalesData(7, 2080000),
    new SalesData(8, 2454000),
    new SalesData(9, 2489070),
    new SalesData(10, 2720000),
    new SalesData(11, 3045900),
    new SalesData(12, 2098500),
  ];

  void fetchOrRefreshData() async {
    setState(ViewState.Busy);

    // utilityInfo = await _api.utilityInfo(_rootProvider.userModel.username);
    notifyListeners();
    setState(ViewState.Idle);
  }

  List<FlSpot> getSpotsFromData() {
    return data
        .map((e) => FlSpot(e.year.toDouble(), e.sales.toDouble()))
        .toList();
  }

  List<FlSpot> getSpotsFromData2() {
    return data2
        .map((e) => FlSpot(e.year.toDouble(), e.sales.toDouble()))
        .toList();
  }

  findButton() {
    RenderBox renderBox = _timelineKey.currentContext.findRenderObject();
    buttonSize = renderBox.size;

    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder(Widget Function() dropDownWidget) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        top: buttonPosition.dy + buttonSize.height,
        left: buttonPosition.dx,
        width: 500,
        child: Material(
          color: Colors.transparent,
          child: dropDownWidget(),
        ),
      );
    });
  }

  void openMenu(context, Widget Function() dropDownWidget) {
    findButton();
    _overlayEntry = _overlayEntryBuilder(dropDownWidget);
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  List highRevenueBranches = [];
  highRevenuejsonFile() {
    //fetch json of high revenue branches
    highRevenueBranches = json.decode(DummyJson.highRevenuBranches);

    //Sorting Branches by revenue DESC.
    highRevenueBranches.sort((a, b) =>
        -double.parse(a["revenue"]).compareTo(double.parse(b["revenue"])));
  }

  List bestProducts = [];
  bestProductjsonFile() {
    //fetch best products
    bestProducts = json.decode(DummyJson.bestProducts);

//Sorting products
    bestProducts.sort((a, b) => -double.parse(a["percentage_input"])
        .compareTo(double.parse(b["percentage_input"])));
  }
}
