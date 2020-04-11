import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final int min;
  final int max;
  final ui.Image image;

  const CustomSliderThumb(
      {this.thumbRadius, this.thumbHeight, this.min, this.max, this.image});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbHeight * 1.2, height: thumbHeight * .6),
      Radius.circular(thumbRadius * .4),
    );

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: thumbHeight * .3,
            fontWeight: FontWeight.w700,
            color: sliderTheme.thumbColor,
            height: 0.9),
        text: '${getValue(value)}');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2.0), center.dy - (tp.height / 2.0));

//    canvas.drawRRect(rRect, paint);
    if (image != null) {
      canvas.drawImage(
          image,
          new Offset(center.dx - image.width / 2, center.dy - image.height / 2),
          new Paint());
    }

//    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return ((max) * (value)).round().toString();
  }
}
