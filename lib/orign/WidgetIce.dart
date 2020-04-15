import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HexColor.dart';

String TAG = "WidgetIce";

class WidgetIce extends StatefulWidget {
  int currentAudio;
  int totalAudio;

  WidgetIce(this.currentAudio, this.totalAudio) {
    if (currentAudio > totalAudio || totalAudio == 0) {
      currentAudio = totalAudio = 1;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return WidgetIceState();
  }
}

class WidgetIceState extends State<WidgetIce> {
  WidgetIceState();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: HexColor("#1F1F1F"),
        child: CustomPaint(
          painter: IceBackground(widget.currentAudio, widget.totalAudio),
        ));
  }
}

class IceBackground extends CustomPainter {
  int currentAudio;
  int totalAudio;

  IceBackground(this.currentAudio, this.totalAudio);

  double defaultMarign = 5;
  double rMin; // ban kinh duong tron nho nhat
  double rMax; // ban kinh duong tron lon nhat

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = new Paint()..color = HexColor("#6D6D6D");
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(defaultMarign, defaultMarign);
    path.lineTo(size.width - defaultMarign, defaultMarign);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint1);

    // ve bang
    rMin = (size.height - defaultMarign * 2) / 2;
    rMax = (size.width - defaultMarign * 2) / 2;
    double defaulPosBottom = size.height - defaultMarign;
    double sizeLeft = rMin + (rMax - rMin) * (1 - currentAudio / totalAudio); // ban kinh duong torn bne trai
    double sizeRight =
        rMin + (rMax - rMin) * (1 - (totalAudio - currentAudio) / totalAudio); // ban kinh duong tron ben phai

    // kích thước hình chữ nhật chứa cái băng. đã bỏ khoảng margin
    double iceWith = size.width - defaultMarign * 2;
    double iceHeight = size.height - defaultMarign * 2;

    Paint paint2 = new Paint()..color = HexColor("#6B4E39");
    double leftPoint1, leftPoint2, leftPoint3, leftPoint4, leftPoint15;
    if (sizeLeft < iceHeight / 2) {
      var pathLeft1 = Path()
        ..moveTo(defaultMarign, iceHeight - sizeLeft)
        ..quadraticBezierTo(defaultMarign + sizeLeft, size.height / 2, defaultMarign, size.height / 2 + sizeRight)
        ..lineTo(defaultMarign, iceHeight - sizeLeft);
      canvas.drawPath(pathLeft1, paint2);
    } else {
      var pathLeft2 = Path()
        ..moveTo(defaultMarign, defaultMarign)
        ..lineTo(defaultMarign + sqrt(sizeLeft * sizeLeft - iceHeight * iceHeight / 4), defaultMarign)
        ..quadraticBezierTo(defaultMarign + sizeLeft, size.height / 2,
            defaultMarign + sqrt(sizeLeft * sizeLeft - iceHeight * iceHeight / 4), iceHeight + defaultMarign)
        ..lineTo(defaultMarign, iceHeight + defaultMarign)
        ..lineTo(defaultMarign, defaultMarign);
      canvas.drawPath(pathLeft2, paint2);
    }

    if (sizeRight < iceHeight / 2) {
      var pathRight1 = Path()
        ..moveTo(size.width - defaultMarign, size.height / 2 - sizeRight)
        ..quadraticBezierTo(size.width - defaultMarign - sizeRight, size.height / 2, size.width - defaultMarign,
            size.height / 2 + sizeRight)
        ..lineTo(size.width - defaultMarign, size.height / 2 - sizeRight);
      canvas.drawPath(pathRight1, paint2);
    } else {
      var pathRight = Path()
        ..moveTo(size.width - defaultMarign, defaultMarign)
        ..lineTo(size.width - defaultMarign - sqrt(sizeRight * sizeRight - iceHeight * iceHeight / 4), defaultMarign)
        ..quadraticBezierTo(
            defaultMarign + sizeLeft,
            size.height / 2,
            size.width - defaultMarign - sqrt(sizeRight * sizeRight - iceHeight * iceHeight / 4),
            iceHeight + defaultMarign)
        ..lineTo(size.width - defaultMarign, iceHeight + defaultMarign)
        ..lineTo(defaultMarign, defaultMarign);
      canvas.drawPath(pathRight, paint2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
