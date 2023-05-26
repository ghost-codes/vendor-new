import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_snackbar/material_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/popUpModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/authenticationService.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/core/viewModels/snackViewModel.dart';
import 'package:vendoorr/ui/authView.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/homeView.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthenticationService _authService = sl<AuthenticationService>();

  Api _api = sl<Api>();

  PrintingService printServ = sl<PrintingService>();

  @override
  void dispose() {
    _api.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (context) => RootProvider(),
    //   child: Scaffold(
    //     body: Stack(
    //       children: [
    //         StreamProvider<bool>(
    //             initialData: false,
    //             create: (context) => _authService.isLoggedIn.stream,
    //             builder: (context, snapshot) {
    //               Provider.of<RootProvider>(context, listen: false)
    //                   .setcontext(context);
    //               return StreamProvider<UserModel>(
    //                   initialData: null,
    //                   create: (context) => _authService.userController.stream,
    //                   child: Container(
    //                     child: Consumer2<UserModel, bool>(
    //                         builder: (context, user, isLoggedIn, child) {
    //                       return !(user != null || isLoggedIn)
    //                           ? AuthView()
    //                           : HomeView();
    //                     }),
    //                   ));
    //             }),
    //       ],
    //     ),
    //   ),
    // );

    return BaseView<RootProvider>(
      onModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              StreamProvider<bool>(
                initialData: false,
                create: (context) => _authService.isLoggedIn.stream,
                builder: (context, snapshot) {
                  return StreamProvider<UserModel>(
                    initialData: null,
                    create: (context) => _authService.userController.stream,
                    child: Container(
                      child: Consumer2<UserModel, bool>(
                        builder: (context, user, isLoggedIn, child) {
                          printServ.loggedUser = user;
                          return !(user != null || isLoggedIn)
                              ? AuthView()
                              : HomeView(
                                  isshowDialog: (user != null || isLoggedIn));
                        },
                      ),
                    ),
                  );
                },
              ),
              Snack(),
              SnackHandler(),
            ],
          ),
        );
      },
    );
  }
}

class SnackHandler extends StatelessWidget {
  SnackHandler({Key key}) : super(key: key);

  Api _api = sl<Api>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PopUp>(
      initialData: PopUp(action: false),
      stream: _api.snackBarStream,
      builder: (context, snapshot) {
        return AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          right: 10,
          bottom: snapshot.data.action ? 30 : -250,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: snapshot.hasData && snapshot.data.type == PopUpType.success
                  ? LocalColors.green
                  : LocalColors.error,
              borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
              boxShadow: ConstantValues.baseShadow,
            ),
            child: Center(
              child: Text(
                snapshot.data.message != null ? snapshot.data.message : "",
                style: TextStyle(
                    color: LocalColors.white,
                    fontFamily: "Montserrat",
                    fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Snack extends StatelessWidget {
  Api _api = sl<Api>();

  @override
  Widget build(BuildContext context) {
    return BaseView<SnackViewModel>(
      onModelReady: (model) {
        // model.registerStream(context);
      },
      builder: (context, model, _) {
        return StreamBuilder<bool>(
          initialData: false,
          stream: _api.slowInternetPopupStream,
          builder: (context, snapshot) {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 2500),
              curve: Curves.easeInOut,
              right: 10,
              bottom: snapshot.data ? 30 : -150,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: LocalColors.error,
                  borderRadius:
                      BorderRadius.circular(ConstantValues.BorderRadius),
                  boxShadow: ConstantValues.baseShadow,
                ),
                child: Center(
                  child: Text(
                    "Slow or No Internet Connection",
                    style: TextStyle(
                        color: LocalColors.white,
                        fontFamily: "Montserrat",
                        fontSize: 12),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
