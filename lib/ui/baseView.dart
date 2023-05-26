import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendoorr/core/locator.dart';
import 'package:vendoorr/core/viewModels/baseModel.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T model) onModelReady;
  BaseView({this.builder, this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = sl<T>();
  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      builder: (context, child) {
        return Consumer<T>(builder: widget.builder);
      },
    );
  }
}
