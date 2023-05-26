import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/analysisTopViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/selectDateRangeViewModel.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/selectDateRange.dart';

class AnalysisProductSummary extends StatefulWidget {
  const AnalysisProductSummary({Key key, @required this.branchId})
      : super(key: key);
  final String branchId;

  @override
  State<AnalysisProductSummary> createState() =>
      _AnalysisProductSummaryViewState();
}

class _AnalysisProductSummaryViewState extends State<AnalysisProductSummary> {
  bool isHovered = false;
  int hoveredIndex;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    print(widget.branchId);
    Provider.of<AnalysisViewModel>(context, listen: false)
        .initProductSummary(widget.branchId);
  }

  var formate = DateFormat.yMEd();
  @override
  Widget build(BuildContext context) {
    return Consumer<AnalysisViewModel>(builder: (context, model, _) {
      return model.isProductSummaryLoading ||
              model.isProductSummaryLoading == null
          ? Center(
              child: Loaders.fadinCubePrimSmall,
            )
          : Column(
              children: [
                Consumer<RootProvider>(
                  builder: (context, rootProv, _) {
                    return BaseHeader(
                      button: Row(
                        children: [
                          if (!isSearching)
                            SmallPrimaryButton(
                                icon: Icons.search,
                                onPressed: () async {
                                  setState(() {
                                    isSearching = true;
                                  });
                                }),
                          SizedBox(
                            width: 15,
                          ),
                          SmallPrimaryButton(
                            icon: Icons.calendar_today,
                            onPressed: () async {
                              DateTimeResponse response = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectDateRange(
                                      fromDate: model.fromDate,
                                      toDate: model.toDate,
                                      fromTime: model.fromTime,
                                      toTime: model.toTime,
                                    );
                                  });

                              model.setRangeProductSummary(
                                fromD: response.fromDate,
                                toD: response.toDate,
                                fromT: response.fromTime,
                                toT: response.toTime,
                              );
                            },
                          ),
                        ],
                      ),
                      backLogic: InkWell(
                        onTap: () {
                          model.setTypeOfAnalysis(AnalysisTypes.top);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ConstantValues.BorderRadius),
                            color: LocalColors.primaryColor,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: LocalColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      midSection: isSearching
                          ? Row(
                              children: [
                                Container(
                                  width: 400,
                                  height: 40,
                                  child: Center(
                                    child: TextField(
                                      onChanged: model.onProductSummarySearch,
                                      decoration: inputDecoration(
                                          hintText: "Search",
                                          suffix: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isSearching = false;
                                                });
                                                model
                                                    .onProductSummarySearchCancel();
                                              },
                                              icon: Icon(Icons.close))),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Product Summary (${rootProv.header}) [${model.headerDate()}]",
                              style: LocalTextTheme.headerMain,
                            ),
                    );
                  },
                ),
                SizedBox(height: ConstantValues.PadSmall),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: LocalColors.white,
                      boxShadow: ConstantValues.baseShadow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(ConstantValues.PadSmall),
                          decoration: BoxDecoration(
                              color: LocalColors.white,
                              boxShadow: ConstantValues.baseShadow),
                          child: ItemListTile(flexes: [
                            4,
                            1,
                            1,
                            1,
                            1
                          ], children: [
                            Text(
                              "Name",
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Price",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Orders",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Sales",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Total",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                          ]),
                        ),
                        Expanded(
                          child: ListView(
                              children: List.generate(
                            model.productSummarydisplayData.length,
                            (index) => InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = index;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == index
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 1
                                        ? LocalColors.black.withOpacity(0.02)
                                        : Colors.transparent),
                                height: 50,
                                margin: EdgeInsets.only(
                                    bottom: ConstantValues.PadSmall),
                                padding: EdgeInsets.symmetric(
                                  vertical: ConstantValues.PadSmall,
                                  horizontal: ConstantValues.PadWide,
                                ),
                                child: ItemListTile(flexes: [
                                  4,
                                  1,
                                  1,
                                  1,
                                  1
                                ], children: [
                                  Text(
                                    model.productSummarydisplayData[index].name,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.productSummarydisplayData[index].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model
                                        .productSummarydisplayData[index].orders
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.productSummarydisplayData[index].sales
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.productSummarydisplayData[index].total
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
    });
  }
}
