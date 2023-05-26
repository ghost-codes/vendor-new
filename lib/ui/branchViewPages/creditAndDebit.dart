import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/tabModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/creditAndDebitViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/createTab.dart';
import 'package:vendoorr/ui/widgets/creditOrDebitModal.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/printDebtsandCredits.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class CreditAndDebitView extends StatelessWidget {
  const CreditAndDebitView({Key key, this.branchId}) : super(key: key);

  final String branchId;

  @override
  Widget build(BuildContext context) {
    return BaseView<CreditViewModel>(onModelReady: (model) {
      model.init(branchId);
    }, builder: (context, model, _) {
      return model.isLoading
          ? Center(
              child: Loaders.fadingCube,
            )
          : Scaffold(
              backgroundColor: LocalColors.offWhite,
              body: Column(
                children: [
                  Consumer2<RootProvider, UserModel>(
                    builder: (context, rootProv, userModel, _) {
                      return BaseHeader(
                        backLogic: model.isCreditDetail || model.isRecordDetail
                            ? InkWell(
                                onTap: () {
                                  if (model.isRecordDetail) {
                                    model.setRecordDetail(false);
                                  } else {
                                    model.setCreditDetail(false);
                                  }
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
                        button: model.isCreditDetail || model.isRecordDetail
                            ? Visibility(
                                visible: userModel.userType == "Vendor" ||
                                    userModel.userRole.canManageAccountTabs,
                                child: Row(
                                  children: [
                                    SmallPrimaryButton(
                                      onPressed: () async {
                                        bool result = await showDialog(
                                          barrierColor: LocalColors.primaryColor
                                              .withOpacity(0.2),
                                          context: context,
                                          builder: (context) {
                                            return CreditOrDebitModal(
                                                0, model.selectedTab.id);
                                          },
                                        );

                                        if (result) {
                                          model.refresh();
                                        }
                                      },
                                      text: "Credit",
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    SmallSecondaryButton(
                                      onPressed: () async {
                                        bool result = await showDialog(
                                          barrierColor: LocalColors.primaryColor
                                              .withOpacity(0.2),
                                          context: context,
                                          builder: (context) {
                                            return CreditOrDebitModal(
                                                1, model.selectedTab.id);
                                          },
                                        );
                                        if (result) {
                                          model.refresh();
                                        }
                                      },
                                      text: "Debit",
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  SmallSecondaryButton(
                                    text: "Print",
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return PrintDebtorsOrCreditors(
                                                branchId: branchId);
                                          });
                                    },
                                  ),
                                  Visibility(
                                    visible: userModel.userType == "Vendor" ||
                                        userModel.userRole.canCreateAccountTabs,
                                    child: SmallPrimaryButton(
                                      text: "Create Tab",
                                      onPressed: () async {
                                        bool result = await showDialog(
                                            barrierColor: LocalColors
                                                .primaryColor
                                                .withOpacity(0.1),
                                            context: context,
                                            builder: (context) {
                                              return CreateTabView(
                                                  branchId: branchId);
                                            });

                                        if (result) {
                                          model.init(branchId);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        midSection: Text(
                          "Credit (${rootProv.header})",
                          style: LocalTextTheme.headerMain,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ConstantValues.PadSmall),
                  Expanded(
                    child: Navigator(
                      onPopPage: (route, result) {
                        return route.didPop(result);
                      },
                      pages: [
                        MaterialPage(
                            child: CreditListView(
                          branchId: branchId,
                        )),
                        if (model.isCreditDetail)
                          MaterialPage(child: CreditDetails()),
                        if (model.isRecordDetail)
                          MaterialPage(child: RecordDetails())
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}

class CreditListView extends StatefulWidget {
  CreditListView({Key key, this.branchId}) : super(key: key);
  String branchId;

  @override
  _CreditListViewState createState() => _CreditListViewState();
}

class _CreditListViewState extends State<CreditListView> {
  List<int> flexes = [
    4,
    2,
    5,
  ];

  bool isHovered = false;
  int hoveredIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreditViewModel>(builder: (context, model, _) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: model.tabs.length == 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No Tabs Yet",
                          style: LocalTextTheme.headerMain,
                        ),
                        SmallSecondaryButton(
                          onPressed: () {
                            model.init(widget.branchId);
                          },
                          text: "Refresh",
                        )
                      ],
                    )
                  : Container(
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
                                  "Total",
                                  style: LocalTextTheme.tableHeader,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Action",
                                      style: LocalTextTheme.tableHeader,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                model.isLoading
                                    ? LinearProgressIndicator(
                                        backgroundColor: LocalColors.offWhite,
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(height: 15),
                                Expanded(
                                  child: model.tabs.length == 0
                                      ? Center(
                                          child: Text(
                                            "No Tabs Available",
                                            style: LocalTextTheme.headerMain,
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: model.tabs.length,
                                          itemBuilder: (context, index) {
                                            // OrderModel orderModel = model.orders[index];
                                            return InkWell(
                                              onHover: (value) {
                                                setState(() {
                                                  isHovered = value;
                                                  hoveredIndex = index;
                                                });
                                              },
                                              onTap: () {
                                                model.setCreditDetail(true,
                                                    model: model.tabs[index]);
                                              },
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                    border: isHovered &&
                                                            hoveredIndex ==
                                                                index
                                                        ? Border(
                                                            left: BorderSide(
                                                            width: 7,
                                                            color: LocalColors
                                                                .primaryColor,
                                                          ))
                                                        : Border(),
                                                    color: isHovered &&
                                                            hoveredIndex ==
                                                                index
                                                        ? LocalColors.black
                                                            .withOpacity(0.02)
                                                        : Colors.transparent),
                                                height: 50,
                                                margin: EdgeInsets.only(
                                                    bottom: ConstantValues
                                                        .PadSmall),
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      ConstantValues.PadSmall,
                                                  horizontal:
                                                      ConstantValues.PadWide,
                                                ),
                                                child: ItemListTile(
                                                  flexes: flexes,
                                                  children: [
                                                    Text(
                                                      model.tabs[index].name,
                                                      style: LocalTextTheme
                                                          .tableHeader,
                                                    ),
                                                    Text(
                                                      model.tabs[index].total
                                                          .toString(),
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Consumer<UserModel>(builder:
                                                        (context, userModel,
                                                            _) {
                                                      return Visibility(
                                                        visible: userModel
                                                                    .userType ==
                                                                "Vendor" ||
                                                            userModel.userRole
                                                                .canManageAccountTabs,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SmallPrimaryButton(
                                                              onPressed:
                                                                  () async {
                                                                bool result =
                                                                    await showDialog(
                                                                  barrierColor: LocalColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.2),
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CreditOrDebitModal(
                                                                        0,
                                                                        model
                                                                            .tabs[index]
                                                                            .id);
                                                                  },
                                                                );

                                                                if (result) {
                                                                  model
                                                                      .refresh();
                                                                }
                                                              },
                                                              text: "Credit",
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  ConstantValues
                                                                      .PadSmall,
                                                            ),
                                                            SmallSecondaryButton(
                                                              onPressed:
                                                                  () async {
                                                                bool result =
                                                                    await showDialog(
                                                                  barrierColor: LocalColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.2),
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CreditOrDebitModal(
                                                                        1,
                                                                        model
                                                                            .tabs[index]
                                                                            .id);
                                                                  },
                                                                );
                                                                if (result) {
                                                                  model
                                                                      .refresh();
                                                                }
                                                              },
                                                              text: "Debit",
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                ),
                              ],
                            ),
                          ),
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

class CreditDetails extends StatefulWidget {
  const CreditDetails({Key key}) : super(key: key);

  @override
  _CreditDetailsState createState() => _CreditDetailsState();
}

class _CreditDetailsState extends State<CreditDetails> {
  List<int> flexes = [
    5,
    1,
    3,
    1,
    1,
  ];

  PrintingService printServ = sl<PrintingService>();

  bool isHovered = false;
  int hoveredIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<CreditViewModel>(builder: (context, model, _) {
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
                                "Tab Details",
                                style: LocalTextTheme.pageHeader(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${model.selectedTab.name}",
                                style: LocalTextTheme.body,
                              ),
                              SizedBox(
                                height: ConstantValues.PadSmall / 4,
                              ),
                              Text(
                                "Total: ${model.selectedTab.total}",
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Created: ${model.selectedTab.created}",
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Modified: ${model.selectedTab.modified}",
                                style: LocalTextTheme.body,
                              ),
                              Text(
                                "Description: ${model.selectedTab.description}",
                                style: LocalTextTheme.body,
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  child: IconButton(
                                    onPressed: () async {
                                      await printServ
                                          .printCreditTab(model.selectedTab);
                                    },
                                    icon: Icon(Icons.print),
                                    color: LocalColors.green,
                                  ),
                                )
                              ])
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ConstantValues.PadWide,
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 650),
                      padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                      decoration: BoxDecoration(
                        boxShadow: ConstantValues.baseShadow,
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                        color: LocalColors.white,
                      ),
                      child: SingleChildScrollView(
                        child: model.selectedTab.records.length == 0
                            ? Center(
                                child: Text(
                                "No Record Items",
                                style: LocalTextTheme.headerMain,
                              ))
                            : SingleChildScrollView(
                                child: Column(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ConstantValues.PadSmall,
                                    horizontal: ConstantValues.PadWide,
                                  ),
                                  child: ItemListTile(
                                    flexes: flexes,
                                    children: [
                                      Text(
                                        "Name",
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
                                      SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                ...List.generate(
                                    model.selectedTab.records.length, (index) {
                                  Record record =
                                      model.selectedTab.records[index];
                                  return InkWell(
                                    onHover: (value) {
                                      setState(() {
                                        isHovered = value;
                                        hoveredIndex = index;
                                      });
                                    },
                                    onTap: () {
                                      // model.setIsOrderDetail(true,
                                      //     model: orderModel);

                                      if (model.selectedTab.records[index]
                                          .containsItems) {
                                        model.setRecordDetail(true,
                                            record: model
                                                .selectedTab.records[index]);
                                      }
                                    },
                                    child: Material(
                                      color: LocalColors.white,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                            border: isHovered &&
                                                    hoveredIndex == index
                                                ? !model
                                                        .selectedTab
                                                        .records[index]
                                                        .containsItems
                                                    ? Border(
                                                        left: BorderSide(
                                                        width: 7,
                                                        color:
                                                            LocalColors.error,
                                                      ))
                                                    : Border(
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
                                              record.description,
                                              style: LocalTextTheme.tableHeader,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              record.value,
                                              textAlign: TextAlign.center,
                                              style: LocalTextTheme.tablebody,
                                            ),
                                            Text(
                                              record.modified,
                                              textAlign: TextAlign.center,
                                              style: LocalTextTheme.tablebody,
                                            ),
                                            Text(
                                              record.attendant,
                                              textAlign: TextAlign.center,
                                              style: LocalTextTheme.tablebody,
                                            ),
                                            Material(
                                              child: IconButton(
                                                onPressed: () async {
                                                  await printServ
                                                      .printCreditRecord(
                                                          record);
                                                },
                                                icon: Icon(Icons.print,
                                                    color: LocalColors.green),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ])),
                      ),
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class RecordDetails extends StatefulWidget {
  const RecordDetails({Key key}) : super(key: key);

  @override
  _RecordDetailsState createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails> {
  PrintingService printServ = sl<PrintingService>();

  List<int> flexes = [2, 1, 1, 1, 1, 1];

  bool isHovered = false;

  int hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Consumer<CreditViewModel>(
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
                              "Record Details",
                              style: LocalTextTheme.pageHeader(),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${model.selectedRecord.description}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "OrderId: ${model.selectedRecord.id}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "Attendant: ${model.selectedRecord.attendant}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "Created: ${model.selectedRecord.created}",
                              style: LocalTextTheme.body,
                            ),
                            SizedBox(
                              height: ConstantValues.PadSmall / 4,
                            ),
                            Text(
                              "Modified: ${model.selectedRecord.modified}",
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
                              "GHS ${model.selectedRecord.value}",
                              style: LocalTextTheme.body,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                              child: IconButton(
                                onPressed: () async {
                                  await printServ
                                      .printCreditRecord(model.selectedRecord);
                                },
                                icon:
                                    Icon(Icons.print, color: LocalColors.green),
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
                        model.selectedRecord.recordItems.length + 1,
                        (index) {
                          RecordItem item = model.selectedRecord
                              .recordItems[index > 0 ? index - 1 : 0];
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
                            child: Stack(
                              children: [
                                AnimatedContainer(
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
                              ],
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
