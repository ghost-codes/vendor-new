import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/widgets/addCategory.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({Key key, this.branchId}) : super(key: key);
  final String branchId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<RootProvider>(
          builder: (context, rootProv, _) {
            return BaseHeader(
              button: SmallPrimaryButton(
                onPressed: () {
                  showDialog(
                      barrierColor: LocalColors.primaryColor.withOpacity(0.15),
                      context: context,
                      builder: (context) {
                        return Container();
                      });
                },
                text: "+ Service",
              ),
              midSection: Text(
                "Services (${rootProv.header})",
                style: LocalTextTheme.headerMain,
              ),
            );
          },
        ),
        SizedBox(height: ConstantValues.PadSmall),
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
                  padding: EdgeInsets.all(ConstantValues.PadSmall),
                  decoration: BoxDecoration(
                      color: LocalColors.white,
                      boxShadow: ConstantValues.baseShadow),
                  child: ItemListTile(
                    flexes: [1, 1, 1, 1],
                    children: [
                      Text(
                        "Name",
                        style: LocalTextTheme.tableHeader,
                      ),
                      Text(
                        "Price",
                        style: LocalTextTheme.tableHeader,
                      ),
                      // Text(
                      //   "Servicer",
                      //   style: LocalTextTheme.tableHeader,
                      // ),
                      Text(
                        "Description",
                        style: LocalTextTheme.tableHeader,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      margin: EdgeInsets.only(bottom: ConstantValues.PadSmall),
                      padding: EdgeInsets.all(ConstantValues.PadSmall),
                      child: ItemListTile(
                        flexes: [1, 1, 1, 1],
                        children: [
                          Text(
                            "Name",
                            style: LocalTextTheme.tablebody,
                          ),
                          Text(
                            "Price",
                            style: LocalTextTheme.tablebody,
                          ),
                          // Text(
                          //   "Servicer",
                          //   style: LocalTextTheme.tablebody,
                          // ),
                          Text(
                            "Description",
                            style: LocalTextTheme.tablebody,
                          ),
                        ],
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
