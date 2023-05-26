import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/ProductViewModel.dart';
import 'package:vendoorr/core/viewModels/branchDetailsViewModel.dart';
import 'package:vendoorr/core/viewModels/branchesViewModel.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/ordersViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/analysisTop.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchViewPages/consignmentView.dart';
import 'package:vendoorr/ui/branchViewPages/contactsView.dart';
import 'package:vendoorr/ui/branchViewPages/creditAndDebit.dart';
import 'package:vendoorr/ui/branchViewPages/expenses.dart';
import 'package:vendoorr/ui/branchViewPages/exportBranchViews.dart';
import 'package:vendoorr/ui/branchViewPages/services.dart';

class BranchDetail extends StatefulWidget {
  BranchModel branch;
  BranchDetail({
    Key key,
    this.branch,
  }) : super(key: key);

  @override
  _BranchDetailState createState() => _BranchDetailState();
}

class _BranchDetailState extends State<BranchDetail> {
  ProductViewModel productViewModel = sl<ProductViewModel>();
  OrdersViewModel ordersModel = sl<OrdersViewModel>();
  PrintingService printServ = sl<PrintingService>();
  @override
  void dispose() {
    ordersModel.dispose();
    productViewModel.dispose();
    super.dispose();
  }

  BranchPages _firstPage({bool isVendor, UserRole role}) {
    if (isVendor) return BranchPages.Products;
    if (role.canViewProducts) return BranchPages.Products;
    if (role.canViewConsignments) return BranchPages.Stock;
    if (role.canViewOrders) return BranchPages.Orders;
    if (role.canViewSales) return BranchPages.Sales;
    if (role.canViewAccountTabs) return BranchPages.CreditAndDebit;

    if (role.canViewExpenses) return BranchPages.Expenses;
    if (role.canViewContacts) return BranchPages.Contacts;
    if (role.canViewStaff) return BranchPages.Staff;
    if (role.canViewActivityLog) return BranchPages.Activities;
    if (role.canViewAnalyses) return BranchPages.Analysis;
    return BranchPages.Products;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RootProvider, UserModel>(
      builder: (BuildContext context, RootProvider rootProv, userModel,
          Widget child) {
        return BaseView<BranchDetailsViewModel>(
          onModelReady: (model) async {
            print(widget.branch);
            print(userModel);
            final first_page = _firstPage(
                isVendor: userModel.userType == "Vendor",
                role: userModel.userRole);
            rootProv.branchPagesSink.add(first_page);
            if (widget.branch == null) {
              await model.fetchCurrentBranch(userModel.nativeBranch);
              printServ.branch = model.branch;
              rootProv.setBranchSelectedtrue(model.branch.branchName);
              rootProv.setBranchModel(model.branch);
              return;
            }
            model.setBranch(widget.branch);
          },
          builder: (context, model, child) {
            return Container(
              child: Consumer<RootProvider>(
                builder: (context, rootProv, child) {
                  return StreamBuilder<BranchPages>(
                      stream: rootProv.branchPagesStream,
                      builder: (context, snapshot) {
                        BranchPages page = snapshot.data;
                        if (model.state == ViewState.Busy)
                          return Center(
                            child: Loaders.fadingCube,
                          );
                        if (model.branch == null)
                          return Center(
                            child: SmallPrimaryButton(
                              text: "Refresh",
                              onPressed: () async {
                                await model
                                    .fetchCurrentBranch(userModel.nativeBranch);
                              },
                            ),
                          );
                        return Navigator(
                          pages: [
                            MaterialPage(
                                child: ProductsView(
                                    branchId: model.branch.id,
                                    rootCategory: model.branch.rootCategory)),
                            if (page == BranchPages.Stock)
                              MaterialPage(
                                  child: ConsignmentView(
                                      branchId: model.branch.id)),
                            if (page == BranchPages.Orders)
                              MaterialPage(
                                  child: OrdersView(branchId: model.branch.id)),
                            if (page == BranchPages.Expenses)
                              MaterialPage(
                                  child:
                                      ExpensesView(branchId: model.branch.id)),
                            if (page == BranchPages.CreditAndDebit)
                              MaterialPage(
                                  child: CreditAndDebitView(
                                      branchId: model.branch.id)),
                            if (page == BranchPages.Sales)
                              MaterialPage(
                                  child: SalesView(branchId: model.branch.id)),

                            if (page == BranchPages.Contacts)
                              MaterialPage(
                                  child: ContactsView(
                                branchId: model.branch.id,
                              )),
                            if (page == BranchPages.Staff)
                              MaterialPage(
                                  child: StaffView(branchId: model.branch.id)),
                            if (page == BranchPages.Activities)
                              MaterialPage(
                                  child: ActivitiesView(
                                      branchId: model.branch.id)),
                            // if (page == BranchPages.Services)
                            //   MaterialPage(
                            //     child: ServicesList(branchId: widget.branch.id),
                            //   ),
                            if (page == BranchPages.Analysis)
                              MaterialPage(
                                  child:
                                      AnalysisView(branchId: model.branch.id)),
                          ],
                          onPopPage: (route, result) {
                            return route.didPop(result);
                          },
                        );
                      });
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget branchesList() {
    return Consumer<BranchesViewModel>(builder: (context, model, child) {
      return Container(
        width: 230,
        child: ListView.builder(
          controller: model.listViewController,
          physics: BouncingScrollPhysics(),
          itemCount: model.branches.length,
          itemBuilder: (context, index) {
            //first unclickable item
            if (index == 0) {
              return Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                  color: LocalColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.branches[index].branchName,
                      style: TextStyle(
                        color: LocalColors.primaryColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      model.branches[index].location,
                      style: TextStyle(
                        color: LocalColors.black,
                        fontFamily: "Montserrat",
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$ ${model.branches[index].revenueOfTheMonth}",
                      style: TextStyle(
                        color: LocalColors.green,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: 270,
                              centerSpaceRadius: 25,
                              sectionsSpace: 2,
                              borderData: FlBorderData(show: false),
                              sections: [
                                PieChartSectionData(
                                  radius: 25,
                                  value:
                                      model.branches[index].revenueOfTheMonth,
                                  showTitle: false,
                                  color: LocalColors.green,
                                ),
                                PieChartSectionData(
                                  radius: 15,
                                  color:
                                      LocalColors.primaryColor.withOpacity(0.1),
                                  showTitle: false,
                                  value: model.totalRevenue -
                                      model.branches[index].revenueOfTheMonth,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            //Rest of items(Clickable)
            return InkWell(
              onHover: (bool hover) {
                model.setBranchItemIsHovered(hover, index);
              },
              onTap: () {
                model.branchChange(index);
              },
              child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: LocalColors.white,
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),

                    //box shadow transitoin on hovered
                    boxShadow: (model.isBranchListItemHovered &&
                            model.hoveredIndex == index)
                        ? [
                            BoxShadow(
                                offset: Offset(4, 12),
                                blurRadius: 5,
                                color: LocalColors.black.withOpacity(0.2)),
                          ]
                        : [
                            BoxShadow(
                                offset: Offset(1, 3),
                                blurRadius: 5,
                                color: LocalColors.black.withOpacity(0.1)),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${model.branches[index].branchName}",
                        style: TextStyle(
                          color: LocalColors.primaryColor,
                          fontFamily: "Montserrat",
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${model.branches[index].location}",
                        style: TextStyle(
                          color: LocalColors.black,
                          fontFamily: "Montserrat",
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${model.branches[index].revenueOfTheMonth}",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 13,
                              color: LocalColors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            );
          },
        ),
      );
    });
  }
}
