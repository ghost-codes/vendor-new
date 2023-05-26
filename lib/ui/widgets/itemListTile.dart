import 'package:flutter/material.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile(
      {Key key, this.children, this.flexes, this.crossAxisAlignment})
      : super(key: key);

  final List<Widget> children;
  final List<int> flexes;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: List.generate(
        children.length,
        (index) => Expanded(
          flex: flexes[index],
          child: children[index],
        ),
      ),
    );
  }
}
