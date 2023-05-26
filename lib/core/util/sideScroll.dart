import 'package:flutter/material.dart';

class ResponsiveSideScroll extends StatelessWidget {
  final Widget child;
  ResponsiveSideScroll({Key key, this.child}) : super(key: key);

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return constraints.maxWidth < 1300
            ? Scrollbar(
                isAlwaysShown: constraints.maxWidth < 1300,
                controller: _scrollController,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: constraints.maxWidth < 1300
                      ? ScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1400),
                    child: child,
                  ),
                ),
              )
            : Container(
                constraints: BoxConstraints(maxWidth: 1400),
                child: child,
              );
      },
    );
  }
}
