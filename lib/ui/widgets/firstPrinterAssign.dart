import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/constants.dart';
import 'package:vendoorr/core/util/loadersAndAnimations.dart';
import 'package:vendoorr/core/util/textThemes.dart';
import 'package:vendoorr/core/viewModels/firstPrinterAssignViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';
import 'package:vendoorr/ui/widgets/themeDropDown.dart';

class FirstPrinterAssign extends Modal {
  @override
  Widget build(BuildContext context) {
    return BaseView<FirstAssignViewModel>(onModelReady: (model) async {
      await model.onModel();
    }, builder: (context, model, child) {
      return buildBackdropFilter(
        closeFunction: () {
          Navigator.of(context).pop();
        },
        submitFunction: () {
          Navigator.of(context).pop();
        },
        width: 450,
        confirmText: "Save",
        header: "Printer Assignment",
        child: Material(
          color: LocalColors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: model.isChitEnabled,
                    onChanged: model.onEnableChit,
                  ),
                  SizedBox(
                    width: ConstantValues.PadSmall,
                  ),
                  Text("Enable Chit Printing", style: LocalTextTheme.body),
                ],
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
                                  await model.onPrinterSelect(value, "A");
                                },
                                items: model.printers == null ||
                                        model.printers == []
                                    ? [
                                        DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printers"))
                                      ]
                                    : List.generate(model.printers.length + 1,
                                        (index) {
                                        if (index == 0) {
                                          return DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printer Selected"),
                                          );
                                        }
                                        return DropdownMenuItem(
                                            value:
                                                model.printers[index - 1].url,
                                            child: Text(model
                                                .printers[index - 1].name));
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
                                  await model.onPrinterSelect(value, "B");
                                },
                                items: model.printers == [] ||
                                        model.printers == null
                                    ? [
                                        DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printers"))
                                      ]
                                    : List.generate(model.printers.length + 1,
                                        (index) {
                                        if (index == 0) {
                                          return DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printer Selected"),
                                          );
                                        }
                                        return DropdownMenuItem(
                                            value:
                                                model.printers[index - 1].url,
                                            child: Text(model
                                                .printers[index - 1].name));
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
                                  await model.onPrinterSelect(value, "C");
                                },
                                items: model.printers == [] ||
                                        model.printers == null
                                    ? [
                                        DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printers"))
                                      ]
                                    : List.generate(model.printers.length + 1,
                                        (index) {
                                        if (index == 0) {
                                          return DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printer Selected"),
                                          );
                                        }
                                        return DropdownMenuItem(
                                            value:
                                                model.printers[index - 1].url,
                                            child: Text(model
                                                .printers[index - 1].name));
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
                                  await model.onPrinterSelect(value, "D");
                                },
                                items: model.printers == [] ||
                                        model.printers == null
                                    ? [
                                        DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printers"))
                                      ]
                                    : List.generate(model.printers.length + 1,
                                        (index) {
                                        if (index == 0) {
                                          return DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printer Selected"),
                                          );
                                        }
                                        return DropdownMenuItem(
                                            value:
                                                model.printers[index - 1].url,
                                            child: Text(model
                                                .printers[index - 1].name));
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
                                  await model.onPrinterSelect(value, "E");
                                },
                                items: model.printers == [] ||
                                        model.printers == null
                                    ? [
                                        DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printers"))
                                      ]
                                    : List.generate(model.printers.length + 1,
                                        (index) {
                                        if (index == 0) {
                                          return DropdownMenuItem(
                                            value: '',
                                            child: Text("No Printer Selected"),
                                          );
                                        }
                                        return DropdownMenuItem(
                                            value:
                                                model.printers[index - 1].url,
                                            child: Text(model
                                                .printers[index - 1].name));
                                      }),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      );
    });
  }
}
