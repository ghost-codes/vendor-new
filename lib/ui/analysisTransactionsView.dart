import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/analysisTopViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/selectDateRangeViewModel.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/selectDateRange.dart';

class AnalysisTransactionsView extends StatefulWidget {
  const AnalysisTransactionsView({Key key, @required this.branchId})
      : super(key: key);
  final String branchId;

  @override
  State<AnalysisTransactionsView> createState() =>
      _AnalysisTransactionsViewState();
}

class _AnalysisTransactionsViewState extends State<AnalysisTransactionsView> {
  bool isHovered = false;
  int hoveredIndex;

  @override
  void initState() {
    super.initState();
    print(widget.branchId);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AnalysisViewModel>(context, listen: false)
          .initTransactionView(widget.branchId);
    });
  }

  var formate = DateFormat.yMEd();
  @override
  Widget build(BuildContext context) {
    return Consumer<AnalysisViewModel>(builder: (context, model, _) {
      return model.isTransactionLoading || model.transactions == null
          ? Center(
              child: Loaders.fadinCubePrimSmall,
            )
          : Column(
              children: [
                Consumer<RootProvider>(
                  builder: (context, rootProv, _) {
                    return BaseHeader(
                      button: SmallPrimaryButton(
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
                          print(response.fromDate);
                          model.setRangeTransaction(
                            fromD: response.fromDate,
                            toD: response.toDate,
                            fromT: response.fromTime,
                            toT: response.toTime,
                          );
                        },
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
                      midSection: Text(
                        "Transactions & Records (${rootProv.header}) [${model.headerDate()}]",
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
                            1
                          ], children: [
                            Text(
                              "Name",
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "No.#",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                            Text(
                              "Evaluation",
                              textAlign: TextAlign.center,
                              style: LocalTextTheme.tableHeader,
                            ),
                          ]),
                        ),
                        Expanded(
                          child: ListView(children: [
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 1;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 1
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
                                  1
                                ], children: [
                                  Text(
                                    "Net Transactions",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.netTransactions.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.netTransactions.amount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 2;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 2
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 2
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
                                  1
                                ], children: [
                                  Text(
                                    "Sales",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.sales.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.sales.amount.toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 3;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 3
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 3
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
                                  1
                                ], children: [
                                  Text(
                                    "Deposits",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.deposits.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.deposits.amount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 4;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 4
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 4
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
                                  1
                                ], children: [
                                  Text(
                                    "Debits",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.debits.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.debits.amount.toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 5;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 5
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 5
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
                                  1
                                ], children: [
                                  Text(
                                    "Credits",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.credits.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.credits.amount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 6;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 6
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 6
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
                                  1
                                ], children: [
                                  Text(
                                    "Refunds",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.refunds.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.refunds.amount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 7;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 7
                                        ? Border(
                                            left: BorderSide(
                                            width: 7,
                                            color: LocalColors.primaryColor,
                                          ))
                                        : Border(),
                                    color: isHovered && hoveredIndex == 7
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
                                  1
                                ], children: [
                                  Text(
                                    "Expenses",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.expenses.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.expenses.amount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                            InkWell(
                              onHover: (value) {
                                setState(() {
                                  isHovered = value;
                                  hoveredIndex = 8;
                                });
                              },
                              onTap: () {},
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    border: isHovered && hoveredIndex == 8
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
                                  1
                                ], children: [
                                  Text(
                                    "Orders",
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.orders.quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    model.transactions.orders.amount.toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ]),
                              ),
                            ),
                          ]),
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
