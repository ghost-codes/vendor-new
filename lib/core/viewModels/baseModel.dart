import 'package:flutter/cupertino.dart';
import 'package:vendoorr/core/enums.dart';

class BaseModel extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;

  ViewState get state => _viewState;

  setState(ViewState viewState) {
    _viewState = viewState;

    notifyListeners();
  }
}
