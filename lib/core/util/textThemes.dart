import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/util/appColors.dart';

class LocalTextTheme {
  static TextStyle buttonTextStyle({Color color}) {
    return TextStyle(
      color: color ?? LocalColors.white,
      fontFamily: "Montserrat",
      fontSize: 16,
    );
    // return TextStyle(
    //   color: color ?? LocalColors.white,
    //   fontFamily: "Montserrat",
    //   fontWeight: FontWeight.bold,
    // );
  }

  static TextStyle pageHeader({Color color}) {
    return TextStyle(
      color: color ?? LocalColors.primaryColor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle cardHugeHeader({Color color}) {
    return TextStyle(
      color: color ?? LocalColors.primaryColor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      fontSize: 30,
    );
  }

  static const TextStyle header =
      TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w500);

  static const TextStyle body = TextStyle(
    fontFamily: "Montserrat",
  );
  static const TextStyle tableHeader = TextStyle(
    fontFamily: "Montserrat",
    color: LocalColors.primaryColor,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle tablebody = TextStyle(
    fontFamily: "Montserrat",
    color: LocalColors.primaryColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headerMain = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
    color: LocalColors.primaryColor,
  );
}
