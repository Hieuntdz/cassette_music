import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/control/control_state.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/ui/widget/button.dart';
import 'package:cassettemusic/upgrate/ui/widget/equalizer_slider.dart';
import 'package:cassettemusic/upgrate/ui/widget/volume_circle_slider.dart';
import 'package:cassettemusic/upgrate/util/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    ControlBloc bloc = BlocProvider.of<ControlBloc>(context);
    return Container(
      width: double.infinity,
      height: appSummary.screenHeight * Const.controlHeight,
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage(Images.controlBackground), fit: BoxFit.contain, repeat: ImageRepeat.repeatX),
      ),
      child: BlocBuilder<ControlBloc, ControlBlocState>(
        builder: (context, state) {
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
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: EqualizerSlider(
                equalizerState: bloc.trebbleControll,
                bloc: bloc,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: EqualizerSlider(
                equalizerState: bloc.bassControll,
                bloc: bloc,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget initButtons(ControlBloc bloc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        image: new DecorationImage(image: new AssetImage(Images.buttonBackground), fit: BoxFit.fill),
      ),
      height: double.infinity,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(
        top: 10,
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
}
