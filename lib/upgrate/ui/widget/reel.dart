import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ReelPainter extends CustomPainter {
  Paint p;
  double spacing, padding;
  int percent = 40;
  final min = 0, max = 100;

  ReelPainter(double spacing, double padding) {
    this.spacing = spacing;
    this.padding = padding;
    p = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellow
      ..isAntiAlias = true;
  }

  setPercent(int percent) {
    if (percent > min && percent < max) {
      this.percent = percent;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width > 1.0 && size.height > 1.0) {
      SizeUtil.size = size;

      canvas.clipRect(Rect.fromLTRB(
        0 + padding,
        0 + padding,
        size.width - padding,
        size.height - padding,
      ));

      final sizeReelMin = 60.0;
      final sizeReelMax = 120.0;
      final fullMove = sizeReelMax - sizeReelMin;

      final yOffset = size.height / 2;
      final xReelCenter = 50;

      final x1Offset = 0.0 + xReelCenter;
      final scaleByPercent1 = fullMove * (percent / 100);
      canvas.drawCircle(
        Offset(x1Offset, yOffset),
        SizeUtil.getAxisBoth(sizeReelMin + scaleByPercent1),
        p,
      );

      final x2Offset = size.width - xReelCenter;
      final scaleByPercent2 = fullMove * ((max - percent) / 100);
      canvas.drawCircle(
        Offset(x2Offset, yOffset),
        SizeUtil.getAxisBoth(sizeReelMin + scaleByPercent2),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SizeUtil {
  static const _DESIGN_WIDTH = 360;
  static const _DESIGN_HEIGHT = 120;

  //logic size in device
  static Size _logicSize;

  //device pixel radio.

  static get width {
    return _logicSize.width;
  }

  static get height {
    return _logicSize.height;
  }

  static set size(size) {
    _logicSize = size;
  }

  //@param w is the design w;
  static double getAxisX(double w) {
    return (w * width) / _DESIGN_WIDTH;
  }

// the y direction
  static double getAxisY(double h) {
    return (h * height) / _DESIGN_HEIGHT;
  }

  // diagonal direction value with design size s.
  static double getAxisBoth(double s) {
    return s *
        sqrt((width * width + height * height) /
            (_DESIGN_WIDTH * _DESIGN_WIDTH + _DESIGN_HEIGHT * _DESIGN_HEIGHT));
  }
}
