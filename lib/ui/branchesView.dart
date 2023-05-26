import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/dragDisable.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/branchesViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/addBranch.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/editBranches.dart';
import 'package:vendoorr/ui/widgets/shimmerLoader.dart';

class BranchesView extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  PrintingService printServ = sl<PrintingService>();
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserModel, RootProvider>(
        builder: (context, userModel, rootProv, _) {
      return BaseView<BranchesViewModel>(
        onModelReady: (BranchesViewModel model) {
          model.getBranches(userModel.username);

          model.refreshPageStream.listen((refresh) {
            if (refresh) {
              model.getBranches(userModel.username);
            }
          });
        },
        builder: (context, model, child) {
          return Container(child: Container(
            child: Consumer<RootProvider>(
              builder: (context, rootProv, child) {
                return Column(
                  children: [
                    BaseHeader(
                      midSection: Text(
                        "Branches",
                        style: LocalTextTheme.pageHeader(),
                      ),
                      button: SmallPrimaryButton(
                        text: "+ Branch",
                        onPressed: () async {
                          bool refresh = await showDialog(
                            context: context,
                            barrierColor: LocalColors.black.withOpacity(0.15),
                            builder: (context) {
                              return AddBranch(
                                vendorName: userModel.username,
                              );
                            },
                          );

                          model.refreshPageSink.add(refresh);
                        },
                      ),
                    ),
                    SizedBox(
                      height: ConstantValues.PadSmall,
                    ),

                    //branches In grid View
                    Expanded(
                      child: Container(
                        child: Listener(
                          onPointerSignal: (ps) {
                            dragDisable(ps, _controller);
                          },
                          child: GridView.builder(
                            controller: _controller,
                            clipBehavior: Clip.hardEdge,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1 / 1.2,
                              crossAxisSpacing: ConstantValues.PadSmall,
                              mainAxisSpacing: ConstantValues.PadSmall,
                            ),
                            itemCount: model.state == ViewState.Busy
                                ? 20
                                : model.branches.length,
                            itemBuilder: (context, index) => model.state ==
                                    ViewState.Busy
                                ? Container(
                                    padding:
                                        EdgeInsets.all(ConstantValues.PadWide),
                                    decoration: BoxDecoration(
                                      color: LocalColors.white,
                                      borderRadius: BorderRadius.circular(
                                        ConstantValues.BorderRadius,
                                      ),
                                      boxShadow: ConstantValues.baseShadow,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 20,
                                          child: ShimmerLoader(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          height: 20,
                                          child: ShimmerLoader(),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          height: 20,
                                          child: ShimmerLoader(),
                                        ),
                                        SizedBox(height: 5),
                                        Expanded(
                                          child: Container(
                                            // height: 30,
                                            child: ShimmerLoader(),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      model.setSelectedBranchId(
                                          model.branches[index].id);

                                      rootProv.setBranchSelectedtrue(
                                          model.branches[index].branchName);
                                      rootProv.setBranchModel(
                                          model.branches[index]);
                                      printServ.branch = model.branches[index];
                                    },
                                    child: branch(index),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    )
                  ],
                );
              },
            ),
          ));
        },
      );
    });
  }

  Widget branch(int index) {
    return Consumer2<UserModel, BranchesViewModel>(
        builder: (context, usermodel, model, child) {
      return Container(
        padding: EdgeInsets.all(ConstantValues.PadWide),
        decoration: BoxDecoration(
          color: LocalColors.white,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          boxShadow: ConstantValues.baseShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    model.branches[index].branchName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: LocalColors.primaryColor,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    bool refresh = await showDialog(
                        context: context,
                        barrierColor:
                            LocalColors.primaryColor.withOpacity(0.15),
                        builder: (context) {
                          return EditBranch(
                            branch: model.branches[index],
                            vendorName: usermodel.username,
                          );
                        });

                    model.refreshPageSink.add(refresh);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/expand.svg',
                    width: 18,
                    color: LocalColors.grey,
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                child: LayoutBuilder(
                  builder: (context, BoxConstraints constraints) {
                    return Container(
                      child: model.branches[index].logo == null
                          ? Center(
                              child: Image.asset('assets/images/branch1.png'))
                          : Center(
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: LocalColors.black, width: 1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: Image.network(
                                    "https://api.vendoorr.com${model.branches[index].logo}",
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : Center(
                                              child:
                                                  CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: ConstantValues.PadWide,
            ),
            Text(
              "Location: ${model.branches[index].location}",
              style: TextStyle(
                color: LocalColors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget addNewBranchBtn(context) {
    return Padding(
      padding: EdgeInsets.all(ConstantValues.PadSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: LocalColors.black.withOpacity(0.15),
                builder: (context) {
                  return AddBranch();
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(ConstantValues.BorderRadius),
                color: LocalColors.primaryColor,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ConstantValues.PadSmall,
                vertical: 5,
              ),
              child: Text(
                "+ Add",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  color: LocalColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
