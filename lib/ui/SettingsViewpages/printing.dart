import 'dart:typed_data';

import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/inputBorder.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/util/themebuttons.dart';
import 'package:vendoorr/core/viewModels/printingViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/branchDetailsHeader.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class Printing extends StatelessWidget {
  Printing({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PrintingViewModel>(onModelReady: (model) async {
      await model.onModel();
    }, builder: (context, model, child) {
      return Consumer<RootProvider>(
          builder: (context, RootProvider rootProv, _) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PrintFormatHeader(),
                SizedBox(
                  height: ConstantValues.PadWide,
                ),
                Container(
                  color: LocalColors.offWhite,
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1 / 0.8,
                    child: Center(
                      child: rootProv.paperType == PaperType.A4
                          ? a4PrintPaper()
                          : p72mmPaper(),
                    ),
                  ),
                ),
                SizedBox(
                  height: ConstantValues.PadWide,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ConstantValues.PadWide * 1.5),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(ConstantValues.BorderRadius),
                    boxShadow: ConstantValues.baseShadow,
                    color: LocalColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other Printer Settings",
                        style: LocalTextTheme.headerMain,
                      ),
                      SizedBox(
                        height: ConstantValues.PadWide,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: model.isChitEnabled,
                            onChanged: model.onEnableChit,
                          ),
                          SizedBox(
                            width: ConstantValues.PadSmall,
                          ),
                          Text("Enable Chit Printing",
                              style: LocalTextTheme.body),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: model.isAutoChitPrint,
                            onChanged: model.onEnableAutoChit,
                          ),
                          SizedBox(
                            width: ConstantValues.PadSmall,
                          ),
                          Text("Enable Automatic Chit Printing",
                              style: LocalTextTheme.body),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: model.isTableBorderEnabled,
                            onChanged: model.onEnableTableBorder,
                          ),
                          SizedBox(
                            width: ConstantValues.PadSmall,
                          ),
                          Text("Enable Table Border on print",
                              style: LocalTextTheme.body),
                        ],
                      ),
                      SizedBox(
                        height: ConstantValues.PadWide,
                      ),
                      Text(
                        "Printer Assignmets",
                        style: LocalTextTheme.tableHeader,
                      ),
                      SizedBox(
                        height: ConstantValues.PadSmall,
                      ),
                      model.isPrintLoading
                          ? Center(
                              child: Loaders.fadingCube,
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Printer A",
                                      style: LocalTextTheme.body,
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    Expanded(
                                      child: ThemeDropDown(
                                        value: model.setPrinterA["url"],
                                        onChanged: (value) async {
                                          await model.onPrinterSelect(
                                              value, "A");
                                        },
                                        items: model.printers == null ||
                                                model.printers == []
                                            ? [
                                                DropdownMenuItem(
                                                    value: '',
                                                    child: Text("No Printers"))
                                              ]
                                            : List.generate(
                                                model.printers.length + 1,
                                                (index) {
                                                if (index == 0) {
                                                  return DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                        "No Printer Selected"),
                                                  );
                                                }
                                                return DropdownMenuItem(
                                                    value: model
                                                        .printers[index - 1]
                                                        .url,
                                                    child: Text(model
                                                        .printers[index - 1]
                                                        .name));
                                              }),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Printer B",
                                      style: LocalTextTheme.body,
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    Expanded(
                                      child: ThemeDropDown(
                                        value: model.setPrinterB["url"],
                                        onChanged: (value) async {
                                          await model.onPrinterSelect(
                                              value, "B");
                                        },
                                        items: model.printers == [] ||
                                                model.printers == null
                                            ? [
                                                DropdownMenuItem(
                                                    value: '',
                                                    child: Text("No Printers"))
                                              ]
                                            : List.generate(
                                                model.printers.length + 1,
                                                (index) {
                                                if (index == 0) {
                                                  return DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                        "No Printer Selected"),
                                                  );
                                                }
                                                return DropdownMenuItem(
                                                    value: model
                                                        .printers[index - 1]
                                                        .url,
                                                    child: Text(model
                                                        .printers[index - 1]
                                                        .name));
                                              }),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Printer C",
                                      style: LocalTextTheme.body,
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    Expanded(
                                      child: ThemeDropDown(
                                        value: model.setPrinterC["url"],
                                        onChanged: (value) async {
                                          await model.onPrinterSelect(
                                              value, "C");
                                        },
                                        items: model.printers == [] ||
                                                model.printers == null
                                            ? [
                                                DropdownMenuItem(
                                                    value: '',
                                                    child: Text("No Printers"))
                                              ]
                                            : List.generate(
                                                model.printers.length + 1,
                                                (index) {
                                                if (index == 0) {
                                                  return DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                        "No Printer Selected"),
                                                  );
                                                }
                                                return DropdownMenuItem(
                                                    value: model
                                                        .printers[index - 1]
                                                        .url,
                                                    child: Text(model
                                                        .printers[index - 1]
                                                        .name));
                                              }),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Printer D",
                                      style: LocalTextTheme.body,
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    Expanded(
                                      child: ThemeDropDown(
                                        value: model.setPrinterD["url"],
                                        onChanged: (value) async {
                                          await model.onPrinterSelect(
                                              value, "D");
                                        },
                                        items: model.printers == [] ||
                                                model.printers == null
                                            ? [
                                                DropdownMenuItem(
                                                    value: '',
                                                    child: Text("No Printers"))
                                              ]
                                            : List.generate(
                                                model.printers.length + 1,
                                                (index) {
                                                if (index == 0) {
                                                  return DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                        "No Printer Selected"),
                                                  );
                                                }
                                                return DropdownMenuItem(
                                                    value: model
                                                        .printers[index - 1]
                                                        .url,
                                                    child: Text(model
                                                        .printers[index - 1]
                                                        .name));
                                              }),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Printer E",
                                      style: LocalTextTheme.body,
                                    ),
                                    SizedBox(
                                      width: ConstantValues.PadSmall,
                                    ),
                                    Expanded(
                                      child: ThemeDropDown(
                                        value: model.setPrinterE["url"],
                                        onChanged: (value) async {
                                          await model.onPrinterSelect(
                                              value, "E");
                                        },
                                        items: model.printers == [] ||
                                                model.printers == null
                                            ? [
                                                DropdownMenuItem(
                                                    value: '',
                                                    child: Text("No Printers"))
                                              ]
                                            : List.generate(
                                                model.printers.length + 1,
                                                (index) {
                                                if (index == 0) {
                                                  return DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                        "No Printer Selected"),
                                                  );
                                                }
                                                return DropdownMenuItem(
                                                    value: model
                                                        .printers[index - 1]
                                                        .url,
                                                    child: Text(model
                                                        .printers[index - 1]
                                                        .name));
                                              }),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                      SizedBox(
                        height: ConstantValues.PadWide * 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reset Printing Information",
                              style: LocalTextTheme.tableHeader),
                          SmallSecondaryButton(
                              text: "Reset",
                              onPressed: () async {
                                model.clear();
                              })
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        );
      });
    });
  }

  Widget p72mmPaper() {
    return Consumer<PrintingViewModel>(builder: (context, model, _) {
      return Container(
        decoration: BoxDecoration(
          color: LocalColors.white,
          boxShadow: ConstantValues.baseShadow,
        ),
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ConstantValues.PadWide),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Header",
                                  style: TextStyle(
                                    color: LocalColors.black,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model
                                              .setHeaderAlign(HeaderAlign.Left);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ConstantValues
                                                          .BorderRadius),
                                              color: model.headerAlign ==
                                                      TextAlign.left
                                                  ? LocalColors.grey
                                                      .withOpacity(0.2)
                                                  : LocalColors.white),
                                          padding: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            "assets/svgs/left-align.svg",
                                            width: 18,
                                            color: LocalColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.setHeaderAlign(
                                              HeaderAlign.Center);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ConstantValues
                                                          .BorderRadius),
                                              color: model.headerAlign ==
                                                      TextAlign.center
                                                  ? LocalColors.grey
                                                      .withOpacity(0.2)
                                                  : LocalColors.white),
                                          padding: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            "assets/svgs/center-align.svg",
                                            width: 18,
                                            color: LocalColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.setHeaderAlign(
                                              HeaderAlign.Right);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ConstantValues
                                                          .BorderRadius),
                                              color: model.headerAlign ==
                                                      TextAlign.right
                                                  ? LocalColors.grey
                                                      .withOpacity(0.2)
                                                  : LocalColors.white),
                                          child: SvgPicture.asset(
                                            "assets/svgs/right-align.svg",
                                            width: 18,
                                            color: LocalColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        model.removeImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ConstantValues.PadSmall / 2),
                                        child: Icon(
                                          Icons.delete,
                                          color: LocalColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        model.onImageSelect();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ConstantValues.PadSmall / 2),
                                        child: Icon(
                                          Icons.image,
                                          color: LocalColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                                // width: 500,
                                child: Column(
                              children: [
                                model.imageOutput != null
                                    ? Container(
                                        width: 120,
                                        height: 120,
                                        child: Image.memory(model.imageOutput),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  width: ConstantValues.PadWide * 2,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      TextField(
                                        textAlign: model.headerAlign,
                                        // minLines: 1,
                                        maxLines: 4,

                                        controller: model.headerController,
                                        decoration: inputDecoration(
                                            hintText: "Header here"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FDottedLine(
                  color: LocalColors.primaryColor,
                  width: double.infinity,
                  strokeWidth: 2.0,
                  dottedLength: 10.0,
                  space: 2.0,
                )
              ],
            ),

            // Mid Section
            Container(
              width: 600,
              child: Text(
                "Body",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Footer
            Column(
              children: [
                FDottedLine(
                  color: LocalColors.primaryColor,
                  width: double.infinity,
                  strokeWidth: 2.0,
                  dottedLength: 10.0,
                  space: 2.0,
                ),
                Container(
                  padding: EdgeInsets.all(ConstantValues.PadWide),
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        child: Column(children: [
                          Column(
                            children: [
                              Text(
                                "Foooter  one",
                                style: TextStyle(
                                  color: LocalColors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ConstantValues.PadSmall,
                                  bottom: ConstantValues.PadSmall,
                                ),
                                child: TextField(
                                  maxLength: 50,
                                  controller: model.footerOne,
                                  decoration:
                                      inputDecoration(hintText: "Footer here"),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Foooter two",
                                style: TextStyle(
                                  color: LocalColors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ConstantValues.PadSmall,
                                  bottom: ConstantValues.PadSmall,
                                ),
                                child: TextField(
                                  maxLength: 50,
                                  controller: model.footerTwo,
                                  decoration:
                                      inputDecoration(hintText: "Footer here"),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget a4PrintPaper() {
    return Consumer<PrintingViewModel>(builder: (context, model, child) {
      return Container(
        decoration: BoxDecoration(
          color: LocalColors.white,
          boxShadow: ConstantValues.baseShadow,
        ),
        width: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ConstantValues.PadWide),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Header",
                                  style: TextStyle(
                                    color: LocalColors.black,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          model
                                              .setHeaderAlign(HeaderAlign.Left);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ConstantValues
                                                          .BorderRadius),
                                              color: model.headerAlign ==
                                                      TextAlign.left
                                                  ? LocalColors.grey
                                                      .withOpacity(0.2)
                                                  : LocalColors.white),
                                          padding: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            "assets/svgs/left-align.svg",
                                            width: 18,
                                            color: LocalColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.setHeaderAlign(
                                              HeaderAlign.Center);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ConstantValues
                                                          .BorderRadius),
                                              color: model.headerAlign ==
                                                      TextAlign.center
                                                  ? LocalColors.grey
                                                      .withOpacity(0.2)
                                                  : LocalColors.white),
                                          padding: EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            "assets/svgs/center-align.svg",
                                            width: 18,
                                            color: LocalColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          model.setHeaderAlign(
                                              HeaderAlign.Right);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ConstantValues
                                                          .BorderRadius),
                                              color: model.headerAlign ==
                                                      TextAlign.right
                                                  ? LocalColors.grey
                                                      .withOpacity(0.2)
                                                  : LocalColors.white),
                                          child: SvgPicture.asset(
                                            "assets/svgs/right-align.svg",
                                            width: 18,
                                            color: LocalColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        model.removeImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ConstantValues.PadSmall / 2),
                                        child: Icon(
                                          Icons.delete,
                                          color: LocalColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        model.onImageSelect();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            ConstantValues.PadSmall / 2),
                                        child: Icon(
                                          Icons.image,
                                          color: LocalColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                                // width: 500,
                                child: Row(
                              children: [
                                model.imageOutput != null
                                    ? Container(
                                        width: 120,
                                        height: 120,
                                        child: Image.memory(model.imageOutput),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  width: ConstantValues.PadWide * 2,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextField(
                                        textAlign: model.headerAlign,
                                        // minLines: 1,
                                        maxLines: 4,

                                        controller: model.headerController,
                                        decoration: inputDecoration(
                                            hintText: "Header here"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FDottedLine(
                  color: LocalColors.primaryColor,
                  width: double.infinity,
                  strokeWidth: 2.0,
                  dottedLength: 10.0,
                  space: 2.0,
                )
              ],
            ),

            // Mid Section
            Container(
              width: 600,
              child: Text(
                "Body",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Footer
            Column(
              children: [
                FDottedLine(
                  color: LocalColors.primaryColor,
                  width: double.infinity,
                  strokeWidth: 2.0,
                  dottedLength: 10.0,
                  space: 2.0,
                ),
                Container(
                  padding: EdgeInsets.all(ConstantValues.PadWide),
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        child: Column(children: [
                          Column(
                            children: [
                              Text(
                                "Foooter  one",
                                style: TextStyle(
                                  color: LocalColors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ConstantValues.PadSmall,
                                  bottom: ConstantValues.PadSmall,
                                ),
                                child: TextField(
                                  maxLength: 50,
                                  controller: model.footerOne,
                                  decoration:
                                      inputDecoration(hintText: "Footer here"),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Foooter two",
                                style: TextStyle(
                                  color: LocalColors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ConstantValues.PadSmall,
                                  bottom: ConstantValues.PadSmall,
                                ),
                                child: TextField(
                                  maxLength: 50,
                                  controller: model.footerTwo,
                                  decoration:
                                      inputDecoration(hintText: "Footer here"),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class PrintFormatHeader extends StatelessWidget {
  PrintingService printServ = sl<PrintingService>();
  PrintFormatHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PrintingViewModel>(builder: (context, model, _) {
      return BaseHeader(
        midSection: Text("Print Format"),
        button: Row(
          children: [
            SmallPrimaryButton(
              text: "Save",
              onPressed: () {
                model.onSave();
              },
            ),
            SizedBox(width: ConstantValues.PadSmall),
            Consumer<RootProvider>(builder: (context, rootProv, _) {
              return SmallPrimaryButton(
                text: "Preview",
                onPressed: () async {
                  var pdf = model.onPreview(context);
                  showDialog(
                      barrierColor: LocalColors.primaryColor.withOpacity(0.15),
                      context: context,
                      builder: (context) {
                        return PrintPreviewDialog(pdf,
                            rootProv.paperType == PaperType.P72 ? 500 : 700);
                      });
                },
              );
            }),
          ],
        ),
      );
    });
  }
}

class PrintPreviewDialog extends Modal {
  PrintingService printServ = sl<PrintingService>();
  final Future<Uint8List> pdf;
  final double width;

  PrintPreviewDialog(this.pdf, this.width);

  @override
  Widget build(BuildContext context) {
    return buildBackdropFilter(
        confirmText: "OK",
        width: width,
        closeFunction: () {
          Navigator.pop(context);
        },
        header: "Print Preview",
        child: Container(
          height: 500,
          child: PdfPreview(
              useActions: false,
              build: (format) async {
                return pdf;
              }),
        ));
  }
}
