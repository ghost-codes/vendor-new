import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.offWhite,
      body: Container(
        padding: EdgeInsets.all(ConstantValues.PadWide * 2),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
          boxShadow: ConstantValues.baseShadow,
          color: LocalColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: LocalTextTheme.cardHugeHeader(),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            TextField(
              decoration: inputDecoration(hintText: "Old Password"),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            TextField(
              decoration: inputDecoration(hintText: "New Password"),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            TextField(
              decoration: inputDecoration(hintText: "Repeat Password"),
            ),
            SizedBox(
              height: ConstantValues.PadSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallPrimaryButton(
                  text: "Reset",
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
