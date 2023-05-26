import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

class BaseHeader extends StatelessWidget {
  const BaseHeader({Key key, this.backLogic, this.button, this.midSection})
      : super(key: key);
  final Widget backLogic;
  final Widget button;
  final Widget midSection;

  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(builder: (context, rootProv, child) {
      return Container(
        decoration: BoxDecoration(
          color: LocalColors.white,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          boxShadow: ConstantValues.baseShadow,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ConstantValues.PadSmall / 2,
            horizontal: ConstantValues.PadSmall / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backLogic ?? SizedBox.shrink(),
              Expanded(
                child: midSection,
              ),
              Row(
                children: [
                  button ?? SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
