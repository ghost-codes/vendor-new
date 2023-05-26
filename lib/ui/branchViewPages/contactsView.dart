import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/contactViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/addContact.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/itemListTile.dart';

class ContactsView extends StatefulWidget {
  final String branchId;

  const ContactsView({Key key, this.branchId}) : super(key: key);

  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final flexes = [1, 4, 2, 2, 1];

  bool isHovered = false;

  int hoveredIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseView<ContactsViewModel>(onModelReady: (model) {
      model.init(widget.branchId);
    }, builder: (context, model, _) {
      return Container(
          color: LocalColors.offWhite,
          child: model.isLoading
              ? Center(
                  child: Loaders.fadingCube,
                )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Consumer2<RootProvider, UserModel>(
                    builder: (context, rootProv, userModel, _) {
                      return BaseHeader(
                        button: Visibility(
                          visible: userModel.userType == "Vendor" ||
                              userModel.userRole.canCreateContacts,
                          child: SmallPrimaryButton(
                              text: "+ Contact",
                              onPressed: () async {
                                bool result = await showDialog(
                                    barrierColor: LocalColors.primaryColor
                                        .withOpacity(0.2),
                                    context: context,
                                    builder: (context) {
                                      print(widget.branchId);
                                      return AddContact(widget.branchId);
                                    });

                                if (result) {
                                  model.init(widget.branchId);
                                }
                              }),
                        ),
                        midSection: Text(
                          "Contacts (${rootProv.header})",
                          style: LocalTextTheme.headerMain,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ConstantValues.PadSmall),
                  Expanded(
                    child: model.contacts.length == 0
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  "No Contacts To Show",
                                  style: LocalTextTheme.tableHeader,
                                ),
                                SizedBox(
                                  height: ConstantValues.PadSmall,
                                ),
                                SmallSecondaryButton(
                                    text: "Refresh",
                                    onPressed: () {
                                      model.init(widget.branchId);
                                    })
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: LocalColors.white,
                              boxShadow: ConstantValues.baseShadow,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  padding:
                                      EdgeInsets.all(ConstantValues.PadSmall),
                                  decoration: BoxDecoration(
                                      color: LocalColors.white,
                                      boxShadow: ConstantValues.baseShadow),
                                  child:
                                      ItemListTile(flexes: flexes, children: [
                                    Text(
                                      "Image",
                                      textAlign: TextAlign.center,
                                      style: LocalTextTheme.tableHeader,
                                    ),
                                    Text(
                                      "Name",
                                      style: LocalTextTheme.tableHeader,
                                    ),
                                    Text(
                                      "Phone",
                                      textAlign: TextAlign.center,
                                      style: LocalTextTheme.tableHeader,
                                    ),
                                    Text(
                                      "Email",
                                      textAlign: TextAlign.center,
                                      style: LocalTextTheme.tableHeader,
                                    ),
                                  ]),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: model.contacts.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onHover: (value) {
                                            setState(() {
                                              isHovered = value;
                                              hoveredIndex = index;
                                            });
                                          },
                                          onTap: () {},
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.easeInOut,
                                            decoration: BoxDecoration(
                                                border: isHovered &&
                                                        hoveredIndex == index
                                                    ? Border(
                                                        left: BorderSide(
                                                        width: 7,
                                                        color: LocalColors
                                                            .primaryColor,
                                                      ))
                                                    : Border(),
                                                color: isHovered &&
                                                        hoveredIndex == index
                                                    ? LocalColors.black
                                                        .withOpacity(0.02)
                                                    : Colors.transparent),
                                            height: 80,
                                            margin: EdgeInsets.only(
                                                bottom:
                                                    ConstantValues.PadSmall),
                                            padding: EdgeInsets.symmetric(
                                              vertical: ConstantValues.PadSmall,
                                              horizontal:
                                                  ConstantValues.PadWide,
                                            ),
                                            child: ItemListTile(
                                                flexes: flexes,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: LocalColors.grey
                                                            .withOpacity(0.3),
                                                      ),
                                                      child: model
                                                                      .contacts[
                                                                          index]
                                                                      .photo ==
                                                                  null ||
                                                              model
                                                                      .contacts[
                                                                          index]
                                                                      .photo ==
                                                                  ''
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/svgs/person.svg",
                                                                color:
                                                                    LocalColors
                                                                        .grey,
                                                                width: 20,
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child:
                                                                  Image.network(
                                                                "https://api.vendoorr.com${model.contacts[index].photo}",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                  Text(
                                                    model.contacts[index].name,
                                                    style: LocalTextTheme
                                                        .tablebody,
                                                  ),
                                                  Text(
                                                    model.contacts[index].phone,
                                                    textAlign: TextAlign.center,
                                                    style: LocalTextTheme
                                                        .tablebody,
                                                  ),
                                                  Text(
                                                    model.contacts[index].email,
                                                    textAlign: TextAlign.center,
                                                    style: LocalTextTheme
                                                        .tablebody,
                                                  ),
                                                ]),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                  )
                ]));
    });
  }
}
