import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'hex_color.dart';

String TAG = "WidgetIce";

class WidgetIce extends StatefulWidget {
  double currentTime;
  double totalTime;

  WidgetIce(this.currentTime, this.totalTime) {
    if (currentTime > totalTime || totalTime == 0) {
      currentTime = totalTime = 1;
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
          painter: IceBackground(widget.currentTime, widget.totalTime),
        ));
  }
}

class IceBackground extends CustomPainter {
  double currentTime;
  double totalTime;

  IceBackground(this.currentTime, this.totalTime);

  double defaultMarign = 5;
  double RTamLetf; // khoảng các từ tâm hình tròn trái đến cái khung
  double RTamRight; // khoảng các từ tâm hình tròn phải đến cái khung

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

    double distance = 20; // khoang cach tu tam 2 hinh trong den cai bang
    // kích thước hình chữ nhật chứa cái băng. đã bỏ khoảng margin
    double iceWith = size.width - defaultMarign * 2;
    double iceHeight = size.height - defaultMarign * 2;

    // ve bang
    double rMin = iceHeight / 4; // ban kinh duong tron nho nhat
    double rMax = iceWith / 2; // ban kinh duong tron lon nhat

    double defaulPosBottom = size.height - defaultMarign;
    double sizeLeft = rMin + (rMax - rMin) * (1 - currentTime / totalTime); // ban kinh duong torn bne trai
    double sizeRight =
        rMin + (rMax - rMin) * (1 - (totalTime - currentTime) / totalTime); // ban kinh duong tron ben phai

    Paint paint2 = new Paint()..color = HexColor("#6B4E39");

    double tmp = sqrt(iceHeight * iceHeight / 4 + distance * distance) - distance;

    if (sizeLeft <= tmp) {
      Path path1 = new Path()
        ..moveTo(defaultMarign, size.height / 2 - sqrt(pow(distance + sizeLeft, 2) - pow(distance, 2)))
        ..quadraticBezierTo(defaultMarign + sizeLeft, size.height / 2, defaultMarign,
            size.height / 2 + sqrt(pow(distance + sizeLeft, 2) - pow(distance, 2)))
        ..lineTo(defaultMarign, size.height / 2 - sqrt(pow(distance + sizeLeft, 2) - pow(distance, 2)));
      canvas.drawPath(path1, paint2);
    } else {
      Path path1 = new Path()
        ..moveTo(defaultMarign, defaultMarign)
        ..lineTo(defaultMarign + sqrt(pow(distance + sizeLeft, 2) - pow(iceHeight / 2, 2)) - distance, defaultMarign)
        ..quadraticBezierTo(
            defaultMarign + sizeLeft,
            size.height / 2,
            defaultMarign + sqrt(pow(distance + sizeLeft, 2) - pow(iceHeight / 2, 2)) - distance,
            size.height - defaultMarign)
        ..lineTo(defaultMarign, size.height - defaultMarign)
        ..lineTo(defaultMarign, defaultMarign);
      canvas.drawPath(path1, paint2);
    }

    if (sizeRight <= tmp) {
      Path path2 = new Path()
        ..moveTo(size.width - defaultMarign, size.height / 2 - sqrt(pow(distance + sizeRight, 2) - pow(distance, 2)))
        ..quadraticBezierTo(size.width - defaultMarign - sizeRight, size.height / 2, size.width - defaultMarign,
            size.height / 2 + sqrt(pow(distance + sizeRight, 2) - pow(distance, 2)))
        ..lineTo(size.width - defaultMarign, size.height / 2 - sqrt(pow(distance + sizeRight, 2) - pow(distance, 2)));
      canvas.drawPath(path2, paint2);
    } else {
      Path path2 = new Path()
        ..moveTo(size.width - defaultMarign, defaultMarign)
        ..lineTo(size.width - defaultMarign - sqrt(pow(distance + sizeRight, 2) - pow(iceHeight / 2, 2)) + distance,
            defaultMarign)
        ..quadraticBezierTo(
            size.width - defaultMarign - sizeRight,
            size.height / 2,
            size.width - defaultMarign - sqrt(pow(distance + sizeRight, 2) - pow(iceHeight / 2, 2)) + distance,
            size.height - defaultMarign)
        ..lineTo(size.width - defaultMarign, size.height - defaultMarign)
        ..lineTo(size.width - defaultMarign, defaultMarign);
      canvas.drawPath(path2, paint2);
    }

//    if (sizeLeft < iceHeight / 2) {
//      var pathLeft1 = Path()
//        ..moveTo(defaultMarign, size.height / 2 - sizeLeft)
//        ..quadraticBezierTo(defaultMarign + sizeLeft, size.height / 2, defaultMarign, size.height / 2 + sizeLeft)
//        ..lineTo(defaultMarign, size.height / 2 - sizeLeft);
//      canvas.drawPath(pathLeft1, paint2);
//    } else {
//      var pathLeft2 = Path()
//        ..moveTo(defaultMarign, defaultMarign)
//        ..lineTo(defaultMarign + sqrt(sizeLeft * sizeLeft - iceHeight * iceHeight / 4) - 2, defaultMarign)
//        ..quadraticBezierTo(defaultMarign + sizeLeft, size.height / 2,
//            defaultMarign + sqrt(sizeLeft * sizeLeft - iceHeight * iceHeight / 4) - 2, iceHeight + defaultMarign)
//        ..lineTo(defaultMarign, iceHeight + defaultMarign)
//        ..lineTo(defaultMarign, defaultMarign);
//      canvas.drawPath(pathLeft2, paint2);
//    }
//
//    if (sizeRight < iceHeight / 2) {
//      var pathRight1 = Path()
//        ..moveTo(size.width - defaultMarign, size.height / 2 - sizeRight)
//        ..quadraticBezierTo(size.width - defaultMarign - sizeRight, size.height / 2, size.width - defaultMarign,
//            size.height / 2 + sizeRight)
//        ..lineTo(size.width - defaultMarign, size.height / 2 - sizeRight);
//      canvas.drawPath(pathRight1, paint2);
//    } else {
//      var pathRight = Path()
//        ..moveTo(size.width - defaultMarign, defaultMarign)
//        ..lineTo(
//            size.width - defaultMarign - sqrt(sizeRight * sizeRight - iceHeight * iceHeight / 4) + 2, defaultMarign)
//        ..quadraticBezierTo(
//            size.width - defaultMarign - sizeRight,
//            size.height / 2,
//            size.width - defaultMarign - sqrt(sizeRight * sizeRight - iceHeight * iceHeight / 4) + 2,
//            iceHeight + defaultMarign)
//        ..lineTo(size.width - defaultMarign, iceHeight + defaultMarign)
//        ..lineTo(size.width - defaultMarign, defaultMarign);
//      canvas.drawPath(pathRight, paint2);
//    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
