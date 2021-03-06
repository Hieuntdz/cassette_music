import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/util/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CButton extends StatefulWidget {
  CButton({Key key, this.state, this.bloc}) : super(key: key);

  final ButtonState state;
  final ControlBloc bloc;

  @override
  CButtonState createState() => CButtonState();
}

class CButtonState extends State<CButton> {
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
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTapDown: (details) {
          print('onTapDown');
          widget.bloc.tapButton(widget.state);
        },
        onTapUp: (details) {
          print('onTapUp');
          widget.bloc.tapCancel(widget.state, false, DateTime.now().millisecondsSinceEpoch);
        },
        onLongPressStart: (details) {
          print('onLongPressStart');
          widget.bloc.setTimeLongPressStart(DateTime.now().millisecondsSinceEpoch);
        },
        onLongPressEnd: (details) {
          print('onLongPressEnd');
          widget.bloc.tapCancel(widget.state, true, DateTime.now().millisecondsSinceEpoch);
        },
        onLongPress: () {},
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(widget.state.currentBackground),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 8),
              child: Image.asset(
                widget.state.currentIcon,
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
}
