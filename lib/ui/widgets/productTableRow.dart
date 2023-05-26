import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';

class LocalTableRow extends StatelessWidget {
  final List<int> flexes;
  final List<Widget> tableRows;

  const LocalTableRow({Key key, this.flexes = const [], this.tableRows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(flexes.length <= tableRows.length);
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        tableRows.length,
        (index) {
          return Expanded(
            flex: index >= flexes.length ? 1 : flexes[index],
            child: tableRows[index],
          );
        },
      ),
    );
  }
}
