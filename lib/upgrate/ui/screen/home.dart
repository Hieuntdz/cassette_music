import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/ui/widget/control.dart';
import 'package:cassettemusic/upgrate/ui/widget/tape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ControlBloc controlBloc = BlocProvider.getBloc<ControlBloc>();
      controlBloc.getSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set landscape for app
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.grey,
          ),
          Center(
            child: Tape(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Control(),
          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          ControlBloc controlBloc = BlocProvider.getBloc<ControlBloc>();
//          controlBloc.getSongs();
//        },
//      ),
    );
  }
}
