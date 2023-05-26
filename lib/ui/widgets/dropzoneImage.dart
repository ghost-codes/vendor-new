import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';

class DropzoneDisplay extends StatelessWidget {
  const DropzoneDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: LocalColors.grey, width: 1)),
      padding: EdgeInsets.all(ConstantValues.PadWide),
      child: Center(
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/svgs/image.svg",
              width: 50,
              color: LocalColors.grey,
            ),
            SizedBox(
              width: 15,
            ),
            Text("Drag and drop images here or click to use"),
          ],
        ),
      ),
    );
  }
}
