import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  Layout({
    Key key,
    this.child,
    this.scrollController,
  }) : super(key: key);

  final Widget child;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return constraints.maxWidth < 1300
            ? Scrollbar(
                isAlwaysShown: constraints.maxWidth < 1300,
                controller: scrollController,
                interactive: true,
                child: SingleChildScrollView(
                    controller: scrollController,
                    physics: constraints.maxWidth < 1300
                        ? ScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: child),
              )
            : child;
      },
    );
  }
}
