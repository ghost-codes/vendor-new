import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DragDisableSingleChild extends StatelessWidget {
  final Widget child;
  final ScrollController _controller = ScrollController();

  DragDisableSingleChild({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isPlatform) {
        return isPlatform.isDesktop
            ? SingleChildScrollView(child: child)
            : Listener(
                onPointerSignal: (ps) {
                  if (ps is PointerScrollEvent) {
                    final double newOffset =
                        _controller.offset + ps.scrollDelta.dy;
                    if (ps.scrollDelta.dy.isNegative) {
                      _controller.jumpTo(math.max(0, newOffset));
                    } else {
                      _controller.jumpTo(math.min(
                          _controller.position.maxScrollExtent, newOffset));
                    }
                  }
                },
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  child: child,
                ),
              );
      },
    );
  }
}

dragDisable(ps, ScrollController _controller) {
  if (ps is PointerScrollEvent) {
    final double newOffset = _controller.offset + ps.scrollDelta.dy;
    if (ps.scrollDelta.dy.isNegative) {
      _controller.jumpTo(math.max(0, newOffset));
    } else {
      _controller
          .jumpTo(math.min(_controller.position.maxScrollExtent, newOffset));
    }
  }
}
