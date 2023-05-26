import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/ui/homeView.dart';
import 'package:vendoorr/ui/root.dart';
import 'package:vendoorr/ui/splashView.dart';
import 'package:window_size/window_size.dart';

void main() {
  initCheck();

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    setWindowMinSize(Size(1000, 700));
    setWindowMaxSize(Size.infinite);
  }

  setWindowTitle('Vendoorr Desktop');

  setupLocator();
  runApp(MyApp());
}

initCheck() {
  var tempDir;
  getApplicationDocumentsDirectory().then((value) {
    tempDir = value;

    bool dirExists = false;
    if (Platform.isWindows) {
      Directory(tempDir.path + "\\vendoorr\\").exists().then((value) {
        dirExists = value;
        if (!dirExists) {
          Directory(tempDir.path + "\\vendoorr\\").createSync();
        }
      });
    } else {
      Directory(tempDir.path + "/vendoorr/").exists().then((value) {
        dirExists = value;
        if (!dirExists) {
          Directory(tempDir.path + "/vendoorr/").createSync();
        }
      });
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: LocalColors.primaryColor,
      ),
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/': (context) => Root(),
        '/home': (context) => HomeView(),
        '/splash': (context) => SplashView(),
      },
    );
  }
}
