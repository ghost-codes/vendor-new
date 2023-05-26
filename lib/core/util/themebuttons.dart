import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/textThemes.dart';

class PrimaryLongButton extends StatelessWidget {
  PrimaryLongButton(
      {Key key,
      this.width,
      this.onPressed,
      this.text,
      this.color,
      this.isLoading,
      this.loader})
      : super(key: key);
  final double width;
  final Color color;
  final Function onPressed;
  final String text;
  bool isLoading = false;
  Widget loader;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color ?? LocalColors.primaryColor,
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      ),
      child: TextButton(
        onPressed: loader != null && isLoading ? null : onPressed,
        child: Container(
          padding: EdgeInsets.all(ConstantValues.PadSmall / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loader != null && isLoading
                  ? loader
                  : Text(
                      text,
                      style: LocalTextTheme.buttonTextStyle(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallPrimaryButton extends StatelessWidget {
  const SmallPrimaryButton({Key key, this.text, this.icon, this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ConstantValues.PadSmall / 2),
      decoration: BoxDecoration(
        color: LocalColors.primaryColor,
        borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
      ),
      child: TextButton(
        child: Row(
          children: [
            icon == null
                ? SizedBox.shrink()
                : Icon(
                    icon,
                    color: LocalColors.white,
                  ),
            text == null || icon == null
                ? SizedBox.shrink()
                : SizedBox(
                    width: 10,
                  ),
            text == null
                ? SizedBox.shrink()
                : Text(
                    text,
                    style: TextStyle(
                      color: LocalColors.white,
                      fontFamily: "Montserrat",
                    ),
                  ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SmallSecondaryButton extends StatelessWidget {
  const SmallSecondaryButton({Key key, this.text, this.onPressed})
      : super(key: key);
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ConstantValues.PadSmall / 2),
      decoration: BoxDecoration(
          color: LocalColors.primaryColor.withOpacity(0),
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          border: Border.all(
            color: LocalColors.primaryColor,
            width: 1,
            style: BorderStyle.solid,
          )),
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(
            color: LocalColors.primaryColor,
            fontFamily: "Montserrat",
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
