import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/consignmentModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/consignmentViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/createConsignment.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';

class ConsignmentView extends StatelessWidget {
  ConsignmentView({Key key, this.branchId}) : super(key: key);
  String branchId;

  @override
  Widget build(BuildContext context) {
    return BaseView<ConsignmentViewModel>(onModelReady: (model) {
      model.init(branchId);
    }, builder: (context, model, _) {
      return model.isLoading
          ? Center(
              child: Loaders.fadingCube,
            )
          : Column(
              children: [
                Consumer2<RootProvider, UserModel>(
                  builder: (context, rootProv, userModel, _) {
                    return BaseHeader(
                      backLogic: model.isConsignmentDetails
                          ? InkWell(
                              onTap: () {
                                model.setConsignmentSelected(false);
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
                      button: !model.isConsignmentDetails
                          ? Visibility(
                              visible: userModel.userType == "Vendor" ||
                                  userModel.userRole.canCreateConsignments,
                              child: SmallPrimaryButton(
                                text: "+ Consignment",
                                onPressed: () async {
                                  bool result = await showDialog(
                                      barrierColor: LocalColors.primaryColor
                                          .withOpacity(0.15),
                                      context: context,
                                      builder: (context) {
                                        return CreateConsignment(
                                          branchId: branchId,
                                        );
                                      });

                                  if (result) {
                                    model.init(branchId);
                                  }
                                },
                              ),
                            )
                          : Visibility(
                              visible: userModel.userType == "Vendor" ||
                                  userModel.userRole.canManageConsignments,
                              child: SmallPrimaryButton(
                                text: "Edit",
                                onPressed: () async {
                                  // bool result = await showDialog(
                                  //     barrierColor: LocalColors.primaryColor
                                  //         .withOpacity(0.20),
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return CreateConsignment(
                                  //         branchId: branchId,
                                  //       );
                                  //     });

                                  // if (result) {
                                  //   model.init(branchId);
                                  // }
                                },
                              ),
                            ),
                      midSection: Text(
                        model.isConsignmentDetails
                            ? "Consignment Details (${rootProv.header})"
                            : "Consignments (${rootProv.header})",
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
                        child: ListOfConsignments(branchId: branchId),
                      ),
                      if (model.isConsignmentDetails)
                        MaterialPage(child: ConsignmentDetails()),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}

class ListOfConsignments extends StatefulWidget {
  ListOfConsignments({Key key, this.branchId}) : super(key: key);
  String branchId;

  @override
  _ListOfConsignmentsState createState() => _ListOfConsignmentsState();
}

class _ListOfConsignmentsState extends State<ListOfConsignments> {
  final flexes = [3, 2, 1, 2, 2];

  bool isHovered = false;

  int hoveredIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsignmentViewModel>(builder: (context, model, _) {
      return Container(
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
              child: ItemListTile(flexes: flexes, children: [
                Text(
                  "Reference",
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "No. of Products",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Cost",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Remaining",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
                Text(
                  "Date Created",
                  textAlign: TextAlign.center,
                  style: LocalTextTheme.tableHeader,
                ),
              ]),
            ),
            Expanded(
              child: model.consignments.length == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Consignments To Show",
                            style: LocalTextTheme.headerMain),
                        SizedBox(
                          height: ConstantValues.PadWide,
                        ),
                        SmallSecondaryButton(
                          onPressed: () {
                            model.init(widget.branchId);
                          },
                          text: "Refresh",
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: model.consignments.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onHover: (value) {
                            setState(() {
                              isHovered = value;
                              hoveredIndex = index;
                            });
                          },
                          onTap: () {
                            model.setConsignmentSelected(true,
                                consignment: model.consignments[index]);
                          },
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
                            height: 50,
                            margin: EdgeInsets.only(
                                bottom: ConstantValues.PadSmall),
                            padding: EdgeInsets.symmetric(
                              vertical: ConstantValues.PadSmall,
                              horizontal: ConstantValues.PadWide,
                            ),
                            child: ItemListTile(flexes: flexes, children: [
                              Text(
                                model.consignments[index].reference,
                                style: LocalTextTheme.tablebody,
                              ),
                              Text(
                                model.consignments[index].consignedProducts
                                    .length
                                    .toString(),
                                style: LocalTextTheme.tablebody,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                model.consignments[index].cost,
                                style: LocalTextTheme.tablebody,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                model.consignments[index].remaining,
                                style: LocalTextTheme.tablebody,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                model.consignments[index].created,
                                style: LocalTextTheme.tablebody,
                                textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        );
                      }),
            )
          ],
        ),
      );
    });
  }
}

class ConsignmentDetails extends StatefulWidget {
  ConsignmentDetails({Key key}) : super(key: key);

  @override
  _ConsignmentDetailsState createState() => _ConsignmentDetailsState();
}

class _ConsignmentDetailsState extends State<ConsignmentDetails> {
  List<int> flexes = [2, 1, 1, 1, 1, 1];
  bool isHovered = false;

  int hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
            decoration: BoxDecoration(
              boxShadow: ConstantValues.baseShadow,
              borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
              color: LocalColors.white,
            ),
            child: consigmentDetails(),
          ),
          SizedBox(
            height: ConstantValues.PadWide,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 500),
            padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
            decoration: BoxDecoration(
              boxShadow: ConstantValues.baseShadow,
              borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
              color: LocalColors.white,
            ),
            child: consignmentProductsList(),
          ),
          SizedBox(
            height: ConstantValues.PadWide,
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 500),
            width: double.infinity,
            padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
            decoration: BoxDecoration(
              boxShadow: ConstantValues.baseShadow,
              borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
              color: LocalColors.white,
            ),
            child: consignmentHistory(),
          ),
        ],
      ),
    );
  }

  consigmentDetails() {
    return Consumer<ConsignmentViewModel>(
      builder: (context, model, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Consigment Details",
                      style: LocalTextTheme.pageHeader(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reference: ${model.selectedConsignment.reference}",
                      style: LocalTextTheme.body,
                    ),
                    SizedBox(
                      height: ConstantValues.PadSmall / 4,
                    ),
                    Text(
                      "Branch: ${model.selectedConsignment.branchName}",
                      style: LocalTextTheme.body,
                    ),
                    SizedBox(
                      height: ConstantValues.PadSmall / 4,
                    ),
                    Text(
                      "Remaining: ${model.selectedConsignment.remaining}",
                      style: LocalTextTheme.body,
                    ),
                    Text(
                      "Created Date: ${model.selectedConsignment.created}",
                      style: LocalTextTheme.body,
                    ),
                    Text(
                      "Cost: ${model.selectedConsignment.cost}",
                      style: LocalTextTheme.body,
                    ),
                    Text(
                      "Description: ${model.selectedConsignment.description}",
                      style: LocalTextTheme.body,
                    )
                  ],
                ),
              ],
            ),
            Container(
              child: SvgPicture.asset(
                "assets/svgs/consignments.svg",
                color: LocalColors.grey,
                width: 140,
              ),
            ),
          ],
        );
      },
    );
  }

  consignmentProductsList() {
    return Consumer<ConsignmentViewModel>(
      builder: (context, model, _) {
        return model.selectedConsignment.consignedProducts.length == 0
            ? Center(
                child: Text("No consigned products",
                    style: LocalTextTheme.headerMain),
              )
            : SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    model.selectedConsignment.consignedProducts.length + 1,
                    (index) {
                      ConsignedProduct item = model.selectedConsignment
                          .consignedProducts[index > 0 ? index - 1 : 0];
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
                                "Unit CP",
                                textAlign: TextAlign.center,
                                style: LocalTextTheme.tableHeader,
                              ),
                              Text(
                                "Quantity",
                                textAlign: TextAlign.center,
                                style: LocalTextTheme.tableHeader,
                              ),
                              Text(
                                "Remaining",
                                textAlign: TextAlign.center,
                                style: LocalTextTheme.tableHeader,
                              ),
                              Text(
                                "Unit Sp",
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
                                    item.unitCostPrice,
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.quantityConsigned.toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.quantityRemaining.toString(),
                                    textAlign: TextAlign.center,
                                    style: LocalTextTheme.tablebody,
                                  ),
                                  Text(
                                    item.unitMinimumSellingPrice,
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
              );
      },
    );
  }

  consignmentHistory() {
    return Center(
        child: Text("No history to show", style: LocalTextTheme.tableHeader));
  }
}
