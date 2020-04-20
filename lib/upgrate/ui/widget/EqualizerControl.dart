import 'dart:ui' as ui;

import 'package:cassettemusic/orign/Constant.dart';
import 'package:cassettemusic/orign/CustomSliderThumb.dart';
import 'package:cassettemusic/orign/HexColor.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EqualizerControl extends StatefulWidget {
  EqualizerState equalizerState;
  ui.Image thumb;
  ControlBloc bloc;

  EqualizerControl({this.equalizerState, this.thumb, this.bloc});

  @override
  State<StatefulWidget> createState() {
    return EqualizerControlSate();
  }
}

class EqualizerControlSate extends State<EqualizerControl> {
  EqualizerControlSate();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            "${widget.equalizerState.text}",
            style: TextStyle(fontSize: AppTextSize.textNormal, color: HexColor("#434343")),
          ),
          Flexible(
              child: Container(
            width: 200,
            padding: EdgeInsets.all(0),
            alignment: Alignment.topLeft,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5.0,
                thumbShape: CustomSliderThumb(thumbRadius: 5, thumbHeight: 20, min: 10, max: 100, image: widget.thumb),
              ),
              child: Slider(
                value: widget.equalizerState.progress,
                min: Const.bass.min,
                max: Const.bass.max,
                activeColor: Colors.black,
                inactiveColor: Colors.black,
                onChanged: (double newValue) {
                  widget.bloc.onEqualizerChange(widget.equalizerState, newValue);
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}