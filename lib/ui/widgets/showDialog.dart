import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';

class Modal extends StatelessWidget {
  Widget buildBackdropFilter({
    double width,
    String confirmText = "Submit",
    Widget child,
    String header,
    Function closeFunction,
    Function submitFunction,
    Widget bottomButtons,
    Widget loader,
    bool isLoading = false,
  }) {
    return
        // BackdropFilter(
        //   // filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        //   child:
        SingleChildScrollView(
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: width,
          margin: EdgeInsets.symmetric(vertical: ConstantValues.PadWide * 3),
          decoration: BoxDecoration(
            color: LocalColors.white,
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
            boxShadow: ConstantValues.baseShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ConstantValues.PadWide),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      style: BorderStyle.solid,
                      color: LocalColors.grey,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      header,
                      style: TextStyle(
                          color: LocalColors.primaryColor,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    GestureDetector(
                        onTap: () {
                          closeFunction();
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(ConstantValues.PadWide),
                child: Column(
                  children: [
                    child,
                    SizedBox(height: ConstantValues.PadWide),
                    bottomButtons ??
                        TextButton(
                          style: ButtonStyle(),
                          onPressed: !isLoading ? submitFunction : null,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding:
                                EdgeInsets.all(ConstantValues.PadSmall / 2),
                            decoration: BoxDecoration(
                              color: LocalColors.primaryColor,
                              borderRadius: BorderRadius.circular(
                                  ConstantValues.BorderRadius),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLoading && loader != null
                                    ? loader
                                    : SizedBox.shrink(),
                                isLoading && loader != null
                                    ? SizedBox(
                                        width: ConstantValues.PadSmall,
                                      )
                                    : SizedBox.shrink(),
                                Text(
                                  confirmText,
                                  style: LocalTextTheme.buttonTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // ),
    );
  }

  InputDecoration inputDecoration(
      {String hintText, Widget prefix, bool isenabled = true}) {
    return InputDecoration(
      prefix: prefix,
      contentPadding: EdgeInsets.all(10),
      focusColor: LocalColors.error,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        borderSide: BorderSide(
          color: LocalColors.grey,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      disabledBorder: OutlineInputBorder(
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
          color: LocalColors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      filled: true,
      fillColor:
          isenabled ? LocalColors.white : LocalColors.grey.withOpacity(0.2),
      // hintText: hintText,
      labelText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      hintStyle: TextStyle(
        color: LocalColors.grey,
        fontFamily: "Montserrat",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
