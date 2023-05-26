import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

enum HeaderAlign { Left, Center, Right }

class PrintingViewModel extends BaseModel {
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
  PrintingService printServ = sl<PrintingService>();

  TextEditingController footerOne = TextEditingController();
  TextEditingController footerTwo = TextEditingController();

  Map<String, dynamic> setPrinterA = {"url": "", "categoriies": []};
  Map<String, dynamic> setPrinterB = {"url": "", "categoriies": []};
  Map<String, dynamic> setPrinterC = {"url": "", "categoriies": []};
  Map<String, dynamic> setPrinterD = {"url": "", "categoriies": []};
  Map<String, dynamic> setPrinterE = {"url": "", "categoriies": []};

  List<dynamic> footer = [];
  List<TextEditingController> textControlListFooter = [];
  List<Printer> printers = [];

  bool isPrintLoading = false;

  String header;
  TextEditingController headerController;
  File imageFile;
  Uint8List imageOutput;
  Directory output;
  TextAlign headerAlign = TextAlign.center;
  bool isChitEnabled = false;
  bool isAutoChitPrint = false;
  bool isTableBorderEnabled = false;

  onModel() async {
    output = await getTemporaryDirectory();
    Directory tempDir = (await getApplicationDocumentsDirectory());

    if (Platform.isWindows) {
      imageFile = File(tempDir.path + "\\vendoorr\\printLogo.png");
    } else {
      imageFile = File(tempDir.path + "/vendoorr/printLogo.png");
    }
    imageOutput = await imageFile.readAsBytes().catchError((err) {
      imageOutput = null;
    });
    // Fetch Header and footer from sharedPref

    isChitEnabled = json.decode(
            await sharedPref.getStringValuesSF("isChitEnabled") ?? "0") ==
        1;

    isAutoChitPrint = json.decode(
            await sharedPref.getStringValuesSF("isAutoChitPrint") ?? "0") ==
        1;
    isTableBorderEnabled = json.decode(
            await sharedPref.getStringValuesSF("isTableBorderEnabled") ??
                "0") ==
        1;

    footer = json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");

    final headerJson = await sharedPref.getStringValuesSF("header");

    if (headerJson != null) {
      header = json.decode(headerJson);
    } else {
      header = '';
    }
    headerController = TextEditingController(text: header);
    headerAlign = headerToTextAlign(
        await sharedPref.getStringValuesSF("headerAlign") ?? "");

    // Check if sharedPref is empty and assigin new textEditing Controllers
    if (footer.length == 2) {
      footerOne.text = footer[0];
      footerTwo.text = footer[1];
    } else if (footer.length == 1) {
      footerOne.text = footer[0];
    }

    printers = await printServ.printerList();

    printers.removeWhere((element) => (element.name == "OneNote (Desktop)" ||
        element.name == "OneNote for Windows 10" ||
        element.name == "Microsoft XPS Document Writer" ||
        element.name == "Microsoft Print to PDF" ||
        element.name == "Fax"));
    setPrinterA = json.decode(await sharedPref.getStringValuesSF("Printer A") ??
        """{"url": "", "categories": []}""");
    setPrinterB = json.decode(await sharedPref.getStringValuesSF("Printer B") ??
        """{"url": "", "categories": []}""");
    setPrinterC = json.decode(await sharedPref.getStringValuesSF("Printer C") ??
        """{"url": "", "categories": []}""");
    setPrinterD = json.decode(await sharedPref.getStringValuesSF("Printer D") ??
        """{"url": "", "categories": []}""");
    setPrinterE = json.decode(await sharedPref.getStringValuesSF("Printer E") ??
        """{"url": "", "categories": []}""");

    notifyListeners();
  }

  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    onModel();
    notifyListeners();
  }

  onPrinterSelect(String value, String printerVar) async {
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

  setHeaderAlign(HeaderAlign x) {
    headerAlign = headerAlignParse(x);
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

  TextAlign headerToTextAlign(String x) {
    switch (x) {
      case "left":
        return TextAlign.left;
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.right;

        break;
      default:
        return TextAlign.center;
    }
  }

  TextAlign headerAlignParse(HeaderAlign x) {
    switch (x) {
      case HeaderAlign.Left:
        return TextAlign.left;
      case HeaderAlign.Center:
        return TextAlign.center;
      case HeaderAlign.Right:
        return TextAlign.right;
    }
  }

  onSave() async {
    header = headerController.text;

    footer = [footerOne.text, footerTwo.text];

    await sharedPref.addStringToSF(key: "footer", value: json.encode(footer));
    await sharedPref.addStringToSF(key: "header", value: json.encode(header));
    await sharedPref.addStringToSF(
        key: "headerAlign", value: json.encode(headerToString()));

    notifyListeners();
  }

  onImageSelect() async {
    Directory tempDir = (await getApplicationDocumentsDirectory());

    if (Platform.isWindows) {
      imageFile = File(tempDir.path + "\\vendoorr\\printLogo.png");
    } else {
      imageFile = File(tempDir.path + "/vendoorr/printLogo.png");
    }

    FilePickerResult myFile = await FilePicker.platform.pickFiles();
    imageOutput = File(myFile.files[0].path).readAsBytesSync();

    await imageFile.writeAsBytes(imageOutput);

    notifyListeners();
  }

  onEnableChit(bool value) async {
    await sharedPref.addStringToSF(
        key: "isChitEnabled", value: value ? "1" : "0");

    isChitEnabled = value;
    notifyListeners();
  }

  onEnableAutoChit(bool value) async {
    await sharedPref.addStringToSF(
        key: "isAutoChitPrint", value: value ? "1" : "0");
    isAutoChitPrint = value;
    notifyListeners();
  }

  onEnableTableBorder(bool value) async {
    await sharedPref.addStringToSF(
        key: "isTableBorderEnabled", value: value ? "1" : "0");
    isTableBorderEnabled = value;
    notifyListeners();
  }

  removeImage() async {
    Directory tempDir = (await getApplicationDocumentsDirectory());

    if (Platform.isWindows) {
      imageFile = File(tempDir.path + "\\vendoorr\\printLogo.png");
    } else {
      imageFile = File(tempDir.path + "/vendoorr/printLogo.png");
    }

    await imageFile.delete();
    imageOutput = null;
    notifyListeners();
  }

  Future<Uint8List> onPreview(BuildContext context) async {
    onSave();
    Future<Uint8List> pdf;
    File file = File((await getApplicationDocumentsDirectory()).path +
        "/vendoorr/receipt.pdf");
    if (Provider.of<RootProvider>(context, listen: false).paperType ==
        PaperType.P72) {
      file.writeAsBytes(await (await printServ.printTemplate72()).save());
      pdf = (await printServ.printTemplate72()).save();
    } else {
      file.writeAsBytes(await (await printServ.printTemplateA4()).save());
      pdf = (await printServ.printTemplateA4()).save();
    }
    return pdf;
  }
}
