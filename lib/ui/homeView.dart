import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/service/authenticationService.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/viewModels/homeViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/branchTopView.dart';
import 'package:vendoorr/ui/dashBoardView.dart';
import 'package:vendoorr/ui/settings.dart';
import 'package:vendoorr/ui/widgets/branchDetailsVew.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/sideBar.dart';
import 'package:vendoorr/ui/widgets/tabItemWidget.dart';

class HomeView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  final bool isshowDialog;

  HomeView({this.isshowDialog});

  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();

  Api _api = sl<Api>();
  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(builder: (context, rootProv, _) {
      return BaseView<HomeViewModel>(
        onModelReady: (model) async {
          // rootProv.setBranchSelectedfalse();
        },
        builder: (context, model, child) {
          return Scaffold(
            body: Container(
              color: LocalColors.offWhite,
              child: Stack(
                children: [
                  Center(child: HomeHeader()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: LocalColors.primaryColor,
                              borderRadius: BorderRadius.circular(
                                  ConstantValues.BorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 7,
                                  offset: Offset(5, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Consumer<UserModel>(
                                  builder: (context, userModel, _) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // TabItem(
                                    //     iconName: "assets/svgs/dashboard.svg",
                                    //     tabID: 0,
                                    //     title: "Dashboard"),
                                    TabItem(
                                        show: true,
                                        iconName: "assets/svgs/agency.svg",
                                        title: "Home",
                                        tabID: 1),
                                    TabItem(
                                        show: true,
                                        iconName: "assets/svgs/settings.svg",
                                        title: "Settings",
                                        tabID: 2),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class HomeHeader extends StatelessWidget {
  HomeHeader({Key key}) : super(key: key);

  AuthenticationService _auth = sl<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 1400),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 60,
              padding: EdgeInsets.only(
                  left: ConstantValues.PadWide,
                  right: ConstantValues.PadWide,
                  top: ConstantValues.PadWide),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: 250,
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo_sign_100x.png",
                          fit: BoxFit.contain,
                          width: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Image.asset(
                            "assets/images/logo_text_200x.png",
                            fit: BoxFit.cover,
                            width: 110,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: ConstantValues.PadWide),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<HomeViewModel>(
                            builder: (context, model, _) {
                              return Row(
                                children: [
                                  CustomSettingsDropDown(),
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      "assets/svgs/logout.svg",
                                      width: 25,
                                      color: LocalColors.primaryColor,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        barrierColor: LocalColors.primaryColor
                                            .withOpacity(0.15),
                                        context: context,
                                        builder: (context) {
                                          return LogoutPopUp();
                                        },
                                      );
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(SnackBar(
                                      //   content: Text("Hello"),
                                      //   backgroundColor: LocalColors.error,
                                      // ));
                                      // Scaffold.of(context).showSnackBar(snackbar)
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return constraints.maxWidth >= 1300
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //main ui sideBar
                        Consumer<UserModel>(builder: (context, userModel, _) {
                          return SideBar(
                            isVendoor: userModel.userType == "Vendor",
                            userRole: userModel.userRole,
                          );
                        }),

                        Expanded(
                          child: Consumer2<HomeViewModel, UserModel>(
                            builder: (context, model, userModel, _) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ConstantValues.PadWide,
                                    vertical: ConstantValues.PadWide),
                                child: Navigator(
                                  pages: [
                                    MaterialPage(child: DashBoardView()),
                                    // if(userModel.userType =="vendor")BanchDetails(branch:null)
                                    if (model.selectedTab == 1.0) ...[
                                      if (userModel.userType == "Staff")
                                        MaterialPage(
                                            child: BranchDetail(
                                          branch: null,
                                        ))
                                      else
                                        MaterialPage(child: BranchTopView()),
                                    ],
                                    if (model.selectedTab == 2.0)
                                      MaterialPage(child: Settings()),
                                  ],
                                  onPopPage: (route, result) {
                                    return route.didPop(result);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        // ),
                      ],
                    )
                  : Consumer2<HomeViewModel, UserModel>(
                      builder: (context, model, userModel, _) {
                      return Stack(
                        children: [
                          //main ui sideBar

                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: ConstantValues.PadWide,
                                vertical: ConstantValues.PadWide),
                            child: Navigator(
                              pages: [
                                MaterialPage(child: DashBoardView()),
                                // if(userModel.userType =="vendor")BanchDetails(branch:null)
                                if (model.selectedTab == 1.0) ...[
                                  if (userModel.userType == "Staff")
                                    MaterialPage(
                                        child: BranchDetail(
                                      branch: null,
                                    ))
                                  else
                                    MaterialPage(child: BranchTopView()),
                                ],
                                if (model.selectedTab == 2.0)
                                  MaterialPage(child: Settings()),
                              ],
                              onPopPage: (route, result) {
                                return route.didPop(result);
                              },
                            ),
                          ),

                          Positioned(
                            left: model.expanded ? -20 : -280,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height - 50,
                                    child: SingleChildScrollView(child:
                                        Consumer<UserModel>(
                                            builder: (context, userModel, _) {
                                      return SideBar(
                                        userRole: userModel.userRole,
                                        isVendoor:
                                            userModel.userType == "Vendor",
                                      );
                                    }))),
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: InkWell(
                                      onTap: model.setSideBarExapnd,
                                      child: SvgPicture.asset(
                                        model.expanded
                                            ? "assets/svgs/side_collapse.svg"
                                            : "assets/svgs/side_expand.svg",
                                        width: 40,
                                        // colorBlendMode: BlendMode.clear,
                                        color: LocalColors.primaryColor,
                                      )),
                                )
                              ],
                            ),
                          ),

                          // ),
                        ],
                      );
                    });
            }),
          ),
        ],
      ),
    );
  }
}

class LogoutPopUp extends Modal {
  AuthenticationService _auth = sl<AuthenticationService>();
  Api _api = sl<Api>();
  @override
  Widget build(BuildContext context) {
    return buildBackdropFilter(
        confirmText: "Logout",
        submitFunction: () async {
          Navigator.pop(context);
          _api.authSink.add(true);
          await _auth.logout();
        },
        child: Center(
          child: Text(
            "Are you sure you want to logout",
            style: TextStyle(
              color: LocalColors.black,
              fontFamily: "Montserrat",
              fontSize: 16,
            ),
          ),
        ),
        header: "",
        width: 500,
        closeFunction: () {
          Navigator.pop(context);
        });
  }
}

class CustomSettingsDropDown extends StatefulWidget {
  const CustomSettingsDropDown({Key key}) : super(key: key);

  @override
  _CustomSettingsDropDownState createState() => _CustomSettingsDropDownState();
}

class _CustomSettingsDropDownState extends State<CustomSettingsDropDown> {
  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Focus(
        focusNode: this._focusNode,
        //  canRequestFocus: ,
        child: Container(
          decoration: BoxDecoration(
            color: LocalColors.white,
            borderRadius: BorderRadius.circular(ConstantValues.BorderRadius),
            boxShadow: ConstantValues.baseShadow,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ConstantValues.PadSmall,
            vertical: ConstantValues.PadSmall / 2,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: LocalColors.grey.withOpacity(0.3),
                radius: 15,
                child: Icon(
                  Icons.person_outline,
                  color: LocalColors.grey,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Consumer<UserModel>(
                builder: (context, userModel, child) {
                  return Text(
                    "${userModel?.username}",
                    // style: LocalTextTheme.body.,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
