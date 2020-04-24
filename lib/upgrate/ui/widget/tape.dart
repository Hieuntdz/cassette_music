import 'package:cassettemusic/orign/WidgetIce.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/control/tabe_bloc_state.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/ui/widget/line.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tape extends StatefulWidget {
  @override
  TapeState createState() => TapeState();
}

class TapeState extends State<Tape> with SingleTickerProviderStateMixin {
  AppSummary appSummary;
  AnimationController animationController;
  ControlBloc controlBloc;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );
    controlBloc = BlocProvider.of<ControlBloc>(context);
    controlBloc.setAnimationController(animationController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appSummary = AppSummary(context);
    final height = appSummary.screenHeight - MediaQuery.of(context).padding.top;
    final width = height * Const.tapeRatio;

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Image.asset(
            Images.tapeBackground,
            fit: BoxFit.fitHeight,
          ),
          Container(
            width: double.infinity,
            height: height - (height * Const.controlHeight),
            alignment: Alignment.center,
            child: initContent(height),
          ),
        ],
      ),
    );
  }

  Widget initContent(double h) {
    print("TapeBlocState initContent");
    if (h <= 0) return Container();
    final height = h * Const.tapeContentWithTapeRatio;
    final width = height * Const.tapeContentRatio;

    TapeBloc tapeBloc = BlocProvider.of<TapeBloc>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          child: Image.asset(
            Images.tapeParentBackground,
            fit: BoxFit.fill,
          ),
        ),
        Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  Images.tapeSubBackground,
                  fit: BoxFit.fill,
                ),
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
//                color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(6),
                  child: BlocBuilder<TapeBloc, TapeBlocState>(
                    builder: (context, value) {
                      return Column(
                        children: <Widget>[
                          initSongName(tapeBloc),
                          Container(
                            padding: EdgeInsets.only(
                              left: 4,
                              top: 4,
                              bottom: 4,
                            ),
                            child: VerticalLine("#E8D0A4", 4),
                          ),
                          initSongDes(tapeBloc),
                          Container(
                            padding: EdgeInsets.only(
                              left: 4,
                              top: 2,
                              bottom: 4,
                            ),
                            child: VerticalLine("#E8D0A4", 1),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          initAnim(tapeBloc),
                          SizedBox(
                            height: 6,
                          ),
                          Expanded(
                            child: initTapeLabel(),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget initSongName(TapeBloc bloc) {
    if (bloc == null) return Container();
    String name =
        (bloc.audioModel != null && bloc.audioModel.name.length > 0) ? bloc.audioModel.name : Const.songNameLabel;
    double size = appSummary.screenHeight * Const.tapeContentLabelRatio;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          child: Image.asset(
            Images.tapeLabel1,
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 5),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Const.songNameTextSize,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget initSongDes(TapeBloc bloc) {
    if (bloc == null) return Container();
    String des =
        (bloc.audioModel != null && bloc.audioModel.folder.length > 0) ? bloc.audioModel.folder : Const.songDesLabel;
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        des,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: Const.songDesTextSize,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget initAnim(TapeBloc bloc) {
    final height = appSummary.screenHeight * Const.tapeAnimRatio;
    final width = height / Const.tapeAnimOwerRatio;
    final padding = 4.0;
    final subPadding = 12.0;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              Images.tapeCenterBackground1,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(padding),
            child: Image.asset(
              Images.tapeCenterBackground2,
              fit: BoxFit.fill,
            ),
          ),
//          Container(
//            width: double.infinity,
//            height: double.infinity,
//            padding: EdgeInsets.all(padding),
//            child: CustomPaint(
//              painter: ReelPainter(padding, padding),
//            ),
//          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(subPadding),
            child: Row(
              children: <Widget>[
                initWheel(height - subPadding),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  width: (width - subPadding * 2) - ((height - subPadding) * 2),
                  height: height - subPadding,
                  child: WidgetIce(bloc.currentTime, bloc.totalTime),
                ),
                initWheel(height - subPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget initWheel(double size) {
    int padding = 24;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(0),
      child: Stack(
        children: <Widget>[
          Image.asset(
            Images.tapeReelBorder,
            fit: BoxFit.fill,
            width: size,
            height: size,
          ),
          Center(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget _widget) {
                return Transform.rotate(
                  angle: animationController.value * 6.3,
                  child: _widget,
                );
              },
              child: Image.asset(
                Images.tapeReel,
                fit: BoxFit.fill,
                width: size - padding,
                height: size - padding,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget initTapeLabel() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        Images.tapeLabel2,
        fit: BoxFit.fill,
      ),
    );
  }
}
