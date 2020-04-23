import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final int min;
  final int max;
  final ui.Image image;

  const CustomSliderThumb({this.thumbRadius, this.thumbHeight, this.min, this.max, this.image});

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
    if (image != null) {
      canvas.drawImage(image, new Offset(center.dx - image.width / 2, center.dy - image.height / 2), new Paint());
    }
  }

  String getValue(double value) {
    return ((max) * (value)).round().toString();
  }
}
