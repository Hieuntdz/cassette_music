import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HexColor.dart';

final String TAG = "MyCircleSlider";

class MyCircleSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyCircleSliderState();
  }
}

final double topCircle1 = 5;
final double topCircle2 = 10;

class MyCircleSliderState extends State<MyCircleSlider> {
  GlobalKey keyVolume = new GlobalKey();
  double dragX = 0; // gia tri cuoi cung khi keo nut tron phia X
  double dragY = 0; // gia tri cuoi cung khi keo nut tron phia Y

  double iconSize = 15;
  double sizeWidth = 0;
  double sizeHeight = 0;
  double defalutTop = 15;
  double defaultLeft = 0;
  double minPosLeft = 0;
  double maxPosLeft = 0;
  double minPosTop = 0;
  double maxPosTop = 0;

//STATE
  double posLeft = 0; // vitri cua icon volume
  double posTop = 0;
  bool icCircleBlueVisibly = false;
  @override
  void initState() {
    super.initState();
    print(TAG + "initState");
    WidgetsBinding.instance.addPostFrameCallback((_) => getVolumeSizes());
  }

  getVolumeSizes() {
    Future.delayed(const Duration(milliseconds: 700), () {
      final RenderBox renderBoxRed =
          keyVolume.currentContext.findRenderObject();
      final sizeRed = renderBoxRed.size;
      sizeWidth = renderBoxRed.size.width;
      defaultLeft = sizeWidth / 2 - iconSize / 2;
      sizeHeight = renderBoxRed.size.height;

      minPosLeft = sizeWidth / 2 - (sizeHeight - defalutTop);
      maxPosLeft = sizeWidth / 2 + (sizeHeight - defalutTop);
      minPosTop = defalutTop;
      maxPosTop = sizeHeight;
      print(TAG + "SIZE of KEY1: $sizeRed");
      icCircleBlueVisibly = true;
      setState(() {
        posLeft = sizeWidth / 2 - iconSize / 2;
        posTop = defalutTop;
        icCircleBlueVisibly = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(TAG + " build");
//    buildTimes = buildTimes + 1;
//    if (buildTimes == 2) {
//      getVolumeSizes();
//    }
    return Container(
        key: keyVolume,
        width: double.infinity,
        height: double.infinity,
        child: new CustomPaint(
          painter: MyCustomPainter(),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: posLeft,
                top: posTop,
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails d) {
                    dragX = 0;
                    dragY = 0;
                    setState(() {
                      posLeft = defaultLeft;
                      posTop = defalutTop;
                    });
                    print("onHorizontalDragEnd");
                  },
                  onHorizontalDragDown: (DragDownDetails d) {
                    print("onHorizontalDragDown");
                  },
                  onHorizontalDragCancel: () {
                    print("onHorizontalDragCancel");
                  },
                  onHorizontalDragUpdate: (DragUpdateDetails d) {
                    print("onHorizontalDragUpdate");
                    dragX = dragX + d.delta.dx;
                    dragY = dragY + d.delta.dy;
                    handleDragVolume(dragX, dragY);
                  },
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    child: Visibility(
                      visible: icCircleBlueVisibly,
                      child: Image.asset("assets/images/ic_circle_blue.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void handleDragVolume(double dx, double dy) {
    double offsetX = dx.abs();
    double radius = sizeHeight - defalutTop - iconSize / 2;
    if (offsetX > radius) {
      offsetX = radius;
    }

    double anpha = asin(offsetX / radius);
    double offsetY = radius - cos(anpha) * radius;
    if (dx < 0) {
      setState(() {
        posLeft = defaultLeft - offsetX;
        posTop = defalutTop + offsetY;
      });
    } else {
      setState(() {
        posLeft = defaultLeft + offsetX;
        posTop = defalutTop + offsetY;
      });
    }
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    Paint paint1 = new Paint()
      ..color = HexColor("#202020")
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Paint paint2 = new Paint()
      ..color = HexColor("#313131")
      ..style = PaintingStyle.fill;

    double arcAngle = 2 * pi * (50 / 100);

    canvas.drawArc(
        new Rect.fromCircle(
            center: new Offset(size.width / 2, size.height),
            radius: size.height - topCircle1),
        -pi,
        arcAngle,
        false,
        paint1);

    canvas.drawArc(
        new Rect.fromCircle(
            center: new Offset(size.width / 2, size.height),
            radius: size.height - topCircle2),
        -pi,
        arcAngle,
        false,
        paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
