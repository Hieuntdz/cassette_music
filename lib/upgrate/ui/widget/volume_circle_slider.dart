import 'dart:math';

import 'package:cassettemusic/orign/hex_color.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/util/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String TAG = "MyCircleSlider";

class VolumeCircleSlider extends StatefulWidget {
  final ControlBloc bloc;

  VolumeCircleSlider(this.bloc);

  @override
  State<StatefulWidget> createState() {
    return VolumeCircleSliderState();
  }
}

final double topCircle1 = 5;
final double topCircle2 = 10;

class VolumeCircleSliderState extends State<VolumeCircleSlider> {
  GlobalKey keyVolume = new GlobalKey();
  double dragX = 0; // gia tri cuoi cung khi keo nut tron phia X
  double dragY = 0; // gia tri cuoi cung khi keo nut tron phia Y

  double iconSize = 15;
  double sizeWidth = 0;
  double sizeHeight = 0;
  double defaultTop = 20;
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

    minPosLeft = sizeWidth / 2 - (sizeHeight - defaultTop);
    maxPosLeft = sizeWidth / 2 + (sizeHeight - defaultTop);
    minPosTop = defaultTop;
    maxPosTop = sizeHeight;
    icCircleBlueVisibly = true;

    radius = sizeHeight - defaultTop - iconSize / 2;

    setState(() {
      posLeft = sizeWidth / 2 - iconSize / 2;
      posTop = defaultTop;
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

    return OrientationBuilder(
      builder: (context, orientation) {
        print(TAG + " build $orientation");
        if (orientation == Orientation.landscape && mOrientation == Orientation.portrait) {
          mOrientation = orientation;
          WidgetsBinding.instance.addPostFrameCallback((_) => getVolumeSizes());
        }
        return Container(
          key: keyVolume,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5, left: 5),
                alignment: Alignment.center,
                child: Image.asset(
                  Images.bgVolume,
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
                      posTop = defaultTop;
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
                margin: EdgeInsets.only(bottom: 2, left: 5),
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Volume",
                  style: TextStyle(color: HexColor("#7C7C7C")),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleDragVolume(double dx, double dy) {
    double offsetX = dx.abs();
    if (offsetX > radius) {
      offsetX = radius;
    }

    double alpha = asin(offsetX / radius);
    double offsetY = radius - cos(alpha) * radius;
    if (dx < 0) {
      setState(() {
        posLeft = defaultLeft - offsetX;
        posTop = defaultTop + offsetY;
      });
    } else {
      setState(() {
        posLeft = defaultLeft + offsetX;
        posTop = defaultTop + offsetY;
      });
    }
  }
}
