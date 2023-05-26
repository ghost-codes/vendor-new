import 'package:flutter/material.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class DateTimeResponse {
  DateTime fromDate;
  DateTime toDate;
  DateTime fromTime;
  DateTime toTime;

  DateTimeResponse({
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
  });
}

class SelectDateRangeViewModel extends BaseModel {
  DateTime fromDate;
  DateTime toDate;
  DateTime fromTime;
  DateTime toTime;

  init({
    DateTime fromD,
    DateTime toD,
    DateTime fromT,
    DateTime toT,
  }) {
    fromDate = fromD;
    toDate = toD;
    fromTime = fromT;
    toTime = toT;
    notifyListeners();
  }

  setDate(DateTime from, DateTime to) {
    fromDate = from;
    toDate = to;
    notifyListeners();
  }

  void setFromTime(DateTime x) {
    fromTime = x;
    print(x);
    print(fromTime);
    notifyListeners();
  }

  setToTime(DateTime x) {
    toTime = x;
    notifyListeners();
  }

  submit(BuildContext context) {
    print(fromTime);
    print(toTime);

    final date = DateTimeResponse(
      fromDate: fromDate,
      toDate: toDate,
      toTime: toTime,
      fromTime: fromTime,
    );

    Navigator.pop(context, date);
  }
}
