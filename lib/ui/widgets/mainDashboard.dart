import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/dragDisable.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/dashboardViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:vendoorr/ui/widgets/shimmerLoader.dart';

class MainDashboard extends StatelessWidget {
  Widget highRevenueBranch(index) {
    return Container(
      margin: EdgeInsets.all(5),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        // color: LocalColors.black,
        border: Border(
          bottom: BorderSide(color: LocalColors.grey.withOpacity(0.3)),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "808 KNUST",
          style: TextStyle(fontFamily: "Montserrat", fontSize: 20),
        ),
      ),
    );
  }

  Widget utilityInfoCards() {
    return Consumer<DashBoardViewModel>(
      builder: (context, model, child) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => Container(
                padding: EdgeInsets.all(20),
                width: (constraints.maxWidth / 4) - ConstantValues.PadWide,
                height: 130,
                decoration: BoxDecoration(
                  color: LocalColors.white,
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                  boxShadow: ConstantValues.baseShadow,
                ),
                child: model.state == ViewState.Idle
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.utilityInfo[0][index],
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            model.utilityInfo[1][index],
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 15,
                              color: LocalColors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      )
                    : ShimmerLoader(),
              ),
            ),
          );
        });
      },
    );
  }

  // MainDashboard({this.model});
  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardViewModel>(
      builder: (context, model, child) {
        return DragDisableSingleChild(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LocalColors.white,
                  boxShadow: ConstantValues.baseShadow,
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                ),
                child: YearlyOverView(),
              ),
              SizedBox(
                height: ConstantValues.PadWide,
              ),
              AspectRatio(
                aspectRatio: 3,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: LocalColors.white,
                                boxShadow: ConstantValues.baseShadow,
                                borderRadius: BorderRadius.circular(
                                    ConstantValues.BorderRadius),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ConstantValues.PadWide,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: LocalColors.white,
                                boxShadow: ConstantValues.baseShadow,
                                borderRadius: BorderRadius.circular(
                                    ConstantValues.BorderRadius),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: ConstantValues.PadWide,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: LocalColors.white,
                                boxShadow: ConstantValues.baseShadow,
                                borderRadius: BorderRadius.circular(
                                    ConstantValues.BorderRadius),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ConstantValues.PadWide,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: LocalColors.white,
                                boxShadow: ConstantValues.baseShadow,
                                borderRadius: BorderRadius.circular(
                                    ConstantValues.BorderRadius),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: ConstantValues.PadWide,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(ConstantValues.PadWide),
                        decoration: BoxDecoration(
                          color: LocalColors.white,
                          boxShadow: ConstantValues.baseShadow,
                          borderRadius: BorderRadius.circular(
                              ConstantValues.BorderRadius),
                        ),
                        child: GaugeChart.withSampleData(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ConstantValues.PadWide,
              ),
              Container(
                width: double.infinity,
                height: 500,
                padding: EdgeInsets.all(ConstantValues.PadWide),
                decoration: BoxDecoration(
                  color: LocalColors.white,
                  boxShadow: ConstantValues.baseShadow,
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                ),
                child: Row(
                  children: [
                    Expanded(child: GroupedFillColorBarChart.withSampleData()),
                  ],
                ),
              ),
              SizedBox(
                height: ConstantValues.PadWide,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 500,
                      padding: EdgeInsets.all(ConstantValues.PadWide),
                      decoration: BoxDecoration(
                        color: LocalColors.white,
                        boxShadow: ConstantValues.baseShadow,
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                      ),
                    ),
                  ),
                  SizedBox(width: ConstantValues.PadWide),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 500,
                      padding: EdgeInsets.all(ConstantValues.PadWide),
                      decoration: BoxDecoration(
                        color: LocalColors.white,
                        boxShadow: ConstantValues.baseShadow,
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        );
      },
    );
  }
}

class GaugeChart extends StatelessWidget {
  GaugeChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory GaugeChart.withSampleData() {
    return new GaugeChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  final bool animate;
  final List<charts.Series> seriesList;

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Low', 75),
      new GaugeSegment('Acceptable', 100),
      new GaugeSegment('High', 50),
      new GaugeSegment('Highly Unusual', 5),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      // Configure the width of the pie slices to 30px. The remaining space in
      // the chart will be left as a hole in the center. Adjust the start
      // angle and the arc length of the pie so it resembles a gauge.
      behaviors: [
        charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Set [showMeasures] to true to display measures in series legend.
          showMeasures: true,
          // Configure the measure value to be shown by default in the legend.
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            // return value == null ? '-' : '${value}k;
            return "";
          },
        )
      ],

      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 70, startAngle: 4 / 5 * pi, arcLength: 10 / 5 * pi),
    );
  }
}

/// Sample data type.
class GaugeSegment {
  GaugeSegment(this.segment, this.size);

  final String segment;
  final int size;
}

class GroupedFillColorBarChart extends StatelessWidget {
  GroupedFillColorBarChart(this.seriesList, {this.animate});

  factory GroupedFillColorBarChart.withSampleData() {
    return new GroupedFillColorBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  final bool animate;
  final List<charts.Series> seriesList;

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
      ),
      // Solid red bars. Fill color will default to the series color if no
      // fillColorFn is configured.
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
      ),
      // Hollow green bars.
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 2.0),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  OrdinalSales(this.year, this.sales);

  final int sales;
  final String year;
}

class YearlyOverView extends StatelessWidget {
  const YearlyOverView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardViewModel>(
      builder: (context, model, child) {
        return Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overview of the Month",
                style: LocalTextTheme.header,
              ),
              Center(
                child: Container(
                  width: 1000,
                  height: 500,
                  decoration: BoxDecoration(
                    color: LocalColors.white,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                  ),
                  //graph container
                  child: model.state == ViewState.Busy
                      ? ShimmerLoader()
                      : Container(
                          padding: EdgeInsets.all(15),
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: model.getSpotsFromData(),
                                  dotData: FlDotData(show: false),
                                  colors: [
                                    LocalColors.secodaryColor,
                                  ],
                                  isCurved: true,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(
                                    gradientFrom: Offset(0, 0),
                                    gradientTo: Offset(2, 0),
                                    show: true,
                                    colors: [
                                      LocalColors.secodaryColor
                                          .withOpacity(0.3),
                                      LocalColors.secodaryColor
                                          .withOpacity(0.005),
                                    ],
                                  ),
                                ),
                                LineChartBarData(
                                  spots: model.getSpotsFromData2(),
                                  dotData: FlDotData(show: false),
                                  colors: [
                                    LocalColors.grey.withOpacity(0.3),
                                  ],
                                  isCurved: true,
                                  isStrokeCapRound: true,
                                ),
                              ],
                              gridData: FlGridData(
                                  drawHorizontalLine: true,
                                  drawVerticalLine: false,
                                  checkToShowHorizontalLine: (value) {
                                    return value % 500000 == 0;
                                  },
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: LocalColors.grey.withOpacity(0.2),
                                      strokeWidth: 1,
                                    );
                                  }),
                              lineTouchData: LineTouchData(enabled: true),
                              borderData: FlBorderData(
                                border: Border(
                                  bottom: BorderSide(
                                    color: LocalColors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: SideTitles(
                                  showTitles: false,
                                ),
                                rightTitles: SideTitles(
                                  showTitles: true,
                                  margin: 5,
                                  checkToShowTitle: (minValue, maxValue,
                                      sideTitles, appliedInterval, value) {
                                    if (value.toDouble() % 500000 == 0) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                  // interval: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfitReviewContainer extends StatelessWidget {
  const ProfitReviewContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardViewModel>(builder: (context, model, child) {
      return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          color: LocalColors.white,
        ),
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profit",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: LocalColors.primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // blurBgShowDialog(
                    //   context,
                    //   width: 600,
                    //   child: Text(
                    //     "Comprehensive Review",
                    //     style: TextStyle(
                    //       color: LocalColors.primaryColor,
                    //       fontFamily: "Montserrat",
                    //       fontSize: 17,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Icon(
                    Icons.menu,
                    color: LocalColors.primaryColor,
                  ),
                ),
              ],
            ),
            Expanded(
              child: model.state == ViewState.Busy
                  ? ShimmerLoader()
                  : Column(
                      children: [
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Expected: ",
                              style: LocalTextTheme.body,
                            ),
                            Text(
                              "\$5.00",
                              style: TextStyle(
                                color: LocalColors.green,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Actual: ",
                              style: LocalTextTheme.body,
                            ),
                            Text(
                              "\$5.00",
                              style: TextStyle(
                                color: LocalColors.green,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: LocalColors.offWhite,
                              borderRadius: BorderRadius.circular(
                                  ConstantValues.BorderRadius),
                            ),
                            child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: model.getSpotsFromData(),
                                    dotData: FlDotData(show: false),
                                    colors: [
                                      LocalColors.secodaryColor,
                                    ],
                                    isStrokeCapRound: true,
                                    belowBarData: BarAreaData(
                                      gradientFrom: Offset(0, 0),
                                      gradientTo: Offset(0, 2),
                                      show: true,
                                      colors: [
                                        LocalColors.secodaryColor
                                            .withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ],
                                gridData: FlGridData(
                                  drawHorizontalLine: false,
                                  drawVerticalLine: false,
                                ),
                                lineTouchData: LineTouchData(enabled: true),
                                borderData: FlBorderData(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: LocalColors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    margin: 5,
                                    checkToShowTitle: (minValue, maxValue,
                                        sideTitles, appliedInterval, value) {
                                      if (value.toDouble() % 500000 == 0) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    },
                                    // interval: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class IncomeReviewContainer extends StatelessWidget {
  const IncomeReviewContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardViewModel>(
      builder: (context, model, child) {
        return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
            color: LocalColors.white,
          ),
          height: 450,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Income",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: LocalColors.primaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.menu,
                      color: LocalColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: model.state == ViewState.Busy
                    ? ShimmerLoader()
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Expected: ",
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "\$5.00",
                                style: TextStyle(
                                  color: LocalColors.green,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Actual: ",
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "\$5.00",
                                style: TextStyle(
                                  color: LocalColors.green,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: LocalColors.offWhite,
                                borderRadius: BorderRadius.circular(
                                    ConstantValues.BorderRadius),
                              ),
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: model.getSpotsFromData(),
                                      dotData: FlDotData(show: false),
                                      colors: [
                                        LocalColors.secodaryColor,
                                      ],
                                      isCurved: true,
                                      isStrokeCapRound: true,
                                      belowBarData: BarAreaData(
                                        gradientFrom: Offset(0, 0),
                                        gradientTo: Offset(0, 2),
                                        show: true,
                                        colors: [
                                          LocalColors.secodaryColor
                                              .withOpacity(0.3),
                                          LocalColors.secodaryColor
                                              .withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ],
                                  gridData: FlGridData(
                                    drawHorizontalLine: false,
                                    drawVerticalLine: false,
                                  ),
                                  lineTouchData: LineTouchData(enabled: true),
                                  borderData: FlBorderData(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            LocalColors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      margin: 5,
                                      checkToShowTitle: (minValue, maxValue,
                                          sideTitles, appliedInterval, value) {
                                        if (value.toDouble() % 500000 == 0) {
                                          return true;
                                        } else {
                                          return false;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExpenseReviewContainer extends StatelessWidget {
  const ExpenseReviewContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardViewModel>(builder: (context, model, child) {
      return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          color: LocalColors.white,
        ),
        height: 300,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expense",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: LocalColors.primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.menu,
                    color: LocalColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: model.state == ViewState.Busy
                  ? ShimmerLoader()
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Expected: ",
                              style: LocalTextTheme.body,
                            ),
                            Text(
                              "\$5.00",
                              style: TextStyle(
                                color: LocalColors.green,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Actual: ",
                              style: LocalTextTheme.body,
                            ),
                            Text(
                              "\$5.00",
                              style: TextStyle(
                                color: LocalColors.green,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: LocalColors.offWhite,
                              borderRadius: BorderRadius.circular(
                                  ConstantValues.BorderRadius),
                            ),
                            child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: model.getSpotsFromData(),
                                    dotData: FlDotData(show: false),
                                    colors: [
                                      LocalColors.secodaryColor,
                                    ],
                                    isStrokeCapRound: true,
                                    belowBarData: BarAreaData(
                                      gradientFrom: Offset(0, 0),
                                      gradientTo: Offset(0, 2),
                                      show: true,
                                      colors: [
                                        LocalColors.secodaryColor
                                            .withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ],
                                gridData: FlGridData(
                                  drawHorizontalLine: false,
                                  drawVerticalLine: false,
                                  // checkToShowVerticalLine: (value) {
                                  //   if (value % 3 == 0) {
                                  //     return true;
                                  //   } else {
                                  //     return false;
                                  //   }
                                  // }
                                ),
                                lineTouchData: LineTouchData(enabled: true),
                                borderData: FlBorderData(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: LocalColors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    margin: 5,
                                    // interval: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}
