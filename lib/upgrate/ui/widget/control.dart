import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
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
          buildButton(bloc, bloc.rewind),
          SizedBox(width: Const.controlButtonSpace),
          buildButton(bloc, bloc.play),
          SizedBox(width: Const.controlButtonSpace),
          buildButton(bloc, bloc.forward),
          SizedBox(width: Const.controlButtonSpace),
          buildButton(bloc, bloc.pause),
          SizedBox(width: Const.controlButtonSpace),
          buildButton(bloc, bloc.stop),
          SizedBox(width: Const.controlButtonSpace),
          buildButton(bloc, bloc.eject),
        ],
      ),
    );
  }

  Widget buildButton(ControlBloc bloc, ButtonState state) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTapDown: (details) {
          print('onTapDown');
          bloc.tapButton(state);
        },
        onTapUp:(details) {
          print('onTapUp');
          bloc.tapCancel(state);
        },
        onLongPressStart: (details) {
          print('onLongPressStart');
        },
        onLongPressEnd:(details) {
          print('onLongPressEnd');
          bloc.tapCancel(state);
        },
        onLongPress: () {},
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(state.currentBackground),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 8),
              child: Image.asset(
                state.currentIcon,
                fit: BoxFit.fill,
                width: Const.controlButtonIconSize,
                height: Const.controlButtonIconSize,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget initVolume(ControlBloc bloc) {
    return Container();
  }
}
