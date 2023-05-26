import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabItem extends StatefulWidget {
  const TabItem({
    Key key,
    this.show = false,
    @required this.tabID,
    @required this.title,
    this.iconName,
  }) : super(key: key);

  final int tabID;
  final String iconName;
  final String title;
  final bool show;

  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool ishover = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.show,
      child: Consumer2<HomeViewModel, RootProvider>(
        builder: (context, model, rootProv, child) {
          return InkWell(
            onTap: () {
              rootProv.setHeader(widget.title);
              rootProv.setBranchSelectedfalse();
              model.setSelectedTab(widget.tabID);
            },
            onHover: (hover) {
              setState(() {
                ishover = hover;
              });
            },
            child: Container(
              padding: EdgeInsets.all(ConstantValues.PadSmall),
              decoration: BoxDecoration(
                color: ishover
                    ? Colors.black.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    widget.iconName,
                    color: model.selectedTab == widget.tabID
                        ? LocalColors.white
                        : LocalColors.white.withOpacity(0.3),
                    width: 20,
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: model.selectedTab == widget.tabID
                          ? LocalColors.white
                          : LocalColors.white.withOpacity(0.2),
                      fontFamily: "Montserrat",
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
