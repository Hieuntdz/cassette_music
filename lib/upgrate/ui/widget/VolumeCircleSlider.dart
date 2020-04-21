import 'dart:math';

import 'package:cassettemusic/orign/HexColor.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String TAG = "MyCircleSlider";

class VolumeCircleSlider extends StatefulWidget {
  ControlBloc bloc;

  VolumeCircleSlider(ControlBloc controlBloc) {
    this.bloc = controlBloc;
  }

  @override
  State<StatefulWidget> createState() {
    return VolumeCircleSliderState();
  }
}

final double topCircle1 = 5;
final double topCircle2 = 10;

class VolumeCircleSliderState extends State<VolumeCircleSlider> {
  GlobalKey keyVolume = new GlobalKey();
  final int MIN_VOLUME = 10;
  final int MAX_VOLUME = 100;

  double dragX = 0; // gia tri cuoi cung khi keo nut tron phia X
  double dragY = 0; // gia tri cuoi cung khi keo nut tron phia Y

  double iconSize = 15;
  double sizeWidth = 0;
  double sizeHeight = 0;
  double defalutTop = 20;
  double defaultLeft = 0;
  double minPosLeft = 0;
  double maxPosLeft = 0;
  double minPosTop = 0;
  double maxPosTop = 0;

//STATE
  double posLeft = 0; // vitri cua icon volume
  double posTop = 0;
  bool icCircleBlueVisibly = false;
  double radius = 0; // ban kinh cua vong tron slider

  Orientation mOrientation;

  @override
  void initState() {
    super.initState();
    print(TAG + "initState");
    mOrientation = Orientation.portrait;
  }

  getVolumeSizes() {
    print(TAG + "getVolumeSizes");
//    Future.delayed(const Duration(milliseconds: 700), () {
    final RenderBox renderBoxRed = keyVolume.currentContext.findRenderObject();

    sizeWidth = renderBoxRed.size.width;
    sizeHeight = renderBoxRed.size.height;

    defaultLeft = sizeWidth / 2 - iconSize / 2;

    minPosLeft = sizeWidth / 2 - (sizeHeight - defalutTop);
    maxPosLeft = sizeWidth / 2 + (sizeHeight - defalutTop);
    minPosTop = defalutTop;
    maxPosTop = sizeHeight;
    icCircleBlueVisibly = true;

    radius = sizeHeight - defalutTop - iconSize / 2;

    setState(() {
      posLeft = sizeWidth / 2 - iconSize / 2;
      posTop = defalutTop;
      icCircleBlueVisibly = true;
    });
//    });
  }

  int buildTimes = 0;

  @override
  Widget build(BuildContext context) {
    buildTimes = buildTimes + 1;
//    if (buildTimes == 5) {
//      WidgetsBinding.instance.addPostFrameCallback((_) => getVolumeSizes());
//    }

    return OrientationBuilder(builder: (context, orientation) {
      print(TAG + " build $orientation");
      if (orientation == Orientation.landscape && mOrientation == Orientation.portrait) {
        mOrientation = orientation;
        WidgetsBinding.instance.addPostFrameCallback((_) => getVolumeSizes());
      }
      return Container(
          key: keyVolume,
          width: double.infinity,
          height: double.infinity,
          child: new CustomPaint(
            painter: MyCustomPainter(),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/bg_volume.png",
                    fit: BoxFit.fill,
                  ),
                ),
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
                      double progress = ((dragX + radius) / (2 * radius));
                      widget.bloc.setVolume(progress);
                      handleDragVolume(dragX, dragY);
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      width: iconSize + 5,
                      height: iconSize + 5,
                      child: Visibility(
                        visible: icCircleBlueVisibly,
                        child: Image.asset("assets/images/ic_circle_blue.png"),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Volume",
                    style: TextStyle(color: HexColor("#7C7C7C")),
                  ),
                ),
              ],
            ),
          ));
    });
  }

  void handleDragVolume(double dx, double dy) {
    double offsetX = dx.abs();
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

//    canvas.drawArc(
//        new Rect.fromCircle(center: new Offset(size.width / 2, size.height), radius: size.height - topCircle1),
//        -pi,
//        arcAngle,
//        false,
//        paint1);
//
//    canvas.drawArc(
//        new Rect.fromCircle(center: new Offset(size.width / 2, size.height), radius: size.height - topCircle2),
//        -pi,
//        arcAngle,
//        false,
//        paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
