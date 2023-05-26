import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class FirstAssignViewModel extends BaseModel {
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
  PrintingService printServ = sl<PrintingService>();

  TextEditingController footerOne = TextEditingController();
  TextEditingController footerTwo = TextEditingController();

  Map<String, dynamic> setPrinterA = {"url": "", "categories": []};
  Map<String, dynamic> setPrinterB = {"url": "", "categories": []};
  Map<String, dynamic> setPrinterC = {"url": "", "categories": []};
  Map<String, dynamic> setPrinterD = {"url": "", "categories": []};
  Map<String, dynamic> setPrinterE = {"url": "", "categories": []};

  List<dynamic> footer = [];
  List<TextEditingController> textControlListFooter = [];
  List<Printer> printers = [];

  bool isPrintLoading = false;

  String header = "";
  TextEditingController headerController;
  File imageFile;
  Uint8List imageOutput;
  Directory output;
  TextAlign headerAlign = TextAlign.center;
  bool isChitEnabled = false;

  onEnableChit(bool value) async {
    await sharedPref.addStringToSF(
        key: "isChitEnabled", value: value ? "1" : "0");
    isChitEnabled = value;
    notifyListeners();
  }

  onModel() async {
    isChitEnabled = json.decode(
            await sharedPref.getStringValuesSF("isChitEnabled") ?? "0") ==
        1;

    printers = await printServ.printerList();

    printers.removeWhere((element) => (element.name == "OneNote (Desktop)" ||
        element.name == "OneNote for Windows 10" ||
        element.name == "Microsoft XPS Document Writer" ||
        element.name == "Microsoft Print to PDF" ||
        element.name == "Fax"));

    notifyListeners();
  }

  String headerToString() {
    switch (headerAlign) {
      case TextAlign.left:
        return "left";
      case TextAlign.center:
        return "center";
      case TextAlign.right:
        return "right";
      default:
        return "center";
    }
  }

  onPrinterSelect(String value, String printerVar) async {
    await sharedPref.addStringToSF(key: "footer", value: json.encode(footer));
    await sharedPref.addStringToSF(key: "header", value: json.encode(header));
    await sharedPref.addStringToSF(
        key: "headerAlign", value: json.encode(headerToString()));
    switch (printerVar) {
      case "A":
        setPrinterA["url"] = value;
        break;
      case "B":
        setPrinterB["url"] = value;
        break;
      case "C":
        setPrinterC["url"] = value;
        break;
      case "D":
        setPrinterD["url"] = value;
        break;
      case "E":
        setPrinterE["url"] = value;
        break;
      default:
        setPrinterA["url"] = value;
        break;
    }
    await sharedPref.addStringToSF(
        key: "Printer A", value: json.encode(setPrinterA));
    await sharedPref.addStringToSF(
        key: "Printer B", value: json.encode(setPrinterB));
    await sharedPref.addStringToSF(
        key: "Printer C", value: json.encode(setPrinterC));
    await sharedPref.addStringToSF(
        key: "Printer D", value: json.encode(setPrinterD));
    await sharedPref.addStringToSF(
        key: "Printer E", value: json.encode(setPrinterE));
    notifyListeners();
  }
}
