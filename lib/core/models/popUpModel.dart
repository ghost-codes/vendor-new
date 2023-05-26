import 'package:flutter/cupertino.dart';

class PopUp {
  final String message;
  final bool action;
  final PopUpType type;

  PopUp({this.message, this.action,  this.type});
}

enum PopUpType { success, error }
