import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cassettemusic/model/AudioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'AppState.dart';
import 'BreakLine.dart';
import 'Constant.dart';
import 'ControllerType.dart';
import 'CustomSliderThumb.dart';
import 'HexColor.dart';
import 'ImageController.dart';
import 'MyCircleSlider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final String TAG = "_MyHomePageState";

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('CHANNEL_GET_AUDIO_LIST');

  List<AudioModel> listAudioModel = new List();
  AnimationController animationController;
  AppState appState = AppState.PAUSING;
  ui.Image image;
  String icPauseUrl = "assets/images/ic_pause.png";
  String icPlayUrl = "assets/images/ic_play.png";

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );
    init();
    getAudioList();
  }

  Future<void> getAudioList() async {
    try {
      String result = await platform.invokeMethod('getAudioList');
      var arrJson = jsonDecode(result) as List;
      listAudioModel =
          arrJson.map((tagJson) => AudioModel.fromJson(tagJson)).toList();
      print(TAG + "list Audio size : ${listAudioModel.length}");
    } on PlatformException catch (e) {}
  }

  Future<Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/ic_thumb.png');
    image = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  stopPlayRotation() {
    animationController.stop();
  }

  startPlayRotation() {
    animationController.repeat();
  }

  imageControlerCallback(ControllerType type) {
    print(type.toString());
    switch (type) {
      case ControllerType.PLAY:
        if (appState == AppState.PAUSING) {
          appState = AppState.PLAYING;
          startPlayRotation();
          setState(() {
            icPlayUrl = "assets/images/ic_playing.png";
            icPauseUrl = "assets/images/ic_pause.png";
          });
        }
        break;
      case ControllerType.PAUSE:
        if (appState == AppState.PLAYING) {
          appState = AppState.PAUSING;
          stopPlayRotation();
          setState(() {
            icPlayUrl = "assets/images/ic_play.png";
            icPauseUrl = "assets/images/ic_pauseing.png";
          });
        }
        break;
      case ControllerType.BACK:
        break;
      case ControllerType.NEXT:
        // TODO: Handle this case.
        break;
      case ControllerType.TMP1:
        // TODO: Handle this case.
        break;
      case ControllerType.TMP2:
        // TODO: Handle this case.
        break;
    }
  }

  Widget getRotateImage() {
    print("animationController value : ${animationController.value}");
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset("assets/images/ic_turn_arrow_background.png"),
          Container(
              padding: EdgeInsets.all(15),
              child: AnimatedBuilder(
                animation: animationController,
                child: Image.asset("assets/images/ic_turn_arrow.png"),
                builder: (BuildContext context, Widget _widget) {
                  return Transform.rotate(
                    angle: animationController.value * 6.3,
                    child: _widget,
                  );
                },
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Container(
        child: Container(
          color: HexColor("#2E2E2E"),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1000 / 460,
                        child: Image.asset(
                          "assets/images/app_background.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 870 / 460,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.top,
                              top: MediaQuery.of(context).padding.top),
                          height: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            color: HexColor("#E5DFD6"),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        left: 10, top: 5, bottom: 1),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          color: Colors.black,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "A",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: Text(
                                              "Diem xua- Trinh Cong Sơn ádjabsdjnfvbsndbfd sasdasdasdasdadfggdfgdfg đfg",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      AppTextSize.textTitle,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: BreakLine("#E8D0A4", 4),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(
                                        top: 7, bottom: 5, right: 20),
                                    child: Text("Nhac Trinh",
                                        style: TextStyle(
                                            fontSize: AppTextSize.textNormal,
                                            color: Colors.black)),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: BreakLine("#E8D0A4", 1),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 50, right: 50, top: 10),
                                              child: AspectRatio(
                                                aspectRatio: 660 / 194,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Card(
                                                    color: HexColor("#393939"),
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color:
                                                                Colors.black12,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Card(
                                                      color:
                                                          HexColor("#393939"),
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 3.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    10),
                                                              )),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  getRotateImage(),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child:
                                                                  Container(),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  getRotateImage(),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 7),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 20),
                                                      child: Text(
                                                        "Maxell",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                AppTextSize
                                                                    .textHeader,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "POSITION-NORMAL",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: AppTextSize
                                                                .textNormal),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                        "90",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                AppTextSize
                                                                    .textHeader,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20),
                  color: HexColor("#272727"),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: SliderBT(
                                  text: "T",
                                  progress: 100,
                                  image: image,
                                ),
                              ),
                              Flexible(
                                child: SliderBT(
                                  text: "B",
                                  progress: 50,
                                  image: image,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: double.infinity,
                          margin: EdgeInsets.only(top: 5),
                          child: Container(
//                            color: Colors.black,
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.only(
//                                  topLeft: Radius.circular(5),
//                                  topRight: Radius.circular(5)),
//                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              border: Border.all(color: Colors.black),
                            ),
                            alignment: Alignment.center,
                            child: Container(
//                              width: double.minPositive,
                              padding: EdgeInsets.all(3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ImageController(
                                      "assets/images/ic_back.png",
                                      ControllerType.BACK,
                                      imageControlerCallback),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  ImageController(
                                      icPlayUrl,
                                      ControllerType.PLAY,
                                      imageControlerCallback),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  ImageController(
                                      "assets/images/ic_next.png",
                                      ControllerType.NEXT,
                                      imageControlerCallback),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  ImageController(
                                      icPauseUrl,
                                      ControllerType.PAUSE,
                                      imageControlerCallback),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  ImageController(
                                      "assets/images/ic_tmp1.png",
                                      ControllerType.TMP1,
                                      imageControlerCallback),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  ImageController(
                                      "assets/images/ic_tmp2.png",
                                      ControllerType.TMP2,
                                      imageControlerCallback),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                MyCircleSlider(),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "Volume",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliderBT extends StatefulWidget {
  String text;
  double progress;
  ui.Image image;

  SliderBT({this.text, this.progress, this.image});

  @override
  State<StatefulWidget> createState() {
    return SliderBTState(text, progress);
  }
}

class SliderBTState extends State<SliderBT> {
  String text;
  double progress;

  SliderBTState(this.text, this.progress);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            "$text",
            style: TextStyle(
                fontSize: AppTextSize.textNormal, color: Colors.white),
          ),
          Flexible(
              child: Container(
            width: 200,
            padding: EdgeInsets.all(0),
            alignment: Alignment.topLeft,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: 5.0,
                  thumbShape: CustomSliderThumb(
                      thumbRadius: 5,
                      thumbHeight: 20,
                      min: 10,
                      max: 100,
                      image: widget.image)),
              child: Slider(
                value: progress,
                min: 0,
                max: 100,
                activeColor: Colors.black,
                inactiveColor: Colors.black,
                onChanged: (double newValue) {
                  print("Progress value : $newValue");
                  setState(() {
                    progress = newValue;
                  });
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}
