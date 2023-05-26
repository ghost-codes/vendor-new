import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';

class DataUnitSettings extends StatelessWidget {
  const DataUnitSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LocalColors.offWhite,
      child: Center(child: Text("Data unit Settings")),
    );
  }
}
