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

  int defaulRadius = 15; // defaul độ cong là 7
  double defaulMaxWidth; // do dai lon nha của 1 ben bang
  double defaulMinWidth = 20; // do dai lon nha của 1 ben bang

  double defaultMarign = 5;

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
    defaulMaxWidth = size.width / 2 - defaultMarign * 2;
    double sizeLeft = defaulMaxWidth - defaulMaxWidth * currentAudio / totalAudio;
    sizeLeft = sizeLeft < defaulMinWidth ? defaulMinWidth : sizeLeft;
    double sizeRight = defaulMaxWidth - defaulMaxWidth * (totalAudio - currentAudio) / totalAudio;
    sizeRight = sizeRight < defaulMinWidth ? defaulMinWidth : sizeRight;

    Paint paint2 = new Paint()..color = HexColor("#6B4E39");

    double defaulPosBottom = size.height - defaultMarign;
    print(TAG + "defaulPosBottom $defaulPosBottom");
    print(TAG + "SIZE left $sizeLeft");
    var pathLeft = Path();
    pathLeft.moveTo(defaultMarign, defaultMarign);
    pathLeft.lineTo(defaultMarign, defaulPosBottom);
    pathLeft.lineTo(defaultMarign + sizeLeft - defaulRadius, defaulPosBottom);
    pathLeft.quadraticBezierTo(
        defaultMarign + sizeLeft, size.height / 2, defaultMarign + sizeLeft - defaulRadius, defaultMarign);
    pathLeft.lineTo(defaultMarign, defaultMarign);
    canvas.drawPath(pathLeft, paint2);

    var pathRight = Path()
      ..moveTo(size.width - defaultMarign, defaultMarign)
      ..lineTo(size.width - defaultMarign, defaulPosBottom)
      ..lineTo(size.width - defaultMarign - sizeRight + defaulRadius, defaulPosBottom)
      ..quadraticBezierTo(size.width - defaultMarign - sizeRight, size.height / 2,
          size.width - defaultMarign - sizeRight + defaulRadius, defaultMarign)
      ..lineTo(size.width - defaultMarign, defaultMarign);
    canvas.drawPath(pathRight, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
