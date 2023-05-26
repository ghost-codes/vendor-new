import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/settingsViewModel.dart';
import 'package:vendoorr/ui/SettingsViewpages/settingsTabWidget.dart';
import 'package:vendoorr/ui/branchViewPages/branchTabItem.dart';
import 'package:vendoorr/ui/widgets/tabItemWidget.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class SideBar extends StatelessWidget {
  SideBar({
    @required this.userRole,
    this.isVendoor = false,
    Key key,
  }) : super(key: key);

  final UserRole userRole;
  final bool isVendoor;

  TextStyle heading = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: LocalColors.white,
  );
  TextStyle heading1 = TextStyle(
    fontFamily: "Montserrat",
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: LocalColors.white,
  );

  TextStyle body1 = TextStyle(
    color: LocalColors.white.withOpacity(0.2),
    fontFamily: "Montserrat",
  );

  TextStyle dropDownTextStyle = TextStyle(
      color: LocalColors.black,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w700);

  double width = 250;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer2<HomeViewModel, RootProvider>(
        builder: (context, model, rootProv, _) {
          switch (model.selectedTab) {
            case 0:
              return HomeSideBar(
                heading: heading,
                heading1: heading1,
                body1: body1,
                dropDownTextStyle: dropDownTextStyle,
                width: width,
              );
            case 1:
              return Column(
                children: [
                  Consumer<RootProvider>(
                    builder: (BuildContext context, RootProvider rootProv,
                        Widget child) {
                      //checking if a particular branch is selected
                      //and the branch tab is also selected
                      return rootProv.isBranchSelected
                          ? BranchSections(
                              userRole: userRole,
                              isVendoor: isVendoor,
                              heading: heading,
                              width: width,
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  BranchSort(
                    heading: heading,
                    width: width,
                  )
                ],
              );
            case 2:
              return StreamBuilder<SettingsPages>(
                  stream: rootProv.settingsPagesStream,
                  initialData: SettingsPages.Printing,
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    return Column(
                      children: [
                        SettingsSections(
                          width: width,
                          selectedSettingsPage: snapshot.data,
                        ),
                        if (snapshot.data == SettingsPages.Printing)
                          PaperTypeOptions(heading: heading, width: width)
                      ],
                    );
                  });
            default:
              return PaperTypeOptions(
                heading: heading,
                width: width,
              );
          }
        },
      ),
    );
  }
}

class SettingsSections extends StatelessWidget {
  SettingsSections({Key key, this.width, this.selectedSettingsPage})
      : super(key: key);
  double width;
  SettingsPages selectedSettingsPage;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        constraints: BoxConstraints(minHeight: 100),
        margin: EdgeInsets.only(
            left: ConstantValues.PadWide, top: ConstantValues.PadWide),
        decoration: BoxDecoration(
          color: LocalColors.primaryColor,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        ),
        child: Column(
          children: [
            // //DashBoard Button
            // SettingsTabItem(
            //   settingsPage: SettingsPages.Accounts,
            //   leftIcon: Icons.dashboard_outlined,
            //   solid: Icons.dashboard_rounded,
            //   title: "Accounts",
            //   iconName: "assets/svgs/account.svg",
            // ),

            // //Branches Button
            // SettingsTabItem(
            //   leftIcon: Icons.account_tree_outlined,
            //   solid: Icons.account_tree_rounded,
            //   title: "Security",
            //   settingsPage: SettingsPages.Security,
            //   iconName: "assets/svgs/security.svg",
            // ),

            // //Contacts Button
            // SettingsTabItem(
            //   leftIcon: Icons.supervisor_account_outlined,
            //   solid: Icons.supervisor_account_rounded,
            //   title: "Billing",
            //   settingsPage: SettingsPages.Billing,
            //   iconName: "assets/svgs/billing.svg",
            // ),

            //Staff tabItem
            SettingsTabItem(
              leftIcon: Icons.supervisor_account_outlined,
              solid: Icons.supervisor_account_rounded,
              title: "Printing",
              settingsPage: SettingsPages.Printing,
              iconName: "assets/svgs/print.svg",
              selectedSettingsPage: selectedSettingsPage,
            ),
            //Activities tabItem
            SettingsTabItem(
              leftIcon: Icons.supervisor_account_outlined,
              solid: Icons.supervisor_account_rounded,
              title: "User Roles",
              settingsPage: SettingsPages.StaffRoles,
              iconName: "assets/svgs/matrices.svg",
              selectedSettingsPage: selectedSettingsPage,
            ),
          ],
        ));
  }
}

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({
    Key key,
    @required this.heading,
    @required this.heading1,
    @required this.body1,
    @required this.dropDownTextStyle,
    @required this.width,
  }) : super(key: key);

  final TextStyle heading;
  final TextStyle heading1;
  final TextStyle body1;
  final TextStyle dropDownTextStyle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: 100),
      margin: EdgeInsets.only(
          left: ConstantValues.PadWide, top: ConstantValues.PadWide),
      padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
      decoration: BoxDecoration(
        color: LocalColors.primaryColor,
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Options",
            style: heading,
          ),
          SizedBox(
            height: ConstantValues.PadWide,
          ),
          Text(
            "Time",
            style: heading1,
          ),
          ThemeDropDown(
            items: [
              DropdownMenuItem(
                child: Text(
                  "Daily",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: LocalColors.black,
                  ),
                ),
              ),
              // DropdownMenuItem(
              //   child: Text(
              //     "Descending",
              //     style: TextStyle(
              //       fontFamily: "Montserrat",
              //       color: LocalColors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: ConstantValues.PadWide,
          ),
          Text(
            "Currency",
            style: body1,
          ),
          ThemeDropDown(
            items: [
              DropdownMenuItem(
                child: Text(
                  "Dollar",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: LocalColors.black,
                  ),
                ),
              ),
              // DropdownMenuItem(
              //   child: Text(
              //     "Descending",
              //     style: TextStyle(
              //       fontFamily: "Montserrat",
              //       color: LocalColors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: ConstantValues.PadSmall,
          ),
        ],
      ),
    );
  }
}

class BranchSort extends StatelessWidget {
  const BranchSort({Key key, @required this.heading, @required this.width})
      : super(key: key);

  final TextStyle heading;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: ConstantValues.PadWide, vertical: ConstantValues.PadWide),
      margin: EdgeInsets.only(
          left: ConstantValues.PadWide, top: ConstantValues.PadWide),
      decoration: BoxDecoration(
        color: LocalColors.primaryColor,
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort",
            style: heading,
          ),
          SizedBox(
            height: ConstantValues.PadWide,
          ),
          Text(
            "Type",
            style: TextStyle(
              color: LocalColors.white.withOpacity(0.5),
              fontFamily: "Montserrat",
            ),
          ),
          ThemeDropDown(
            items: [
              DropdownMenuItem(
                child: Text(
                  "Assending",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: LocalColors.black,
                  ),
                ),
              ),
              // DropdownMenuItem(
              //   child: Text(
              //     "Descending",
              //     style: TextStyle(
              //       fontFamily: "Montserrat",
              //       color: LocalColors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: ConstantValues.PadSmall),
          Text(
            "Sort by:",
            style: TextStyle(
              color: LocalColors.white.withOpacity(0.5),
              fontFamily: "Montserrat",
            ),
          ),
          ThemeDropDown(
            items: [
              DropdownMenuItem(
                child: Text(
                  "Assending",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: LocalColors.black,
                  ),
                ),
              ),
              // DropdownMenuItem(
              //   child: Text(
              //     "Descending",
              //     style: TextStyle(
              //       fontFamily: "Montserrat",
              //       color: LocalColors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class BranchSections extends StatelessWidget {
  const BranchSections({
    Key key,
    @required this.userRole,
    @required this.isVendoor,
    @required this.heading,
    @required this.width,
  }) : super(key: key);

  final bool isVendoor;
  final UserRole userRole;
  final TextStyle heading;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: 100),
      margin: EdgeInsets.only(
          left: ConstantValues.PadWide, top: ConstantValues.PadWide),
      decoration: BoxDecoration(
        color: LocalColors.primaryColor,
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sections",
                  style: heading,
                ),
                Column(
                  children: [
                    //DashBoard Button
                    BranchTabItem(
                      show: isVendoor || userRole.canViewProducts,
                      branchPage: BranchPages.Products,
                      leftIcon: Icons.dashboard_outlined,
                      solid: Icons.dashboard_rounded,
                      title: "Products",
                      iconName: "assets/svgs/ecommerce.svg",
                    ),
                    BranchTabItem(
                      show: isVendoor || userRole.canViewConsignments,
                      branchPage: BranchPages.Stock,
                      leftIcon: Icons.dashboard_outlined,
                      solid: Icons.dashboard_rounded,
                      title: "Consignment",
                      iconName: "assets/svgs/consignments.svg",
                    ),

                    //Branches Button
                    BranchTabItem(
                      show: isVendoor || userRole.canViewOrders,
                      leftIcon: Icons.account_tree_outlined,
                      solid: Icons.account_tree_rounded,
                      title: "Orders",
                      branchPage: BranchPages.Orders,
                      iconName: "assets/svgs/invoice.svg",
                    ),

                    //Contacts Button
                    BranchTabItem(
                      show: isVendoor || userRole.canViewSales,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Sales",
                      branchPage: BranchPages.Sales,
                      iconName: "assets/svgs/shopping-bag.svg",
                    ),
                    BranchTabItem(
                      show: isVendoor || userRole.canViewAccountTabs,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Credit/Debit",
                      branchPage: BranchPages.CreditAndDebit,
                      iconName: "assets/svgs/credit.svg",
                    ),

                    BranchTabItem(
                      show: isVendoor || userRole.canViewExpenses,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Expenses",
                      branchPage: BranchPages.Expenses,
                      iconName: "assets/svgs/expenses.svg",
                    ),

                    //Staff tabItem
                    BranchTabItem(
                      show: isVendoor || userRole.canViewContacts,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Contacts",
                      branchPage: BranchPages.Contacts,
                      iconName: "assets/svgs/phone-book.svg",
                    ),

                    //Staff tabItem
                    BranchTabItem(
                      show: isVendoor || userRole.canViewStaff,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Staff",
                      branchPage: BranchPages.Staff,
                      iconName: "assets/svgs/employees.svg",
                    ),

                    // Activities tabItem
                    BranchTabItem(
                      show: isVendoor || userRole.canViewActivityLog,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Activities",
                      branchPage: BranchPages.Activities,
                      iconName: "assets/svgs/activity.svg",
                    ),

                    //Analysis tabItem
                    BranchTabItem(
                      show: isVendoor || userRole.canViewAnalyses,
                      leftIcon: Icons.supervisor_account_outlined,
                      solid: Icons.supervisor_account_rounded,
                      title: "Analysis",
                      branchPage: BranchPages.Analysis,
                      iconName: "assets/svgs/pie-graph.svg",
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaperTypeOptions extends StatelessWidget {
  const PaperTypeOptions({
    Key key,
    @required this.heading,
    @required this.width,
  }) : super(key: key);

  final TextStyle heading;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(builder: (context, model, _) {
      return Container(
        width: width,
        constraints: BoxConstraints(minHeight: 100),
        margin: EdgeInsets.only(
            left: ConstantValues.PadWide, top: ConstantValues.PadWide),
        decoration: BoxDecoration(
          color: LocalColors.primaryColor,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Paper Type",
                    style: heading,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: ConstantValues.PadSmall,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ConstantValues.PadSmall / 2),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: LocalColors.white,
                      borderRadius:
                          BorderRadius.circular(ConstantValues.BorderRadius),
                    ),
                    child: DropdownButton(
                      value: model.paperType,
                      onChanged: (PaperType value) {
                        model.changePaperType(value);
                      },
                      underline: Container(),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: PaperType.P72,
                          child: Text(
                            "Paper 72",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: LocalColors.black,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: PaperType.A4,
                          child: Text(
                            "Paper A4",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: LocalColors.black,
                            ),
                          ),
                        ),
                      ],
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
