import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class DeleteQueryDialogue extends Modal {
  final String header;
  final String bodyDelete;

  DeleteQueryDialogue({this.bodyDelete, this.header});
  @override
  Widget build(BuildContext context) {
    return buildBackdropFilter(
      header: header,
      width: 300,
      closeFunction: () {
        Navigator.of(context).pop();
      },
      // confirmText: "Delete",
      bottomButtons: PrimaryLongButton(
        color: LocalColors.error,
        text: "Delete",
      ),
      child: Container(
        child: Text(
          bodyDelete,
          style: LocalTextTheme.header,
        ),
      ),
    );
  }
}
