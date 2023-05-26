import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';

InputDecoration inputDecoration(
    {String hintText,
    bool makeHint = false,
    Widget prefix,
    bool isenabled = true,
    Widget suffix}) {
  return InputDecoration(
    prefix: prefix,
    suffix: suffix,
    contentPadding: EdgeInsets.all(10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      borderSide: BorderSide(
        color: LocalColors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      borderSide: BorderSide(
        color: LocalColors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      borderSide: BorderSide(
        color: LocalColors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    filled: true,
    fillColor:
        isenabled ? LocalColors.white : LocalColors.grey.withOpacity(0.2),
    hintText: !makeHint ? null : hintText,
    labelText: makeHint ? null : hintText,
    labelStyle: TextStyle(
      color: LocalColors.grey,
      fontFamily: "Montserrat",
    ),
  );
}
