import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Control extends StatefulWidget {
  @override
  ControlState createState() => ControlState();
}

class ControlState extends State<Control> {
  AppSummary appSummary;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appSummary = AppSummary(context);

    return Container(
      width: double.infinity,
      height: appSummary.screenHeight * Const.controlHeight,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage(Images.controlBackground),
          repeat: ImageRepeat.repeatX,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}