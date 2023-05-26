import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/branchModel.dart';
import 'package:vendoorr/core/models/orderModel.dart';
import 'package:vendoorr/core/models/saleModel.dart';
import 'package:vendoorr/core/models/tabModel.dart';
import 'package:vendoorr/core/models/user.dart';
import 'package:vendoorr/core/service/sharedPreferences.dart';
import 'package:path_provider/path_provider.dart';

class PrintingService {
  SharedPreferencesService sharedPref = sl<SharedPreferencesService>();

  UserModel loggedUser;
  BranchModel branch;

  TextStyle style = TextStyle(fontSize: 9);
  TextStyle boldStyle = TextStyle(fontSize: 9, fontWeight: FontWeight.bold);
  TextStyle a4Style = TextStyle(fontSize: 11);
  TextStyle a4BoldStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);

  final _tableColumnWidths = {
    0: FractionColumnWidth(3 / 7),
    1: FractionColumnWidth(2 / 7),
    3: FractionColumnWidth(2 / 7),
  };

  TableBorder _tableBorder;

  Future<void> setTableBorder() async {
    if (json.decode(
            await sharedPref.getStringValuesSF("isTableBorderEnabled") ??
                "0") ==
        1) {
      _tableBorder = TableBorder.all(color: PdfColors.black);
      return;
    }
    _tableBorder = TableBorder();
    return;
  }

  printToPdf(List<int> byte) async {
    Directory tempDir = (await getApplicationDocumentsDirectory());

    File file = File(tempDir.path + "\\vendoorr\\receipt.pdf") ?? null;
    print(file.absolute);
    file.writeAsBytes(byte);
  }

  dynamic multipage72(
    int items, {
    List<Widget> body,
    List<dynamic> footer,
  }) {
    if (items <= 12)
      return Page(
          pageFormat: PdfPageFormat(PdfPageFormat.mm * 72, double.infinity,
              marginAll: 7),
          build: (_) => Center(
                  child: Column(children: [
                ...body,
                Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Footer
                        ...List.generate(
                            footer.length,
                            (index) => Text(
                                  footer[index],
                                  style: style,
                                )),
                        // Vendoorr watermark
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Text("Vendoorr Technologies", style: style),
                            Text("www.vendoorr.com", style: style),
                          ],
                        ),
                      ]),
                ),
              ])));
    return MultiPage(
      pageFormat: PdfPageFormat(PdfPageFormat.mm * 72, PdfPageFormat.mm * 129,
          marginAll: 7),
      footer: (_) => Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Footer
          ...List.generate(
              footer.length,
              (index) => Text(
                    footer[index],
                    style: style,
                  )),
          // Vendoorr watermark
          SizedBox(height: 10),
          Column(
            children: [
              Text("Vendoorr Technologies", style: style),
              Text("www.vendoorr.com", style: style),
            ],
          ),
        ]),
      ),
      build: (_) => body,
    );
  }

  printerPicker() async {
    final pdf = Document();

    List<Printer> x = await Printing.listPrinters();

    bool result = await Printing.directPrintPdf(
        printer: x[4],
        onLayout: (pageFormat) async {
          // Directory tempDir = (await getApplicationDocumentsDirectory());

          List footer =
              json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");

          Directory tempDir = (await getApplicationDocumentsDirectory());
          File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
          Uint8List image;
          image = await file.readAsBytes().onError((error, stackTrace) {
            if (error != null) {
              image = null;
            }
            return null;
          });
          String header =
              json.decode(await sharedPref.getStringValuesSF("header") ?? "[]");
          TextAlign headerAlign = headerToTextAlign(
              json.decode(await sharedPref.getStringValuesSF("headerAlign")));

          pdf.addPage(
            Page(
                pageFormat: pageFormat,
                build: (Context context) {
                  return Center(
                    child: Column(children: [
                      Row(children: [
                        Container(
                          width: 100,
                          child: Image(MemoryImage(
                            image,
                          )),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  loggedUser.vendorName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "${branch.branchName}, ${branch.location}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: Text(header,
                                      style: style, textAlign: headerAlign),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      Expanded(child: Container()),
                      ...List.generate(
                          footer.length,
                          (index) => Text(
                                footer[index],
                                style: style,
                              ))
                    ]),
                  );
                }),
          );
          return pdf.save();
        });
  }

  Future<List<Printer>> printerList() async {
    return await Printing.listPrinters();
  }

// Templates
  Future<Document> printTemplateFooter72() async {
    final pdf = Document();
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");

    pdf.addPage(
      Page(
          pageFormat: PdfPageFormat(PdfPageFormat.mm * 72, double.infinity,
              marginAll: 7),
          build: (Context context) {
            return Center(
              child: Column(
                children: List.generate(footer.length, (index) {
                  return Text(
                    footer[index]["value"],
                    style: style,
                  );
                }),
              ),
            );
          }),
    );
    return pdf;
  }

  Future<Document> printTemplate72() async {
    final pdf = Document();
    Directory tempDir = (await getApplicationDocumentsDirectory());

    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });

    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "");
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat(PdfPageFormat.mm * 72, PdfPageFormat.mm * 290,
            marginAll: 7),
        build: (Context context) {
          return Center(
            child: Column(
              children: [
                Center(
                  child: image == null
                      ? SizedBox.shrink()
                      : Container(
                          width: 100,
                          child: Image(MemoryImage(
                            image,
                          )),
                        ),
                ),
                Column(
                  children: [
                    Text(
                      loggedUser.vendorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${branch.branchName}, ${branch.location}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Text(header, style: style, textAlign: headerAlign),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                ...List.generate(
                    footer.length,
                    (index) => Text(
                          footer[index],
                          style: style,
                        ))
              ],
            ),
          );
        },
      ),
    );
    return pdf;
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

  Future<Document> printTemplateA4() async {
    final pdf = Document();
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");

    Directory tempDir = (await getApplicationDocumentsDirectory());
    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });
    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    pdf.addPage(
      Page(
          pageFormat: PdfPageFormat.a4,
          build: (Context context) {
            return Center(
              child: Column(children: [
                Row(children: [
                  Center(
                    child: image == null
                        ? SizedBox.shrink()
                        : Container(
                            width: 100,
                            child: Image(MemoryImage(
                              image,
                            )),
                          ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            loggedUser.vendorName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: PdfColors.black,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${branch.branchName}, ${branch.location}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: PdfColors.black,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: Text(header,
                                style: style, textAlign: headerAlign),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                Expanded(child: Container()),
                ...List.generate(
                    footer.length,
                    (index) => Text(
                          footer[index],
                          style: style,
                        ))
              ]),
            );
          }),
    );
    return pdf;
  }

  Future<Document> printTemplateFooterA4() async {
    final pdf = Document();
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");

    pdf.addPage(
      Page(
          pageFormat: PdfPageFormat(21.0 * PdfPageFormat.cm, double.infinity,
              marginAll: 7),
          build: (Context context) {
            return Center(
              child: Column(
                children: List.generate(footer.length, (index) {
                  return Text(
                    footer[index]["value"],
                    style: style,
                  );
                }),
              ),
            );
          }),
    );
    return pdf;
  }

  pdfHeaderSizeA4temp() async {
    final pdf = Document();
    String footer = await sharedPref.getStringValuesSF("footer");
    pdf.addPage(
      Page(
          pageFormat: PdfPageFormat(21.0 * PdfPageFormat.cm, double.infinity),
          build: (Context context) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 100, width: 100, color: PdfColors.black),
                        Expanded(
                            child: Column(children: [
                          Text("Temp", style: style),
                          Text("Temp", style: style),
                          Text("Temp", style: style),
                          Text("Temp", style: style),
                          Text("Temp", style: style),
                        ]))
                      ]),
                ),
                SizedBox(height: 20),
                Expanded(child: Container()),
                Text(
                  footer,
                  style: style,
                ),
              ],
            );
          }),
    );
    return pdf;
  }

  Future<String> pdfFooter() async {
    String footer = await sharedPref.getStringValuesSF("footer");
    return footer == null ? "" : footer;
  }

// Real work below
  printChit(
      {List<OrderItem> orderItems,
      String associatedPrinterUrl,
      OrderModel orderObj}) async {
    final pdf = Document();

    Printer associatedPrinter = (await printerList())
        .singleWhere((element) => element.url == associatedPrinterUrl);
    await setTableBorder();
    bool result = await Printing.directPrintPdf(
        printer: associatedPrinter,
        onLayout: (PdfPageFormat page) {
          if (page.width < 273) {
            pdf.addPage(
              Page(
                pageFormat: PdfPageFormat(
                    PdfPageFormat.mm * 72, double.infinity,
                    marginAll: 7),
                build: (Context context) {
                  return Column(
                    // crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order item(s)",
                        style: style,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${orderObj.name}", style: style),
                            Text("Attendant: ${orderObj.attendant}",
                                style: style),
                            Text("Time/Date: ${orderObj.modified}",
                                style: style),
                          ],
                        ),
                      ),
                      Container(height: 20),
                      Column(
                        children: [
                          Table(
                              columnWidths: _tableColumnWidths,
                              border: _tableBorder,
                              children: [
                                TableRow(
                                  children: [
                                    Text("Name",
                                        textAlign: TextAlign.center,
                                        style: style),
                                    Text("GHS",
                                        textAlign: TextAlign.center,
                                        style: style),
                                    Text("QTY",
                                        textAlign: TextAlign.center,
                                        style: style)
                                  ],
                                ),
                                ...List.generate(
                                  orderItems.length,
                                  (index) => TableRow(children: [
                                    Text(orderItems[index].name,
                                        textAlign: TextAlign.center,
                                        style: style),
                                    Text(orderItems[index].price,
                                        textAlign: TextAlign.center,
                                        style: style),
                                    Text(orderItems[index].quantity.toString(),
                                        textAlign: TextAlign.center,
                                        style: style)
                                  ]),
                                )
                              ]),
                        ],
                      ),
                      // Vendoorr watermark
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text("Vendoorr Technologies", style: style),
                          Text("www.vendoorr.com", style: style),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
            // printToPdf(await pdf.save());
          } else {}
          return pdf.save();
        });

    // printToPdf(await pdf.save());
  }

  printReceipt(SaleModel sale) async {
    final pdf72 = Document();
    final pdfA4 = Document();
    Directory tempDir = (await getApplicationDocumentsDirectory());
    await setTableBorder();
    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });

    Map<String, dynamic> printerA =
        json.decode(await sharedPref.getStringValuesSF("Printer A")) ??
            {"url": '', "categories": []};

    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "");
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    List<Printer> printers = await Printing.listPrinters();
    Printer printer =
        printers.singleWhere((element) => element.url == printerA["url"]);
    bool result = await Printing.directPrintPdf(
        printer: printer,
        onLayout: (PdfPageFormat pageformat) {
          if (pageformat.width < 273) {
            pdf72.addPage(
              multipage72(
                sale.saleItems.length,
                body: receipt72MockUp(
                    image: image,
                    sale: sale,
                    header: header,
                    headerAlign: headerAlign,
                    footer: footer),
                footer: footer,
              ),
            );
            return pdf72.save();
          } else {
            pdfA4.addPage(MultiPage(
              margin:
                  EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 100),
              pageFormat: PdfPageFormat.a4,
              footer: (context) {
                return Center(
                  child: Column(
                    children: [
                      ...List.generate(
                        footer.length,
                        (index) => Text(
                          footer[index],
                          style: style,
                        ),
                      ),

                      // Vendoorr watermark
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text("Vendoorr Technologies", style: style),
                          Text("www.vendoorr.com", style: style),
                        ],
                      ),
                    ],
                  ),
                );
              },
              build: (context) {
                return receiptA4MockUp(
                    image: image,
                    sale: sale,
                    header: header,
                    headerAlign: headerAlign,
                    footer: footer);
              },
            ));
            return pdfA4.save();
          }
        });
  }

  printCreditTab(TabModel tab) async {
    final pdf72 = Document();
    final pdfA4 = Document();
    Directory tempDir = (await getApplicationDocumentsDirectory());
    await setTableBorder();
    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });

    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "");
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    Map<String, dynamic> printerA =
        json.decode(await sharedPref.getStringValuesSF("Printer A")) ??
            {"url": '', "categories": []};

    List<Printer> printers = await Printing.listPrinters();
    Printer printer =
        printers.singleWhere((element) => element.url == printerA["url"]);

    bool result = await Printing.directPrintPdf(
        printer: printer,
        onLayout: (PdfPageFormat pageformat) {
          if (pageformat.width < 273) {
            pdf72.addPage(multipage72(tab.records.length,
                body: tabRecord72Mockup(
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    image: image,
                    tab: tab),
                footer: footer));
            // printToPdf(await pdf72.save());
            return pdf72.save();
          } else {
            pdfA4.addPage(MultiPage(
              margin:
                  EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 100),
              pageFormat: PdfPageFormat.a4,
              footer: (context) {
                return Center(
                  child: Column(
                    children: [
                      ...List.generate(
                        footer.length,
                        (index) => Text(
                          footer[index],
                          style: style,
                        ),
                      ),

                      // Vendoorr watermark
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text("Vendoorr Technologies", style: style),
                          Text("www.vendoorr.com", style: style),
                        ],
                      ),
                    ],
                  ),
                );
              },
              build: (context) {
                return tabRecordA4Mockup(
                    image: image,
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    tab: tab);
              },
            ));
            return pdfA4.save();
          }
        });
  }

  printDebtorOrCreditorTabs(List<TabModel> tabs) async {
    final pdf72 = Document();
    final pdfA4 = Document();
    Directory tempDir = (await getApplicationDocumentsDirectory());
    await setTableBorder();
    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });

    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "");
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    Map<String, dynamic> printerA =
        json.decode(await sharedPref.getStringValuesSF("Printer A")) ??
            {"url": '', "categories": []};

    List<Printer> printers = await Printing.listPrinters();
    Printer printer =
        printers.singleWhere((element) => element.url == printerA["url"]);

    bool result = await Printing.directPrintPdf(
        printer: printer,
        onLayout: (PdfPageFormat pageformat) async {
          if (pageformat.width < 273) {
            pdf72.addPage(
              multipage72(
                tabs.length,
                body: tabs72MockUp(
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    image: image,
                    tabs: tabs),
                footer: footer,
              ),
            );

            return pdf72.save();
          } else {
            pdfA4.addPage(MultiPage(
              margin:
                  EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 100),
              pageFormat: PdfPageFormat.a4,
              footer: (context) {
                return Center(
                  child: Column(
                    children: [
                      ...List.generate(
                        footer.length,
                        (index) => Text(
                          footer[index],
                          style: style,
                        ),
                      ),

                      // Vendoorr watermark
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text("Vendoorr Technologies", style: style),
                          Text("www.vendoorr.com", style: style),
                        ],
                      ),
                    ],
                  ),
                );
              },
              build: (context) {
                return tabsA4MockUp(
                    image: image,
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    tabs: tabs);
              },
            ));

            return pdfA4.save();
          }
        });
  }

  printCreditRecord(Record record) async {
    final pdf72 = Document();
    final pdfA4 = Document();
    Directory tempDir = (await getApplicationDocumentsDirectory());
    await setTableBorder();
    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });

    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "");
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    Map<String, dynamic> printerA =
        json.decode(await sharedPref.getStringValuesSF("Printer A")) ??
            {"url": '', "categories": []};

    List<Printer> printers = await Printing.listPrinters();
    Printer printer =
        printers.singleWhere((element) => element.url == printerA["url"]);

    bool result = await Printing.directPrintPdf(
        printer: printer,
        onLayout: (PdfPageFormat pageformat) {
          if (pageformat.width < 273) {
            pdf72.addPage(multipage72(record.recordItems.length,
                body: record72Mockup(
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    image: image,
                    record: record),
                footer: footer));
            // printToPdf(await pdf72.save());
            return pdf72.save();
          } else {
            pdfA4.addPage(MultiPage(
              margin:
                  EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 100),
              pageFormat: PdfPageFormat.a4,
              footer: (context) {
                return Center(
                  child: Column(
                    children: [
                      ...List.generate(
                        footer.length,
                        (index) => Text(
                          footer[index],
                          style: style,
                        ),
                      ),

                      // Vendoorr watermark
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text("Vendoorr Technologies", style: style),
                          Text("www.vendoorr.com", style: style),
                        ],
                      ),
                    ],
                  ),
                );
              },
              build: (context) {
                return recordA4Mockup(
                    image: image,
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    record: record);
              },
            ));
            return pdfA4.save();
          }
        });
  }

  printProformer(
    OrderModel order,
  ) async {
    final pdf72 = Document();
    final pdfA4 = Document();
    Directory tempDir = (await getApplicationDocumentsDirectory());
    await setTableBorder();

    File file = File(tempDir.path + "\\vendoorr\\printLogo.png") ?? null;
    Uint8List image;
    image = await file.readAsBytes().onError((error, stackTrace) {
      if (error != null) {
        image = null;
      }
      return null;
    });

    String header =
        json.decode(await sharedPref.getStringValuesSF("header") ?? "");
    List footer =
        json.decode(await sharedPref.getStringValuesSF("footer") ?? "[]");
    TextAlign headerAlign = headerToTextAlign(
        json.decode(await sharedPref.getStringValuesSF("headerAlign")));

    Map<String, dynamic> printerA =
        json.decode(await sharedPref.getStringValuesSF("Printer A")) ??
            {"url": '', "categories": []};

    List<Printer> printers = await Printing.listPrinters();
    Printer printer =
        printers.singleWhere((element) => element.url == printerA["url"]);

    bool result = await Printing.directPrintPdf(
        printer: printer,
        onLayout: (PdfPageFormat pageformat) {
          if (pageformat.width < 273) {
            pdf72.addPage(
              multipage72(order.orderItems.length,
                  footer: footer,
                  body: profomer72MockUp(
                      footer: footer,
                      headerAlign: headerAlign,
                      header: header,
                      image: image,
                      order: order)),
            );
            // printToPdf(await pdf72.save());
            return pdf72.save();
          } else {
            pdfA4.addPage(MultiPage(
              margin:
                  EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 100),
              pageFormat: PdfPageFormat.a4,
              footer: (context) {
                return Center(
                  child: Column(
                    children: [
                      ...List.generate(
                        footer.length,
                        (index) => Text(
                          footer[index],
                          style: style,
                        ),
                      ),

                      // Vendoorr watermark
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text("Vendoorr Technologies", style: style),
                          Text("www.vendoorr.com", style: style),
                        ],
                      ),
                    ],
                  ),
                );
              },
              build: (context) {
                return proformerA4Mockup(
                    image: image,
                    footer: footer,
                    headerAlign: headerAlign,
                    header: header,
                    order: order);
              },
            ));
            return pdfA4.save();
          }
        });
  }

  // MockUps

  List<Widget> recordA4Mockup(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      Record record}) {
    return <Widget>[
      Row(children: [
        Center(
          child: image == null
              ? SizedBox.shrink()
              : Container(
                  width: 100,
                  child: Image(MemoryImage(
                    image,
                  )),
                ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  loggedUser.vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${branch.branchName}, ${branch.location}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Text(header, style: style, textAlign: headerAlign),
                ),
              ],
            ),
          ),
        ),
      ]),

      SizedBox(height: 15),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:  ${record.description}', style: a4BoldStyle),
            Text('Record id:  ${record.id}', style: a4BoldStyle),
            Text('Attendant:  ${record.attendant}', style: a4BoldStyle),
            Text('Time/Date:  ${record.created}', style: a4BoldStyle),
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total:  ', style: style),
              Text('${record.value}', style: style),
            ]),
          ],
        ),
      ),

      SizedBox(height: 15),
      !record.containsItems
          ? SizedBox.shrink()
          : Table(
              columnWidths: {
                0: FractionColumnWidth(4 / 6),
                1: FractionColumnWidth(1 / 6),
                2: FractionColumnWidth(1 / 6)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: _tableBorder,
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text("Name", style: a4BoldStyle),
                    ),
                    Text("Price (GHS)",
                        textAlign: TextAlign.center, style: a4BoldStyle),
                    Text("QTY", textAlign: TextAlign.center, style: a4BoldStyle)
                  ],
                ),
                ...List.generate(
                  record.recordItems.length,
                  (index) => TableRow(children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child:
                          Text(record.recordItems[index].name, style: a4Style),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(record.recordItems[index].price,
                          textAlign: TextAlign.center, style: a4Style),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(record.recordItems[index].quantity.toString(),
                          textAlign: TextAlign.center, style: a4Style),
                    ),
                  ]),
                )
              ]),
    ];
  }

  List<Widget> tabRecordA4Mockup(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      TabModel tab}) {
    return <Widget>[
      Row(children: [
        Center(
          child: image == null
              ? SizedBox.shrink()
              : Container(
                  width: 100,
                  child: Image(MemoryImage(
                    image,
                  )),
                ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  loggedUser.vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${branch.branchName}, ${branch.location}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Text(header, style: style, textAlign: headerAlign),
                ),
              ],
            ),
          ),
        ),
      ]),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:  ${tab.name}', style: a4BoldStyle),
            Text('Time/Date:  ${tab.created}', style: a4BoldStyle),
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total:  ', style: style),
              Text('${tab.total}', style: style),
            ]),
          ],
        ),
      ),

      SizedBox(height: 15),
      Table(
          columnWidths: {
            0: FractionColumnWidth(3 / 6),
            1: FractionColumnWidth(1 / 6),
            2: FractionColumnWidth(2 / 6)
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Description", style: a4BoldStyle),
                ),
                Text("Price (GHS)",
                    textAlign: TextAlign.center, style: a4BoldStyle),
                Text("Date", textAlign: TextAlign.center, style: a4BoldStyle)
              ],
            ),
            ...List.generate(
              tab.records.length,
              (index) => TableRow(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(tab.records[index].description, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(tab.records[index].value,
                      textAlign: TextAlign.center, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(tab.records[index].modified,
                      textAlign: TextAlign.center, style: a4Style),
                ),
              ]),
            )
          ]),
    ];
  }

  List<Widget> tabsA4MockUp(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      List<TabModel> tabs}) {
    return <Widget>[
      Row(children: [
        Center(
          child: image == null
              ? SizedBox.shrink()
              : Container(
                  width: 100,
                  child: Image(MemoryImage(
                    image,
                  )),
                ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  loggedUser.vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${branch.branchName}, ${branch.location}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Text(header, style: style, textAlign: headerAlign),
                ),
              ],
            ),
          ),
        ),
      ]),

      // Container(
      //   margin: EdgeInsets.symmetric(vertical: 5),
      //   width: double.infinity,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('Name:  ${tab.name}', style: a4BoldStyle),
      //       Text('Sale id:  ${tab.id}', style: a4BoldStyle),
      //       Text('Time/Date:  ${tab.created}', style: a4BoldStyle),
      //     ],
      //   ),
      // ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      // Container(
      //   margin: EdgeInsets.symmetric(vertical: 5),
      //   width: double.infinity,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //         Text('Total:  ', style: style),
      //         Text('${tab.total}', style: style),
      //       ]),
      //     ],
      //   ),
      // ),

      SizedBox(height: 15),
      Table(
          columnWidths: {
            0: FractionColumnWidth(3 / 6),
            1: FractionColumnWidth(2 / 6),
            3: FractionColumnWidth(1 / 6),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Name", style: a4BoldStyle),
                ),
                Text("Total (GHS)",
                    textAlign: TextAlign.center, style: a4BoldStyle),
                Text("Last Record",
                    textAlign: TextAlign.center, style: a4BoldStyle)
              ],
            ),
            ...List.generate(
              tabs.length,
              (index) => TableRow(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(tabs[index].name, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(tabs[index].total,
                      textAlign: TextAlign.center, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(tabs[index].modified,
                      textAlign: TextAlign.center, style: a4Style),
                ),
              ]),
            )
          ]),
    ];
  }

  List<Widget> receiptA4MockUp(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      SaleModel sale}) {
    return <Widget>[
      Row(children: [
        Center(
          child: image == null
              ? SizedBox.shrink()
              : Container(
                  width: 100,
                  child: Image(MemoryImage(
                    image,
                  )),
                ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  loggedUser.vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${branch.branchName}, ${branch.location}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Text(header, style: style, textAlign: headerAlign),
                ),
              ],
            ),
          ),
        ),
      ]),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:  ${sale.name}', style: a4BoldStyle),
            Text('Attendant:  ${sale.attendant}', style: a4BoldStyle),
            Text('Time/Date:  ${sale.orderCreated}', style: a4BoldStyle),
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Amount Payable:  ', style: style),
              Text('${sale.amountPayable}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Amount Received:  ', style: style),
              Text('${sale.amountReceived}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Balance:  ', style: style),
              Text('${sale.balance}', style: style),
            ]),
          ],
        ),
      ),

      SizedBox(height: 15),
      Table(
          columnWidths: {
            0: FractionColumnWidth(3 / 6),
            1: FractionColumnWidth(2 / 6),
            2: FractionColumnWidth(1 / 6)
          },
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Name", style: a4BoldStyle),
                ),
                Text("Price (GHS)",
                    textAlign: TextAlign.center, style: a4BoldStyle),
                Text("QTY", textAlign: TextAlign.center, style: a4BoldStyle)
              ],
            ),
            ...List.generate(
              sale.saleItems.length,
              (index) => TableRow(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(sale.saleItems[index].name, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(sale.saleItems[index].price,
                      textAlign: TextAlign.center, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(sale.saleItems[index].quantity.toString(),
                      textAlign: TextAlign.center, style: a4Style),
                )
              ]),
            )
          ]),
    ];
  }

  List<Widget> proformerA4Mockup(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      OrderModel order}) {
    return <Widget>[
      Row(children: [
        image == null
            ? SizedBox.shrink()
            : Container(
                width: 100,
                height: 100,
                child: Center(
                  child: Image(
                    MemoryImage(
                      image,
                    ),
                  ),
                ),
              ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  loggedUser.vendorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${branch.branchName}, ${branch.location}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Text(header, style: style, textAlign: headerAlign),
                ),
              ],
            ),
          ),
        ),
      ]),

      SizedBox(height: 15),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:  ${order.name}', style: a4BoldStyle),
            Text('Attendant:  ${order.attendant}', style: a4BoldStyle),
            Text('Time/Date:  ${order.created}', style: a4BoldStyle),
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total:  ', style: style),
              Text('${order.total}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Discount:  ', style: style),
              Text('${order.discount}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Amount Payable:  ', style: style),
              Text('${order.amountPayable}', style: style),
            ]),
          ],
        ),
      ),

      SizedBox(height: 15),
      Table(
          columnWidths: {
            0: FractionColumnWidth(4 / 6),
            1: FractionColumnWidth(1 / 6),
            2: FractionColumnWidth(1 / 6)
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Text("Name", textAlign: TextAlign.center, style: a4BoldStyle),
                Text("Price (GHS)",
                    textAlign: TextAlign.center, style: a4BoldStyle),
                Text("QTY", textAlign: TextAlign.center, style: a4BoldStyle)
              ],
            ),
            ...List.generate(
              order.orderItems.length,
              (index) => TableRow(children: [
                Text(order.orderItems[index].name,
                    textAlign: TextAlign.center, style: a4Style),
                Text(order.orderItems[index].price,
                    textAlign: TextAlign.center, style: a4Style),
                Text(order.orderItems[index].quantity.toString(),
                    textAlign: TextAlign.center, style: a4Style)
              ]),
            )
          ]),
    ];
  }

  List<Widget> tabRecord72Mockup(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      TabModel tab}) {
    return <Widget>[
      Column(children: [
        Center(
          child: image == null
              ? SizedBox.shrink()
              : Container(
                  width: 100,
                  height: 100,
                  child: Image(MemoryImage(
                    image,
                  )),
                ),
        ),
        // Expanded(
        //   child:
        Container(
          child: Column(
            children: [
              Text(
                loggedUser.vendorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PdfColors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                "${branch.branchName}, ${branch.location}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PdfColors.black,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Text(header, style: style, textAlign: headerAlign),
              ),
            ],
          ),
        ),
        // ),
      ]),

      SizedBox(height: 15),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:  ${tab.name}', style: a4BoldStyle),
            Text('Time/Date:  ${tab.created}', style: a4BoldStyle),
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total:  ', style: style),
              Text('${tab.total}', style: style),
            ]),
          ],
        ),
      ),

      SizedBox(height: 15),
      // Expanded(
      //   child:
      Table(
          columnWidths: {
            0: FractionColumnWidth(3 / 6),
            1: FractionColumnWidth(1 / 6),
            2: FractionColumnWidth(2 / 6)
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Description", style: a4BoldStyle),
                ),
                Text("Price (GHS)",
                    textAlign: TextAlign.center, style: a4BoldStyle),
                Text("Date", textAlign: TextAlign.center, style: a4BoldStyle)
              ],
            ),
            ...List.generate(
              tab.records.length,
              (index) => TableRow(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(tab.records[index].description, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(tab.records[index].value,
                      textAlign: TextAlign.center, style: a4Style),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(tab.records[index].modified,
                      textAlign: TextAlign.center, style: a4Style),
                ),
              ]),
            )
          ]),
      // )

      // dd

      SizedBox(height: 10),
    ];
  }

  List<Widget> tabs72MockUp(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      List<TabModel> tabs}) {
    return <Widget>[
      Column(children: [
        Center(
          child: image == null
              ? SizedBox.shrink()
              : Container(
                  width: 100,
                  height: 100,
                  child: Image(MemoryImage(
                    image,
                  )),
                ),
        ),
        // Expanded(
        //   child:
        Container(
          child: Column(
            children: [
              Text(
                loggedUser.vendorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PdfColors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                "${branch.branchName}, ${branch.location}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PdfColors.black,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Text(header, style: style, textAlign: headerAlign),
              ),
            ],
          ),
        ),
        // ),
      ]),
      SizedBox(height: 15),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),
      SizedBox(height: 15),
      // Expanded(
      //   child:
      Table(
          columnWidths: {
            0: FractionColumnWidth(2 / 6),
            1: FractionColumnWidth(2 / 6),
            2: FractionColumnWidth(2 / 6)
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: _tableBorder,
          children: [
            TableRow(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Name", style: a4BoldStyle),
                ),
                Text("Total (GHS)",
                    textAlign: TextAlign.center, style: a4BoldStyle),
                Text("Last Record",
                    textAlign: TextAlign.center, style: a4BoldStyle),
              ],
            ),
            ...List.generate(
              tabs.length,
              (index) => TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(tabs[index].name, style: a4Style),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(tabs[index].total,
                        textAlign: TextAlign.center, style: a4Style),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(tabs[index].modified,
                        textAlign: TextAlign.center, style: a4Style),
                  ),
                ],
              ),
            )
          ]),
      // ),
      SizedBox(height: 10),
    ];
  }

  List<Widget> record72Mockup(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      Record record}) {
    // TextStyle style = TextStyle(fontSize: 9);
    TextStyle boldStyle = TextStyle(fontSize: 9, fontWeight: FontWeight.bold);
    return [
      // Logo
      Center(
        child: image == null
            ? SizedBox.shrink()
            : Container(
                width: 100,
                height: 100,
                child: Image(MemoryImage(
                  image,
                )),
              ),
      ),

      // Company Details
      Column(
        children: [
          Text(
            loggedUser.vendorName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 12,
            ),
          ),
          Text(
            "${branch.branchName}, ${branch.location}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: Text(header, style: style, textAlign: headerAlign),
          ),
        ],
      ),

      SizedBox(height: 10),
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:  ${record.description}', style: a4Style),
            Text('Attendant:  ${record.attendant}', style: a4Style),
            Text('Time/Date:  ${record.created}', style: a4Style),
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total:  ', style: style),
              Text('${record.value}', style: style),
            ]),
          ],
        ),
      ),
      // Body
      !record.containsItems
          ? SizedBox.shrink()
          :
          // Expanded(
          //     child:
          Table(
              columnWidths: _tableColumnWidths,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: _tableBorder,
              children: [
                  TableRow(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text("Name", style: boldStyle),
                      ),
                      Text("GHS",
                          textAlign: TextAlign.center, style: boldStyle),
                      Text("QTY", textAlign: TextAlign.center, style: boldStyle)
                    ],
                  ),
                  ...List.generate(
                    record.recordItems.length,
                    (index) => TableRow(children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child:
                            Text(record.recordItems[index].name, style: style),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(record.recordItems[index].price,
                            textAlign: TextAlign.center, style: style),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                            record.recordItems[index].quantity.toString(),
                            textAlign: TextAlign.center,
                            style: style),
                      ),
                    ]),
                  )
                ]),
      // ),
      SizedBox(height: 10),
    ];
  }

  List<Widget> receipt72MockUp(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      SaleModel sale}) {
    return [
      // Logo
      Center(
        child: image == null
            ? SizedBox.shrink()
            : Container(
                width: 100,
                height: 100,
                child: Image(
                  MemoryImage(
                    image,
                  ),
                ),
              ),
      ),
      // Company Details
      Column(
        children: [
          Text(
            loggedUser.vendorName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 12,
            ),
          ),
          Text(
            "${branch.branchName}, ${branch.location}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: Text(header, style: style, textAlign: headerAlign),
          ),
        ],
      ),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:  ${sale.name}', style: style),
            Text('Attendant:  ${sale.attendant}', style: style),
            Text('Time/Date:  ${sale.orderCreated}', style: style),
            if (sale.clientPhone != null && sale.clientPhone.isNotEmpty)
              Text('Phone: ${sale.clientPhone}', style: style)
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Amount Payable:  ', style: boldStyle),
              Text('${sale.amountPayable}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Amount Received:  ', style: boldStyle),
              Text('${sale.amountReceived}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Balance:  ', style: boldStyle),
              Text('${sale.balance}', style: style),
            ]),
          ],
        ),
      ),

      // Body
      // Expanded(
      //   child:
      sale == null
          ? Table(
              border: _tableBorder,
              columnWidths: _tableColumnWidths,
              children: [
                TableRow(
                  children: [
                    Text("Name", textAlign: TextAlign.center, style: boldStyle),
                    Text("GHS", textAlign: TextAlign.center, style: boldStyle),
                    Text("QTY", textAlign: TextAlign.center, style: boldStyle)
                  ],
                ),
              ],
            )
          : Table(
              border: _tableBorder,
              columnWidths: _tableColumnWidths,
              children: [
                  TableRow(
                    children: [
                      Text("Name", textAlign: TextAlign.center, style: style),
                      Text("GHS", textAlign: TextAlign.center, style: style),
                      Text("QTY", textAlign: TextAlign.center, style: style)
                    ],
                  ),
                  ...List.generate(
                    sale.saleItems.length,
                    (index) => TableRow(children: [
                      Text(sale.saleItems[index].name,
                          textAlign: TextAlign.center, style: style),
                      Text(sale.saleItems[index].price,
                          textAlign: TextAlign.center, style: style),
                      Text(sale.saleItems[index].quantity.toString(),
                          textAlign: TextAlign.center, style: style)
                    ]),
                  )
                ]),
      // ),
      SizedBox(height: 10),
    ];
  }

  List<Widget> profomer72MockUp(
      {Uint8List image,
      List footer,
      String header,
      TextAlign headerAlign,
      OrderModel order}) {
    return [
      // Company Details
      Center(
        child: image == null
            ? SizedBox.shrink()
            : Container(
                width: 100,
                height: 100,
                child: Image(
                  MemoryImage(
                    image,
                  ),
                ),
              ),
      ),

      Column(
        children: [
          Text(
            loggedUser.vendorName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 12,
            ),
          ),
          Text(
            "${branch.branchName}, ${branch.location}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: Text(header, style: style, textAlign: headerAlign),
          ),
        ],
      ),

      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:  ${order.name}', style: style),
            Text('Attendant:  ${order.attendant}', style: style),
            Text('Time/Date:  ${order.modified}', style: style),
            if (order.clientPhone != null && order.clientPhone.isNotEmpty)
              Text('Phone: ${order.clientPhone}', style: style)
          ],
        ),
      ),
      Divider(
        color: PdfColors.grey,
        height: 1,
        thickness: 1,
      ),

      // Amounts
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total:  ', style: boldStyle),
              Text('${order.total}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Discount:  ', style: boldStyle),
              Text('${order.discount}', style: style),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Amount Payable:  ', style: boldStyle),
              Text('${order.amountPayable}', style: style),
            ]),
          ],
        ),
      ),

      // Body
      order == null
          ? Table(
              border: _tableBorder,
              columnWidths: _tableColumnWidths,
              children: [
                TableRow(
                  children: [
                    Text("Name", textAlign: TextAlign.center, style: boldStyle),
                    Text("GHS", textAlign: TextAlign.center, style: boldStyle),
                    Text("QTY", textAlign: TextAlign.center, style: boldStyle)
                  ],
                ),
              ],
            )
          : Table(
              border: _tableBorder,
              columnWidths: _tableColumnWidths,
              children: [
                  TableRow(
                    children: [
                      Text("Name", textAlign: TextAlign.center, style: style),
                      Text("GHS", textAlign: TextAlign.center, style: style),
                      Text("QTY", textAlign: TextAlign.center, style: style)
                    ],
                  ),
                  ...List.generate(
                    order.orderItems.length,
                    (index) => TableRow(children: [
                      Text(order.orderItems[index].name,
                          textAlign: TextAlign.center, style: style),
                      Text(order.orderItems[index].price,
                          textAlign: TextAlign.center, style: style),
                      Text(order.orderItems[index].quantity.toString(),
                          textAlign: TextAlign.center, style: style)
                    ]),
                  )
                ]),

      SizedBox(height: 10),
    ];
  }
}
