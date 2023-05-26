import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/creditModalViewModel.dart';
import 'package:vendoorr/core/viewModels/sellOrderModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class CreditOrderModal extends Modal {
  final String branchId;
  final String orderId;

  CreditOrderModal(this.orderId, this.branchId);
  @override
  Widget build(BuildContext context) {
    return BaseView<CreditModalViewModel>(
      onModelReady: (model) {
        model.init(branchId);
      },
      builder: (context, model, _) {
        return buildBackdropFilter(
          header: "Sell Order",
          child: model.isTabsLoading
              ? Center(
                  child: Loaders.fadingCube,
                )
              : model.tabs.length == 0
                  ? Center(
                      child: Column(
                        children: [
                          Text("No Tabs To show"),
                          SizedBox(
                            height: 15,
                          ),
                          SmallSecondaryButton(
                            text: "Refresh",
                            onPressed: () {
                              model.init(branchId);
                            },
                          ),
                        ],
                      ),
                    )
                  : TabList(),
          isLoading: model.isLoading,
          loader: Loaders.fadinCubeWhiteSmall,
          confirmText: "Credit",
          closeFunction: () {
            Navigator.of(context).pop();
          },
          submitFunction: model.selectedTab == null
              ? null
              : () {
                  model.submit(orderId, context);
                },
          width: 400,
        );
      },
    );
  }
}

class TabList extends StatefulWidget {
  const TabList({Key key}) : super(key: key);

  @override
  _TabListState createState() => _TabListState();
}

class _TabListState extends State<TabList> {
  bool isHovered = false;

  int hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreditModalViewModel>(
      builder: (context, model, _) {
        return Material(
          color: LocalColors.white,
          child: Container(
            height: 400,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: TextField(
                    onChanged: model.search,
                    decoration: inputDecoration(hintText: "Search"),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: model.displayTabs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onHover: (value) {
                          setState(() {
                            isHovered = value;
                            hoveredIndex = index;
                          });
                        },
                        onTap: () {
                          model.onSelectTab(model.displayTabs[index]);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                              border: (model.selectedTab != null &&
                                          model.selectedTab.id ==
                                              model.displayTabs[index].id) ||
                                      isHovered && hoveredIndex == index
                                  ? Border(
                                      left: BorderSide(
                                      width: 7,
                                      color: LocalColors.primaryColor,
                                    ))
                                  : Border(),
                              color: (model.selectedTab != null &&
                                      model.selectedTab.id ==
                                          model.displayTabs[index].id)
                                  ? LocalColors.primaryColor.withOpacity(0.06)
                                  : isHovered && hoveredIndex == index
                                      ? LocalColors.black.withOpacity(0.02)
                                      : Colors.transparent),
                          // margin:
                          //     EdgeInsets.only(bottom: ConstantValues.PadSmall),
                          padding: EdgeInsets.symmetric(
                            vertical: ConstantValues.PadSmall * 1.1,
                            horizontal: ConstantValues.PadSmall / 2,
                          ),
                          child: ItemListTile(
                            flexes: [3, 1],
                            children: [
                              Text(
                                model.displayTabs[index].name,
                                style: LocalTextTheme.tableHeader,
                              ),
                              Text(
                                model.displayTabs[index].total,
                                style: LocalTextTheme.tablebody,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
