import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

class SettingsTabItem extends StatelessWidget {
  const SettingsTabItem({
    Key key,
    @required this.settingsPage,
    @required this.title,
    @required this.leftIcon,
    @required this.solid,
    @required this.iconName,
    @required this.selectedSettingsPage,
  }) : super(key: key);

  final SettingsPages settingsPage;
  final SettingsPages selectedSettingsPage;
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
              rootProv.settingsPagesSink.add(settingsPage);
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: selectedSettingsPage == settingsPage ? 10 : 5),
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: selectedSettingsPage == settingsPage
                    ? LocalColors.white.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(ConstantValues.BorderRadius),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    iconName,
                    color: selectedSettingsPage == settingsPage
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
                      color: selectedSettingsPage == settingsPage
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
