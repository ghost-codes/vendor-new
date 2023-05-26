import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

class BranchTabItem extends StatelessWidget {
  const BranchTabItem({
    Key key,
    @required this.branchPage,
    @required this.title,
    @required this.leftIcon,
    @required this.solid,
    @required this.iconName,
    @required this.show,
  }) : super(key: key);

  final BranchPages branchPage;
  final String title;
  final String iconName;
  final IconData leftIcon;
  final IconData solid;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show ?? false,
      child: Consumer2<HomeViewModel, RootProvider>(
        builder: (context, model, rootProv, child) {
          return Consumer<RootProvider>(builder: (context, rootProv, child) {
            return StreamBuilder<BranchPages>(
                stream: rootProv.branchPagesStream,
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      rootProv.branchPagesSink.add(branchPage);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: snapshot.data == branchPage ? 10 : 5),
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: snapshot.data == branchPage
                            ? LocalColors.white.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(ConstantValues.BorderRadius),
                      ),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            iconName,
                            color: snapshot.data == branchPage
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
                              color: snapshot.data == branchPage
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
          });
        },
      ),
    );
  }
}
