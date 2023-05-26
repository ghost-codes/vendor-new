import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vendoorr/core/util/appColors.dart';

class RadialChart extends StatefulWidget {
  const RadialChart({
    Key key,
    @required this.width,
    @required this.height,
    this.percentage,
  }) : super(key: key);
  final double width;
  final double height;
  final double percentage;

  @override
  _RadialChartState createState() => _RadialChartState();
}

class _RadialChartState extends State<RadialChart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Center(
            child: Text(
              "${widget.percentage * 100}%",
              style: TextStyle(
                color: LocalColors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: widget.width - 00,
            height: widget.height - 0,
            child: CustomPaint(
              painter: RadialPainter(widget.percentage),
            ),
          ),
        ],
      ),
    );
  }
}

class RadialPainter extends CustomPainter {
  final double percentage;

  RadialPainter(this.percentage);
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    Paint outline = Paint()
      ..color = LocalColors.offWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    Paint mainOutline = Paint()
      ..color = LocalColors.secodaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, outline);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        2 * percentage * pi, false, mainOutline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    // throw UnimplementedError();
  }
}
