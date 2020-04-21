import 'package:cassettemusic/upgrate/control/control_bloc.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/ui/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("ZZZZZZZZZZZZZZZZZZZZZ BUILD");
    final tapeBloc = TapeBloc();
    final controlBloc = ControlBloc(tapeBloc);
    return MultiBlocProvider(
      providers: [
        BlocProvider<TapeBloc>(
          create: (context) => tapeBloc,
        ),
        BlocProvider<ControlBloc>(
          create: (context) => controlBloc,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
