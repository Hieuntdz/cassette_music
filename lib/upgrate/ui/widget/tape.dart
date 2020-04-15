import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/ui/widget/line.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tape extends StatefulWidget {
  @override
  TapeState createState() => TapeState();
}

class TapeState extends State<Tape> {
  AppSummary appSummary;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appSummary = AppSummary(context);
    final height = appSummary.screenHeight;
    final width = height * Const.tapeRatio;

    return Container(
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
            height: height - Const.controlHeight,
            alignment: Alignment.center,
            child: initContent(height),
          ),
        ],
      ),
    );
  }

  Widget initContent(double h) {
    if (h <= 0) return Container();

    final height = h * Const.tapeContentWithTape;
    final width = height * Const.tapeContentRation;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(10),
        child: Consumer<TapeBloc>(
          builder: (context, value) {
            return Column(
              children: <Widget>[
                initSongName(value),
                Container(
                  padding: EdgeInsets.only(
                    left: 4,
                    top: 4,
                    bottom: 4,
                  ),
                  child: VerticalLine("#E8D0A4", 4),
                ),
                initSongDes(value),
                Container(
                  padding: EdgeInsets.only(
                    left: 4,
                    top: 4,
                    bottom: 4,
                  ),
                  child: VerticalLine("#E8D0A4", 1),
                ),
                initAnim(),
                initTapeLabel(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget initSongName(TapeBloc bloc) {
    if (bloc == null) return Container();
    String name = (bloc.song != null && bloc.song.name.length > 0)
        ? bloc.song.name
        : Const.songNameLabel;
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        Container(
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
        )
      ],
    );
  }

  Widget initSongDes(TapeBloc bloc) {
    if (bloc == null) return Container();
    String des = (bloc.song != null && bloc.song.location.length > 0)
        ? bloc.song.location
        : Const.songDesLabel;
    return Consumer<TapeBloc>(
      builder: (context, bloc) {
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
      },
    );
  }

  Widget initAnim() {
    return Container();
  }

  Widget initTapeLabel() {
    return Container();
  }
}