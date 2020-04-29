import 'package:cassettemusic/orign/constant.dart';
import 'package:cassettemusic/orign/hex_color.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EqualizerSlider extends StatefulWidget {
  final EqualizerState equalizerState;
  final ControlBloc bloc;

  EqualizerSlider({this.equalizerState, this.bloc});

  @override
  State<StatefulWidget> createState() {
    return EqualizerSliderSate();
  }
}

class EqualizerSliderSate extends State<EqualizerSlider> {
  EqualizerSliderSate();

  GlobalKey keyEqualizer = new GlobalKey();
  AppSummary appSummary;

  double width = 0;
  double height = 0;
  double icHeight = 0;
  double icWidth = 0;
  double thumbPos = 0;
  double titleWidth = 15;
  int buildTime = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appSummary = AppSummary(context);
    buildTime++;
    if (buildTime >= 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getSize());
    }
    return Container(
      key: keyEqualizer,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            width: titleWidth,
            height: double.infinity,
            child: Text(
              "${widget.equalizerState.text}",
              style: TextStyle(
                fontSize: AppTextSize.textNormal,
                color: HexColor("#434343"),
              ),
            ),
          ),
          Container(
            width: width,
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    Images.equalizerTrack,
                    width: width - icWidth,
                    height: 5,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: height / 2 - icHeight / 2,
                  left: thumbPos,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (DragUpdateDetails d) {
                      double dx = d.delta.dx;
                      double currentPos = (width) * widget.equalizerState.progress / Const.bass.max + dx;
                      if (currentPos <= 0) {
                        currentPos = 0;
                      }
                      if (currentPos > width) {
                        currentPos = width;
                      }
                      widget.bloc.onEqualizerChange(widget.equalizerState, currentPos / width * Const.bass.max);
                    },
                    child: Container(
                      width: icWidth,
                      height: icHeight,
                      child: Image.asset(Images.equalizerThumb),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getSize() {
    final RenderBox renderBoxRed = keyEqualizer.currentContext.findRenderObject();
    setState(() {
      width = renderBoxRed.size.width - titleWidth;
      height = renderBoxRed.size.height;
      icHeight = appSummary.screenHeight * Const.equalizerThumbRatio;
      icWidth = icHeight * Const.equalizerOwnerThumbRatio;
      thumbPos = (width - icWidth) * widget.equalizerState.progress / Const.bass.max;
    });
  }
}
