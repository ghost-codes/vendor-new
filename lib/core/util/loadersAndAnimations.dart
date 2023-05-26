import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendoorr/core/util/appColors.dart';

class Loaders {
  static SpinKitChasingDots fadingCube = SpinKitChasingDots(
    color: LocalColors.primaryColor,
    size: 25.0,
  );

  static SpinKitChasingDots fadinCubeWhiteSmall = SpinKitChasingDots(
    color: LocalColors.white,
    size: 20,
  );
  static SpinKitChasingDots fadinCubePrimSmall = SpinKitChasingDots(
    color: LocalColors.primaryColor,
    size: 20,
  );
}
