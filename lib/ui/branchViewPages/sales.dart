import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/saleItemModel.dart';
import 'package:vendoorr/core/models/saleModel.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/salesViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchViewPages/exportBranchViews.dart';
import 'package:vendoorr/ui/widgets/addProducts.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/productTableRow.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class SalesView extends StatelessWidget {
  final String branchId;
  List<int> flexes = [4, 4, 2, 3, 2];

  SalesView({Key key, this.branchId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SalesViewModel>(
      onModelReady: (model) {
        model.branchId = branchId;
        model.getSales();
      },
      builder: (context, model, _) {
        return Container(
          child: model.state == ViewState.Busy && !model.isLoadMore
              ? Center(
                  child: Loaders.fadingCube,
                )
              : Column(
                  children: [
                    Consumer<RootProvider>(builder: (context, rootProv, _) {
                      return BaseHeader(
                        backLogic: model.isSaleDetail
                            ? InkWell(
                                onTap: () {
                                  model.setIsSaleDetail(false);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
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
                              )
                            : SizedBox.shrink(),
                        midSection: Text(
                          "Sales (${rootProv.header})",
                          style: LocalTextTheme.headerMain,
                        ),
                      );
                    }),
                    SizedBox(height: ConstantValues.PadSmall),
                    Expanded(
                      child: Navigator(
                        onPopPage: (route, result) {
                          return route.didPop(result);
                        },
                        pages: [
                          MaterialPage(
                              child: SalesListView(
                            branchId: branchId,
                          )),
                          if (model.isSaleDetail)
                            MaterialPage(child: SalesDetailsView()),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget individualProduct(SaleModel sale) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        color: LocalColors.white,
      ),
      child: LocalTableRow(
        flexes: flexes,
        tableRows: [
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(sale.name),
          ),
          Text(sale.clientPhone),
          Text(sale.amountPayable),
          Text(sale.created),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Text(sale.attendant),
          ),
        ],
      ),
    );
  }

  Widget tableHead() {
    return Container(
      child: LocalTableRow(
        flexes: flexes,
        tableRows: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
                bottom: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
              ),
            ),
            child: Text(
              "Name",
              style: LocalTextTheme.tableHeader,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
                bottom: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
              ),
            ),
            child: Text(
              "Client Phone",
              style: LocalTextTheme.tableHeader,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
                bottom: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
              ),
            ),
            padding: EdgeInsets.all(5),
            child: Text(
              "Total",
              style: LocalTextTheme.tableHeader,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
                bottom: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
              ),
            ),
            padding: EdgeInsets.all(5),
            child: Text(
              "Date",
              style: LocalTextTheme.tableHeader,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
                bottom: BorderSide(
                  style: BorderStyle.solid,
                  color: LocalColors.grey,
                ),
              ),
            ),
            padding: EdgeInsets.all(5),
            child: Text(
              "Attendant",
              style: LocalTextTheme.tableHeader,
            ),
          ),
        ],
      ),
    );
  }
}

class SalesDetailsView extends StatefulWidget {
  SalesDetailsView({Key key}) : super(key: key);

  @override
  _SalesDetailsViewState createState() => _SalesDetailsViewState();
}

class _SalesDetailsViewState extends State<SalesDetailsView> {
  PrintingService printServ = sl<PrintingService>();
  List<int> flexes = [2, 1, 1, 1, 1, 1];

  bool isHovered = false;

  int hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Consumer<SalesViewModel>(
        builder: (context, model, _) {
          return Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                    decoration: BoxDecoration(
                      boxShadow: ConstantValues.baseShadow,
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                      color: LocalColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sale Details",
                              style: LocalTextTheme.pageHeader(),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${model.selectedSale.name}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "OrderId: ${model.selectedSale.id}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "Attendant: ${model.selectedSale.attendant}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "Created: ${model.selectedSale.created}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "Modified: ${model.selectedSale.modified}",
                              style: LocalTextTheme.body,
                            )
                          ],
                        ),
                        SizedBox(
                          height: ConstantValues.PadWide,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: LocalTextTheme.header,
                            ),
                            Text(
                              "GHS ${model.selectedSale.amountPayable}",
                              style: LocalTextTheme.body,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Discount",
                                  style: LocalTextTheme.header,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount Payable",
                              style: LocalTextTheme.header,
                            ),
                            Text(
                              "GHS ${model.selectedSale.amountPayable}",
                              style: LocalTextTheme.body,
                            )
                          ],
                        ),
                        SizedBox(
                          height: ConstantValues.PadWide,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                              child: IconButton(
                                onPressed: () async {
                                  print(model.selectedSale);
                                  await printServ
                                      .printReceipt(model.selectedSale);
                                },
                                icon: Icon(
                                  Icons.print,
                                  color: LocalColors.green,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ConstantValues.PadWide,
                  ),
                  Container(
                    padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                    decoration: BoxDecoration(
                      boxShadow: ConstantValues.baseShadow,
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                      color: LocalColors.white,
                    ),
                    child: Column(
                      children: List.generate(
                        model.selectedSale.saleItems.length + 1,
                        (index) {
                          SaleItem item = model.selectedSale
                              .saleItems[index > 0 ? index - 1 : 0];
                          if (index == 0) {
                            return Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(
                                vertical: ConstantValues.PadSmall,
                                horizontal: ConstantValues.PadWide,
                              ),
                              decoration: BoxDecoration(
                                color: LocalColors.white,
                                // boxShadow: ConstantValues.baseShadow,
                              ),
                              child: ItemListTile(
                                flexes: flexes,
                                children: [
                                  Text(
                                    "Name",
                                    style: LocalTextTheme.tableHeader,
                                  ),
                                  Text(
                                    "Unit Price",
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tableHeader,
                                  ),
                                  Text(
                                    "Quantity",
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tableHeader,
                                  ),
                                  Text(
                                    "Amount",
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tableHeader,
                                  ),
                                  Text(
                                    "Created",
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tableHeader,
                                  )
                                ],
                              ),
                            );
                          }
                          return InkWell(
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
                                  color: isHovered && hoveredIndex == index
                                      ? LocalColors.black.withOpacity(0.02)
                                      : Colors.transparent),
                              margin: EdgeInsets.only(
                                  bottom: ConstantValues.PadSmall),
                              padding: EdgeInsets.symmetric(
                                vertical: ConstantValues.PadSmall,
                                horizontal: ConstantValues.PadWide,
                              ),
                              child: ItemListTile(
                                flexes: flexes,
                                children: [
                                  Text(
                                    item.name,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.price,
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.price,
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.created,
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    ]));
  }
}

class SalesListView extends StatefulWidget {
  SalesListView({Key key, this.branchId}) : super(key: key);
  String branchId;

  @override
  _SalesListViewState createState() => _SalesListViewState();
}

class _SalesListViewState extends State<SalesListView> {
  List<int> flexes = [4, 2, 1, 3, 2];

  bool isHovered = false;
  int hoveredIndex = 0;

  PrintingService printServ = sl<PrintingService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesViewModel>(builder: (context, model, _) {
      return Container(
        child: Column(
          children: [
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
                      padding: EdgeInsets.symmetric(
                        vertical: ConstantValues.PadSmall,
                        horizontal: ConstantValues.PadWide,
                      ),
                      decoration: BoxDecoration(
                          color: LocalColors.white,
                          boxShadow: ConstantValues.baseShadow),
                      child: ItemListTile(
                        flexes: flexes,
                        children: [
                          Text(
                            "Name",
                            style: LocalTextTheme.tableHeader,
                          ),
                          Text(
                            "Client Phone",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                          Text(
                            "Total",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                          Text(
                            "Modified",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                          Text(
                            "Attendant",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: model.sales.length == 0
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Sales Yet",
                                        style: LocalTextTheme.headerMain,
                                      ),
                                      SmallSecondaryButton(
                                        onPressed: () {
                                          model.getSales();
                                        },
                                        text: "Refresh",
                                      )
                                    ],
                                  )
                                : ListView.builder(
                                    controller: model.scrollController,
                                    itemCount: model.sales.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == model.sales.length)
                                        return Visibility(
                                            visible: model.isLoadMore &&
                                                model.state == ViewState.Busy,
                                            child: Center(
                                              child: Loaders.fadinCubePrimSmall,
                                            ));
                                      SaleModel orderModel = model.sales[index];
                                      return InkWell(
                                        onHover: (value) {
                                          setState(() {
                                            isHovered = value;
                                            hoveredIndex = index;
                                          });
                                        },
                                        onTap: () {
                                          model.setIsSaleDetail(true,
                                              model: orderModel);
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                              border: isHovered &&
                                                      hoveredIndex == index
                                                  ? Border(
                                                      left: BorderSide(
                                                      width: 7,
                                                      color: LocalColors
                                                          .primaryColor,
                                                    ))
                                                  : Border(),
                                              color: isHovered &&
                                                      hoveredIndex == index
                                                  ? LocalColors.black
                                                      .withOpacity(0.02)
                                                  : Colors.transparent),
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              bottom: ConstantValues.PadSmall),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ConstantValues.PadSmall,
                                            horizontal: ConstantValues.PadWide,
                                          ),
                                          child: ItemListTile(
                                            flexes: flexes,
                                            children: [
                                              Text(
                                                orderModel.name,
                                                style:
                                                    LocalTextTheme.tableHeader,
                                              ),
                                              Text(
                                                orderModel.clientPhone,
                                                textAlign: TextAlign.center,
                                                style: LocalTextTheme.tablebody,
                                              ),
                                              Text(
                                                orderModel.amountPayable,
                                                textAlign: TextAlign.center,
                                                style: LocalTextTheme.tablebody,
                                              ),
                                              Text(
                                                orderModel.created,
                                                textAlign: TextAlign.center,
                                                style: LocalTextTheme.tablebody,
                                              ),
                                              Text(
                                                orderModel.attendant,
                                                textAlign: TextAlign.center,
                                                style: LocalTextTheme.tablebody,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
