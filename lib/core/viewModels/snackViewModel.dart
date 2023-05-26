import 'package:flutter/material.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class SnackViewModel extends BaseModel {
  bool allowSnackDisplay = true;

  Api _api = sl<Api>();

  registerStream(BuildContext context) {
    if (allowSnackDisplay) {
      allowSnackDisplay = false;
      _api.snackBarStream.listen((event) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(event.message),
          backgroundColor: LocalColors.error,
          elevation: 999,
        ));
      });
    }
  }
}
