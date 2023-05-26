import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/service/printingService.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

import 'package:vendoorr/core/viewModels/printingViewModel.dart';
import 'package:vendoorr/core/viewModels/rootProvider.dart';

// enum HeaderAlign { Left, Center, Right }

class SettingsViewModel extends BaseModel {
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();
  PrintingService printServ = sl<PrintingService>();

  List<dynamic> footer = ['', ''];
  List<TextEditingController> textControlListFooter = [];

  String header;
  TextEditingController headerController;
  File imageFile;
  Uint8List imageOutput;
  Directory output;
  TextAlign headerAlign = TextAlign.center;

  onModel() async {
    output = await getTemporaryDirectory();
    Directory tempDir = (await getApplicationDocumentsDirectory());
    imageFile = File(tempDir.path + "/vendoorr/printLogo");
    imageOutput = await imageFile.readAsBytes();
    // Fetch Header and footer from sharedPref
    footer = json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");

    final headerJson = await sharedPref.getStringValuesSF("header");

    if (headerJson != null) {
      header = json.decode(headerJson);
    } else {
      header = '';
    }
    headerController = TextEditingController(text: header);
    headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    // Check if sharedPref is empty and assigin new textEditing Controllers
    if (footer.length == 0) {
      textControlListFooter = [
        TextEditingController(),
        TextEditingController()
      ];
    } else {
      footer.forEach((element) {
        textControlListFooter.add(TextEditingController(text: element));
      });
    }

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
    footer = [];
    textControlListFooter.asMap().forEach((key, value) {
      footer.add(value.text);
    });

    await sharedPref.addStringToSF(key: "footer", value: json.encode(footer));
    await sharedPref.addStringToSF(key: "header", value: json.encode(header));
    await sharedPref.addStringToSF(
        key: "headerAlign", value: json.encode(headerToString()));

    notifyListeners();
  }

  onImageSelect() async {
    Directory tempDir = (await getApplicationDocumentsDirectory());
    // imageFile = File("");
    imageFile = File(tempDir.path + "/vendoorr/printLogo");
    FilePickerResult myFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    imageOutput = File(myFile.files[0].path).readAsBytesSync();
    await imageFile.writeAsBytes(imageOutput);

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
