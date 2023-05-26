import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';

class ConstantValues {
  static const double BorderRadius = 4;

  static const double PadSmall = 14;
  static const double PadWide = 20;

  static List<BoxShadow> baseShadow = [
    BoxShadow(
      blurRadius: 5,
      color: LocalColors.black.withOpacity(0.1),
      offset: Offset(0, 0),
      spreadRadius: 0,
    ),
    BoxShadow(
      blurRadius: 1,
      spreadRadius: 0,
      color: LocalColors.black.withOpacity(0.1),
      offset: Offset(0, 0),
    ),
  ];
}
