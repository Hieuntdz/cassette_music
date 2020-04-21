import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/model/app.dart';
import 'package:cassettemusic/upgrate/ui/widget/control.dart';
import 'package:cassettemusic/upgrate/ui/widget/tape.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ControlBloc controlBloc = BlocProvider.of<ControlBloc>(context);
      controlBloc.setContext(context);
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

    var appSummary = AppSummary(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
          ),
          Center(
            child: Tape(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Control(),
          ),
          Container(
            width: double.infinity,
            height: appSummary.screenHeight * Const.bgMoRatio,
            child: Image.asset(
              "assets/images/bg_mo.png",
              fit: BoxFit.fill,
            ),
          )
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
