import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/settingsViewModel.dart';
import 'package:vendoorr/ui/SettingsViewpages/staffRoles.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/SettingsViewpages/printing.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(builder: (context, rootProv, _) {
      return BaseView<SettingsViewModel>(
        onModelReady: (model) async {
          // await model.onModel();

          rootProv.settingsPagesSink.add(SettingsPages.Printing);
        },
        builder: (context, model, _) {
          return StreamBuilder(
              stream: rootProv.settingsPagesStream,
              builder: (context, AsyncSnapshot<SettingsPages> snapshot) {
                return Navigator(
                  onPopPage: (route, value) {
                    return true;
                  },
                  pages: [
                    // MaterialPage(child: AccountSettings()),
                    // if (snapshot.data == SettingsPages.Security)
                    //   MaterialPage(child: SecuritySettings()),
                    // if (snapshot.data == SettingsPages.Billing)
                    //   MaterialPage(child: BillingSettings()),
                    // if (snapshot.data == SettingsPages.Printing)
                    MaterialPage(child: Printing()),
                    if (snapshot.data == SettingsPages.StaffRoles)
                      MaterialPage(child: StaffRoles()),
                  ],
                );
              });
        },
      );
    });
  }
}
