import 'dart:convert';

import 'package:vendoorr/core/enums.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/models/activityModel.dart';
import 'package:vendoorr/core/service/api.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class ActivitiesViewModel extends BaseModel {
  String nextUrl;
  String previousUrl;
  List activities = [];
  bool isBottom = true;
  bool isLoadingMore = false;

  Api _api = sl<Api>();

  getActivities(String branch_id) async {
    setState(ViewState.Busy);
    Map res = await _api.branchActivityApi(branch_id);
    nextUrl = res["next"];
    previousUrl = res["previous"];
    print(res["results"]);
    activities = res['results']
        .map((value) => ActivityDataModel.fromJson(value))
        .toList();

    setState(ViewState.Idle);
  }

  loadMore() async {
    isLoadingMore = true;
    Map res = await _api.branchLoadMoreAcitivityApi(nextUrl);
    nextUrl = res["next"];
    previousUrl = res["previous"];
    activities = [
      ...activities,
      ...(res['results']
          .map((value) => ActivityDataModel.fromJson(value))
          .toList())
    ];

    isLoadingMore = false;
    isBottom = true;
    notifyListeners();
  }
}
