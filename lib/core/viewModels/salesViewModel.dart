import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/saleModel.dart';
import 'package:vendoorr/core/models/salesQueryResponse.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class SalesViewModel extends BaseModel {
  Api _api = sl<Api>();
  List<SaleModel> sales = [];
  String nextSalesPage = null;
  ScrollController scrollController;
  bool isSaleDetail = false;
  bool isDeleting = false;
  SaleModel selectedSale;
  bool isLoadMore = false;

  String branchId;

  SalesViewModel() {
    scrollController = ScrollController()..addListener(_loadMoreSales);
  }

  void _loadMoreSales() {
    if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels &&
        nextSalesPage != null &&
        state != ViewState.Busy) getSales(url: nextSalesPage);
  }

  getSales({String url}) async {
    setState(ViewState.Busy);
    isLoadMore = url != null;
    SalesQueryResponse result = await _api.branchSalseApi(branchId, url: url);
    if (isLoadMore)
      sales = [...sales, ...result.results];
    else
      sales = result.results;
    nextSalesPage = result.next;
    isLoadMore = false;
    setState(ViewState.Idle);
  }

  setIsSaleDetail(bool x, {SaleModel model}) {
    isSaleDetail = x;
    if (x) {
      selectedSale = model;
    }
    notifyListeners();
  }

  dispose() {
    List<SaleModel> sales = [];
  }
}
