import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/ui/widget/button.dart';
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
      child: Consumer<ControlBloc>(
        builder: (context, bloc) {
          return Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: initEqualizer(bloc),
              ),
              Expanded(
                flex: 3,
                child: initButtons(bloc),
              ),
              Expanded(
                flex: 1,
                child: initVolume(bloc),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget initEqualizer(ControlBloc bloc) {
    return Container();
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
    return Container();
  }
}
