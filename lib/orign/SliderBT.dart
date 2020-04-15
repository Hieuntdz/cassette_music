import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Constant.dart';
import 'CustomSliderThumb.dart';
import 'HexColor.dart';

class SliderBT extends StatefulWidget {
  String text;
  double progress;
  ui.Image image;
  String type;
  final void Function(String, double) onProgressChangeCallback;

  SliderBT({this.text, this.progress, this.image, this.type, this.onProgressChangeCallback});

  @override
  State<StatefulWidget> createState() {
    return SliderBTState(text, progress, type, onProgressChangeCallback);
  }
}

class SliderBTState extends State<SliderBT> {
  String text;
  double progress;
  String type;
  final void Function(String, double) onProgressChangeCallback;

  SliderBTState(this.text, this.progress, this.type, this.onProgressChangeCallback);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            "$text",
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
                thumbShape: CustomSliderThumb(thumbRadius: 5, thumbHeight: 20, min: 10, max: 100, image: widget.image),
              ),
              child: Slider(
                value: progress,
                min: 0,
                max: 3000,
                activeColor: Colors.black,
                inactiveColor: Colors.black,
                onChanged: (double newValue) {
                  print("Progress value : $newValue");
                  onProgressChangeCallback(type, newValue - 1500);
                  setState(() {
                    progress = newValue;
                  });
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}
