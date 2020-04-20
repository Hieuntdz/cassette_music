import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/ui/widget/EqualizerControl.dart';
import 'package:cassettemusic/upgrate/ui/widget/VolumeCircleSlider.dart';
import 'package:cassettemusic/upgrate/ui/widget/button.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Control extends StatefulWidget {
  @override
  ControlState createState() => ControlState();
}

class ControlState extends State<Control> {
  AppSummary appSummary;
  ui.Image equalizerThumb;

  @override
  void initState() {
    super.initState();

    loadEqualizerThumb();
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
      child: Consumer<ControlBloc>(
        builder: (context, bloc) {
          return Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: initEqualizer(bloc),
              ),
              Expanded(
                flex: 8,
                child: initButtons(bloc),
              ),
              Expanded(
                flex: 3,
                child: initVolume(bloc),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget initEqualizer(ControlBloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: 3, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: EqualizerControl(
              equalizerState: bloc.trebbleControll,
              thumb: equalizerThumb,
              bloc: bloc,
            ),
          ),
          Flexible(
            child: EqualizerControl(
              equalizerState: bloc.bassControll,
              thumb: equalizerThumb,
              bloc: bloc,
            ),
          ),
        ],
      ),
    );
  }

  Widget initButtons(ControlBloc bloc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      height: double.infinity,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(
        top: 6,
        bottom: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CButton(
            bloc: bloc,
            state: bloc.rewind,
          ),
          SizedBox(width: Const.controlButtonSpace),
          CButton(
            bloc: bloc,
            state: bloc.play,
          ),
          SizedBox(width: Const.controlButtonSpace),
          CButton(
            bloc: bloc,
            state: bloc.forward,
          ),
          SizedBox(width: Const.controlButtonSpace),
          CButton(
            bloc: bloc,
            state: bloc.pause,
          ),
          SizedBox(width: Const.controlButtonSpace),
          CButton(
            bloc: bloc,
            state: bloc.stop,
          ),
          SizedBox(width: Const.controlButtonSpace),
          CButton(
            bloc: bloc,
            state: bloc.eject,
          ),
        ],
      ),
    );
  }

  Widget initVolume(ControlBloc bloc) {
    return Container(
      child: VolumeCircleSlider(bloc),
    );
  }

  Future<void> loadEqualizerThumb() async {
    final ByteData data = await rootBundle.load('assets/images/ic_thumb.png');
    equalizerThumb = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
