import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';

class ThemeDropDown extends StatelessWidget {
  ThemeDropDown({
    Key key,
    this.items,
    this.padding,
    this.margin,
    this.height,
    this.color,
    this.onChanged,
    this.value,
    this.onTap,
  }) : super(key: key);
  double padding;
  double margin;
  double height;
  Color color;
  Function onChanged;

  Function onTap;

  dynamic value;
  List<DropdownMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: margin ?? ConstantValues.PadSmall,
      ),
      padding:
          EdgeInsets.symmetric(horizontal: padding ?? ConstantValues.PadSmall),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? LocalColors.white,
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      ),
      child: DropdownButton(
        onTap: onTap,
        value: value,
        itemHeight: height,
        isExpanded: true,
        underline: Container(),
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
