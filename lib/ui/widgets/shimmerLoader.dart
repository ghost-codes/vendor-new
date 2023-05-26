import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';

class ShimmerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: LocalColors.offWhite,
        highlightColor: LocalColors.white,
        enabled: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
