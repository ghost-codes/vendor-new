import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/authenticationService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(
      begin: 0.1,
      end: 0.98,
    ).animate(controller);

    return Container(
      color: LocalColors.white,
      child: Center(
        // child: Loaders.fadingCube,

        child: AnimatedBuilder(
            animation: animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo_sign_100x.png",
                  width: 150,
                ),
                Image.asset(
                  "assets/images/logo_text_100x.png",
                  width: 150,
                ),
              ],
            ),
            builder: (context, child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }),
      ),
    );
  }
}
