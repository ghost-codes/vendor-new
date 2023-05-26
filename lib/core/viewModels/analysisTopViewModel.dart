import 'package:intl/intl.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/analysisTransactionModel.dart';
import 'package:vendoorr/core/models/productSummaryData.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

enum AnalysisTypes { top, transactions, kpi, productSummary }

class AnalysisViewModel extends BaseModel {
  AnalysisTypes selectedAnalysisType = AnalysisTypes.top;
  bool isTransactionLoading = false;
  bool isProductSummaryLoading = false;
  AnalysisTransactionModel transactions;

  List<ProductSummaryData> productSummarydisplayData;
  List<ProductSummaryData> productSummaryData;

  Api _api = sl<Api>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  DateTime fromTime;
  DateTime toTime;

  String branchId;

  DateFormat format = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("HH:mm");

  initTransactionView(String branchId) async {
    isTransactionLoading = true;
    notifyListeners();

    fromDate = DateTime.now();
    toDate = DateTime.now();
    fromTime = DateTime(
      fromDate.year,
    );
    toTime = DateTime(fromDate.year, 1, 1, 23, 59, 59, 0, 0);
    this.branchId = branchId;

    var res = await _api.getTimelinedTransactions(data: {
      "fromDate": format.format(fromDate),
      "fromTime": timeFormat.format(fromTime),
      "toDate": format.format(toDate),
      "toTime": timeFormat.format(toTime),
    }, branch_id: branchId);

    if (res != null) transactions = res;
    print(transactions.credits.quantity);

    isTransactionLoading = false;
    notifyListeners();
  }

  initProductSummary(String branchId) async {
    isProductSummaryLoading = true;
    notifyListeners();

    fromDate = DateTime.now();
    toDate = DateTime.now();
    fromTime = DateTime(
      fromDate.year,
    );
    toTime = DateTime(fromDate.year, 1, 1, 23, 59, 59, 0, 0);
    this.branchId = branchId;

    var res = await _api.getTimelinedProductSummary(data: {
      "fromDate": format.format(fromDate),
      "fromTime": timeFormat.format(fromTime),
      "toDate": format.format(toDate),
      "toTime": timeFormat.format(toTime),
    }, branch_id: branchId);

    if (res != null) productSummaryData = res;

    productSummarydisplayData = productSummaryData;

    isProductSummaryLoading = false;
    notifyListeners();
  }

  String headerDate() {
    var formate = DateFormat.yMEd();
    var formatedDay = DateFormat.EEEE();
    var formatTime = DateFormat.Hm();
    final diff = toDate.difference(fromDate);

    if (diff.inDays < 1)
      return "${formatedDay.format(fromDate)} ${formatTime.format(fromTime)} - ${formatTime.format(toTime)}";
    return "${formate.format(fromDate)} to ${formate.format(toDate)}";
  }

  setTypeOfAnalysis(AnalysisTypes type) {
    selectedAnalysisType = type;
    notifyListeners();
  }

  setRangeTransaction(
      {DateTime fromD, DateTime toD, DateTime fromT, DateTime toT}) async {
    isTransactionLoading = true;
    notifyListeners();
    fromDate = fromD;
    toDate = toD;
    fromTime = fromT;
    toTime = toT;

    var res = await _api.getTimelinedTransactions(data: {
      "fromDate": format.format(fromDate),
      "fromTime": timeFormat.format(fromTime),
      "toDate": format.format(toDate),
      "toTime": timeFormat.format(toTime),
    }, branch_id: branchId);

    if (res != null) transactions = res;

    isTransactionLoading = false;

    notifyListeners();
  }

  setRangeProductSummary(
      {DateTime fromD, DateTime toD, DateTime fromT, DateTime toT}) async {
    isProductSummaryLoading = true;
    notifyListeners();
    fromDate = fromD;
    toDate = toD;
    fromTime = fromT;
    toTime = toT;

    var res = await _api.getTimelinedProductSummary(data: {
      "fromDate": format.format(fromDate),
      "fromTime": timeFormat.format(fromTime),
      "toDate": format.format(toDate),
      "toTime": timeFormat.format(toTime),
    }, branch_id: branchId);

    if (res != null) productSummaryData = res;

    productSummarydisplayData = productSummaryData;

    isProductSummaryLoading = false;

    notifyListeners();
  }

  onProductSummarySearch(String value) {
    var regExp = RegExp("\w*$value\w*", caseSensitive: false);
    if (value == "") {
      productSummarydisplayData = productSummaryData;
    } else {
      productSummarydisplayData = productSummaryData.where((element) {
        return regExp.hasMatch(element.name);
      }).toList();
    }

    notifyListeners();
  }

  onProductSummarySearchCancel() {
    productSummarydisplayData = productSummaryData;
    notifyListeners();
  }
}
