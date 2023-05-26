import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

class BranchTabItem extends StatelessWidget {
  const BranchTabItem({
    Key key,
    @required this.tabID,
    @required this.title,
    @required this.leftIcon,
    @required this.solid,
    @required this.iconName,
  }) : super(key: key);

  final double tabID;
  final String title;
  final String iconName;
  final IconData leftIcon;
  final IconData solid;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, model, child) {
        return Consumer<RootProvider>(builder: (context, rootProv, child) {
          return GestureDetector(
            onTap: () {
              rootProv.setSelectedBranchTab(tabID);
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: rootProv.selectedBranchTab == tabID ? 10 : 5),
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: rootProv.selectedBranchTab == tabID
                    ? LocalColors.white.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(ConstantValues.BorderRadius),
              ),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconName,
                    color: rootProv.selectedBranchTab == tabID
                        ? LocalColors.white
                        : LocalColors.white.withOpacity(0.3),
                    width: 25,
                  ),
                  SizedBox(
                    width: ConstantValues.PadSmall,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: rootProv.selectedBranchTab == tabID
                          ? LocalColors.white
                          : LocalColors.white.withOpacity(0.3),
                      fontFamily: "Montserrat",

                      // fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
