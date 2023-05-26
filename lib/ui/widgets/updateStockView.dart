import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';

class UpdateStock extends StatelessWidget {
  const UpdateStock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalColors.offWhite,
      body: Container(
        decoration: BoxDecoration(
          color: LocalColors.white,
          boxShadow: ConstantValues.baseShadow,
          borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }
}
