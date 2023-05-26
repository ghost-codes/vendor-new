import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/models/expenseModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/addDefinedExpenseViewModel.dart';
import 'package:vendoorr/core/viewModels/addUndefinedExpnesModel.dart';
import 'package:vendoorr/core/viewModels/branchDetailsViewModel.dart';
import 'package:vendoorr/core/viewModels/expensesViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/addProducts.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class ExpensesView extends StatelessWidget {
  final String branchId;

  const ExpensesView({Key key, this.branchId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<ExpensesViewModel>(
      onModelReady: (model) {
        model.init(branchId);
      },
      builder: (context, model, _) {
        return model.isLoading
            ? Center(
                child: Loaders.fadingCube,
              )
            : Column(
                children: [
                  Consumer2<RootProvider, UserModel>(
                    builder: (context, rootProv, userModel, _) {
                      return BaseHeader(
                        button: Row(
                          children: [
                            Visibility(
                              visible: userModel.userType == "Vendor" ||
                                  userModel.userRole.canCreateExpenses,
                              child: SmallPrimaryButton(
                                text: "+ Expense",
                                onPressed: () async {
                                  bool res = await showDialog(
                                      barrierColor: LocalColors.primaryColor
                                          .withOpacity(0.1),
                                      context: context,
                                      builder: (context) {
                                        return AddNewUndefinedExpense(branchId);
                                      });
                                  if (res) {
                                    model.init(branchId);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        midSection: Text(
                          "Expenses (${rootProv.header})",
                          style: LocalTextTheme.headerMain,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ConstantValues.PadSmall),
                  Expanded(
                    child: ExpensesListView(branchId: branchId),
                  ),
                ],
              );
      },
    );
  }
}

class AddDefinedExpense extends Modal {
  @override
  Widget build(BuildContext context) {
    return BaseView<AddDefinedExpenseViewModel>(
      builder: (context, model, _) {
        return buildBackdropFilter(
          width: 500,
          closeFunction: () {
            Navigator.of(context).pop();
          },
          header: "Add Defined Expense",
          confirmText: "Add",
          bottomButtons: model.isAddNew
              ? Row(
                  children: [
                    Expanded(
                      child: PrimaryLongButton(
                        text: "Back",
                        color: LocalColors.error,
                        onPressed: () {
                          model.setIsAddNew(false);
                        },
                      ),
                    ),
                    SizedBox(width: ConstantValues.PadWide),
                    Expanded(
                      child: PrimaryLongButton(
                        text: "Add New",
                        onPressed: () {
                          // model.setIsAddNew();
                        },
                      ),
                    ),
                  ],
                )
              : PrimaryLongButton(
                  text: "Add",
                  onPressed: () {
                    // model.setIsAddNew(true);
                  },
                ),
          child: model.isAddNew
              ? addNewcontent()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmallPrimaryButton(
                          text: "New",
                          onPressed: () {
                            model.setIsAddNew(true);
                          },
                        ),
                      ],
                    ),
                    Text("List of Predefined Expenses")
                  ],
                ),
        );
      },
    );
  }

  addNewcontent() {
    return Material(
      child: Column(
        children: [
          TextField(decoration: inputDecoration(hintText: "Name")),
          SizedBox(
            height: ConstantValues.PadSmall,
          ),
          TextField(
              decoration: inputDecoration(
                  hintText: "Amount",
                  prefix: Text(
                    "GHS ",
                    style: TextStyle(color: LocalColors.grey),
                  ))),
          SizedBox(
            height: ConstantValues.PadSmall,
          ),
          TextField(
              maxLines: 4,
              decoration: inputDecoration(hintText: "Description")),
        ],
      ),
    );
  }
}

class AddNewUndefinedExpense extends Modal {
  final String branchId;

  AddNewUndefinedExpense(this.branchId);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseView<AddUndefinedExpenseModel>(onModelReady: (model) {
      ;
    }, builder: (context, model, _) {
      return buildBackdropFilter(
          closeFunction: () {
            Navigator.of(context).pop();
          },
          header: "Add New Expense",
          confirmText: "Done",
          submitFunction: () {
            model.onSubmit(branchId, context);
          },
          loader: Loaders.fadinCubeWhiteSmall,
          isLoading: model.isLoading,
          width: 500,
          child: Material(
            color: LocalColors.white,
            child: Column(
              children: [
                TextField(
                    controller: model.name,
                    decoration: inputDecoration(hintText: "Name")),
                SizedBox(
                  height: ConstantValues.PadSmall,
                ),
                NumberInputField(
                  controller: model.amount,
                  hintText: "Amount",
                  prefix: "GHS ",
                ),
                SizedBox(
                  height: ConstantValues.PadSmall,
                ),
                TextField(
                  controller: model.description,
                  maxLines: 4,
                  decoration: inputDecoration(hintText: "Description"),
                ),
              ],
            ),
          ));
    });
  }
}

class ExpensesListView extends StatefulWidget {
  ExpensesListView({Key key, this.branchId}) : super(key: key);
  String branchId;

  @override
  _ExpensesListViewState createState() => _ExpensesListViewState();
}

class _ExpensesListViewState extends State<ExpensesListView> {
  List<int> flexes = [4, 1, 2, 2];

  bool isHovered = false;
  int hoveredIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesViewModel>(builder: (context, model, _) {
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
                            "Amount",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                          Text(
                            "Date/Time",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                          Text(
                            "Description",
                            textAlign: TextAlign.center,
                            style: LocalTextTheme.tableHeader,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: model.expenses.length == 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "No Expenses Yet",
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
                          : Column(
                              children: [
                                Expanded(
                                  child: model.expenses.length == 0
                                      ? Center(
                                          child: Text(
                                            "No Expenses Yet",
                                            style: LocalTextTheme.headerMain,
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: model.expenses.length,
                                          itemBuilder: (context, index) {
                                            ExpenseModel expenseModel =
                                                model.expenses[index];
                                            return InkWell(
                                              onHover: (value) {
                                                setState(() {
                                                  isHovered = value;
                                                  hoveredIndex = index;
                                                });
                                              },
                                              onTap: () {},
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
                                                      expenseModel.name,
                                                      style: LocalTextTheme
                                                          .tableHeader,
                                                    ),
                                                    Text(
                                                      expenseModel.amount,
                                                      textAlign:
                                                          TextAlign.center,
                                                      // textAlign: TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      expenseModel.created
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      // textAlign: TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                    ),
                                                    Text(
                                                      expenseModel.description,
                                                      textAlign:
                                                          TextAlign.center,
                                                      // textAlign: TextAlign.center,
                                                      style: LocalTextTheme
                                                          .tablebody,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
