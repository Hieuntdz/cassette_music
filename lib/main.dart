import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:cassettemusic/MenuScreen.dart';
import 'package:cassettemusic/model/AudioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import 'AppState.dart';
import 'BreakLine.dart';
import 'Constant.dart';
import 'ControllerType.dart';
import 'HexColor.dart';
import 'ImageController.dart';
import 'MyCircleSlider.dart';
import 'SliderBT.dart';
import 'WidgetIce.dart';

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static const platform = const MethodChannel('CHANNEL_GET_AUDIO_LIST');

  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription playerCompleteSubscription;
  StreamSubscription playerErrorSubscription;
  StreamSubscription playerDurationSubscription;
  Duration audiDuration;

  AudioModel currentAudio;
  List<AudioModel> listAudioModel = new List();
  List<AudioModel> listAudioModelContent = new List();
  List<AudioModel> listAudioArtistModel = new List();
  List<AudioModel> listAudioFolderModel = new List();
  AnimationController animationController;
  AppState appState = AppState.PAUSING;
  ui.Image image;
  int currentAudioPos = 0;
  int totalAudio = 0;

  double screenWith;
  double screenHeight;

  //state
  String icPauseUrl = "assets/images/ic_pause.png";
  String icPlayUrl = "assets/images/ic_play.png";
  String icNextUrl = "assets/images/ic_next.png";
  String icBackUrl = "assets/images/ic_back.png";
  String audioName = "Casste 1990";
  String audioFolder = "Audio";

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
      listAudioModel = arrJson.map((tagJson) => AudioModel.fromJson(tagJson)).toList();
      listAudioModelContent.addAll(listAudioModel);
      totalAudio = listAudioModelContent.length;
    } on PlatformException catch (e) {}
  }

  Future<Null> init() async {
    audioPlayer.setBass(750);
    audioPlayer.setTreble(750);
    audioPlayer.setVolume(0.7);
    playerCompleteSubscription = audioPlayer.onPlayerCompletion.listen((event) {
      _onCompleteAudio();
    });

    playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
    });

    playerDurationSubscription = audioPlayer.onAudioPositionChanged.listen((event) {
      print("MMMMMMMMMMMMMMMMMMM $event");
      audiDuration = event;
    });

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

  playAudio(String path) async {
    await audioPlayer.play(path, isLocal: true);
  }

  updateStatePlay() {
    setState(() {
      icPlayUrl = "assets/images/ic_playing.png";
      icPauseUrl = "assets/images/ic_pause.png";
    });
  }

  updateStatePause() {
    setState(() {
      icPlayUrl = "assets/images/ic_play.png";
      icPauseUrl = "assets/images/ic_pauseing.png";
    });
  }

  void imageControlerCallback(ControllerType type) {
    print(type.toString());
    switch (type) {
      case ControllerType.PLAY:
        if (appState == AppState.PAUSING) {
          if (listAudioModelContent.length > currentAudioPos) {
            appState = AppState.PLAYING;
            startPlayRotation();
            currentAudio = listAudioModelContent.elementAt(currentAudioPos);
            print(TAG + "current Audi path : ${currentAudio.path}");
            updateStatePlay();
            playAudio(currentAudio.path);
            setState(() {
              audioName = currentAudio.name;
              audioFolder = currentAudio.folder;
            });
          } else {
            currentAudio = null;
          }
        }
        break;
      case ControllerType.PAUSE:
        onButtonPauseClick();
        break;
      case ControllerType.BACK:
        handleActionback();
        break;
      case ControllerType.NEXT:
        handleActionNext();
        break;
      case ControllerType.STOP:
        audioPlayer.pause();
        appState = AppState.PAUSING;
        stopPlayRotation();
        setState(() {
          icPlayUrl = "assets/images/ic_play.png";
          icPauseUrl = "assets/images/ic_pause.png";
        });
        break;
      case ControllerType.MENU:
//        onButtonPauseClick();
        navigateToMenuScreen(context);
        break;
    }
  }

  //Tua bang
  void longPressEndCallback(ControllerType type, int time) {
    if (type == ControllerType.NEXT) {
      setState(() {
        icNextUrl = "assets/images/ic_next.png";
      });
//      audioPlayer.seek(Duration(milliseconds: time + audiDuration.inMilliseconds));
      if (currentAudio != null) {
        if (appState == AppState.PLAYING) {
          audioPlayer.play(currentAudio.path,
              isLocal: true, position: Duration(milliseconds: time + audiDuration.inMilliseconds));
        } else {
          audioPlayer.seek(Duration(milliseconds: time + audiDuration.inMilliseconds));
        }
      }
    } else if (type == ControllerType.BACK) {
      setState(() {
        icBackUrl = "assets/images/ic_back.png";
      });
//      audioPlayer.seek(Duration(milliseconds: audiDuration.inMilliseconds - time));
      if (currentAudio != null) {
        if (appState == AppState.PLAYING) {
          audioPlayer.play(currentAudio.path,
              isLocal: true, position: Duration(milliseconds: audiDuration.inMilliseconds - time));
        } else {
          audioPlayer.seek(Duration(milliseconds: audiDuration.inMilliseconds - time));
        }
      }
    }
  }

  void longPressStartCallback(ControllerType type) {
    print(TAG + "longPressStartCallback type $type");
    audioPlayer.pause();
    if (type == ControllerType.NEXT) {
      setState(() {
        icNextUrl = "assets/images/ic_next_press.png";
      });
    } else if (type == ControllerType.BACK) {
      setState(() {
        icBackUrl = "assets/images/ic_backpress.png";
      });
    }
  }

  void onProgressSliderBassTrebleCallback(String type, double value) {
    if (type == "BASS") {
      audioPlayer.setBass(value);
    } else if (type == "TREBLE") {
      audioPlayer.setTreble(value);
    }
  }

  onProgressVolumeChage(double volume) {
    print(TAG + "onProgressVolumeChage : $volume");
    audioPlayer.setVolume(volume);
  }

  Widget getRotateImage() {
    print("animationController value : ${animationController.value}");
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 3),
      height: double.infinity,
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

  Future navigateToMenuScreen(context) async {
    Map result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuScreen(
                  listAudioModel: listAudioModel,
                )));

    if (result == null) {
      return;
    }

    String type = result[MenuScreen.KEY_TYPE];
    int pos = result[MenuScreen.KEY_POS];
    String value = result[MenuScreen.KEY_VALUE];
    if (type.isNotEmpty && type == MenuScreen.DANH_SACH) {
      listAudioModelContent.clear();
      listAudioModelContent.addAll(listAudioModel);
      currentAudioPos = pos;
    } else if (type.isNotEmpty && type == MenuScreen.ARTIST) {
      listAudioModelContent.clear();
      currentAudioPos = 0;
      for (AudioModel audioModel in listAudioModel) {
        if (audioModel.artist == value) {
          listAudioModelContent.add(audioModel);
        }
      }
    } else if (type.isNotEmpty && type == MenuScreen.FOLDER) {
      listAudioModelContent.clear();
      currentAudioPos = 0;
      for (AudioModel audioModel in listAudioModel) {
        if (audioModel.folder == value) {
          listAudioModelContent.add(audioModel);
        }
      }
    }
    if (listAudioModelContent.length > currentAudioPos) {
      currentAudio = listAudioModelContent[currentAudioPos];
      audioName = currentAudio.name;
      audioFolder = currentAudio.folder;
    }
    appState = AppState.PAUSING;
    audioPlayer.stop();
    stopPlayRotation();
    setState(() {
      icPlayUrl = "assets/images/ic_play.png";
      icPauseUrl = "assets/images/ic_pause.png";
      audioName = audioName;
      audioFolder = audioFolder;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerCompleteSubscription.cancel();
    playerDurationSubscription.cancel();
    playerErrorSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Container(
          color: HexColor("#2E2E2E"),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1120 / 708,
                  child: Image.asset(
                    "assets/images/background.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  alignment: Alignment.center,
                  height: screenHeight - screenWith * 118 / 1280,
                  child: AspectRatio(
                    aspectRatio: 900 / 485,
                    child: Card(
                      color: HexColor("#2E2E2E"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          color: HexColor("#E5DFD6"),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: 10, top: 5, bottom: 1),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        color: Colors.black,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "A",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10, right: 5),
                                          child: Text(
                                            audioName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: AppTextSize.textTitle,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: BreakLine("#E8D0A4", 4),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(top: 7, bottom: 5, right: 20),
                                  child: Text(audioFolder,
                                      style: TextStyle(fontSize: AppTextSize.textNormal, color: Colors.black)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
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
                                            margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                                            child: AspectRatio(
                                              aspectRatio: 660 / 194,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Card(
                                                  color: HexColor("#393939"),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(color: Colors.black12, width: 2.0),
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  child: Card(
                                                    color: HexColor("#393939"),
                                                    margin: EdgeInsets.all(10),
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(color: Colors.black, width: 3.0),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10),
                                                        )),
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                margin: EdgeInsets.only(left: 5),
                                                                alignment: Alignment.centerLeft,
                                                                child: getRotateImage(),
                                                              )),
                                                          Expanded(
                                                            //BANG
                                                            flex: 3,
                                                            child: Container(
                                                              margin: EdgeInsets.only(top: 4, bottom: 4),
                                                              child: WidgetIce(currentAudioPos, totalAudio),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              margin: EdgeInsets.only(right: 5),
                                                              alignment: Alignment.centerRight,
                                                              child: getRotateImage(),
                                                            ),
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
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 7),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    margin: EdgeInsets.only(left: 30),
                                                    child: Text(
                                                      "Maxell",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: AppTextSize.textHeader,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "POSITION-NORMAL",
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: AppTextSize.textNormal),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    margin: EdgeInsets.only(right: 30),
                                                    child: Text(
                                                      "90",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: AppTextSize.textHeader,
                                                          fontWeight: FontWeight.bold),
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
                  )),
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1280 / 118,
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
                                    progress: 1500,
                                    image: image,
                                    type: "TREBLE",
                                    onProgressChangeCallback: onProgressSliderBassTrebleCallback,
                                  ),
                                ),
                                Flexible(
                                  child: SliderBT(
                                    text: "B",
                                    progress: 1500,
                                    image: image,
                                    type: "BASS",
                                    onProgressChangeCallback: onProgressSliderBassTrebleCallback,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ImageController(icBackUrl, ControllerType.BACK, imageControlerCallback,
                                        longPressEndCallback, longPressStartCallback),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    ImageController(icPlayUrl, ControllerType.PLAY, imageControlerCallback,
                                        longPressEndCallback, longPressStartCallback),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    ImageController(icNextUrl, ControllerType.NEXT, imageControlerCallback,
                                        longPressEndCallback, longPressStartCallback),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    ImageController(icPauseUrl, ControllerType.PAUSE, imageControlerCallback,
                                        longPressEndCallback, longPressStartCallback),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    ImageController("assets/images/ic_tmp1.png", ControllerType.STOP,
                                        imageControlerCallback, longPressEndCallback, longPressStartCallback),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    ImageController("assets/images/ic_tmp2.png", ControllerType.MENU,
                                        imageControlerCallback, longPressEndCallback, longPressStartCallback),
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
                                  MyCircleSlider(onProgressVolumeChage),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      "Volume",
                                      style: TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                child: Image.asset(
                  "assets/images/bg_mo.png",
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleActionNext() {
    currentAudioPos++;
    if (currentAudioPos >= listAudioModelContent.length) {
      currentAudioPos = 0;
    }
    audioPlayer.pause();
    stopPlayRotation();

    if (listAudioModelContent.length > currentAudioPos) {
      AudioModel audioModel = listAudioModelContent.elementAt(currentAudioPos);
      currentAudio = audioModel;
      setState(() {
        audioName = audioModel.name;
        audioFolder = audioModel.folder;
      });
      if (appState == AppState.PLAYING) {
        playAudio(audioModel.path);
        startPlayRotation();
        updateStatePlay();
        playAudio(audioModel.path);
      }
    }
  }

  void handleActionback() {
    currentAudioPos--;
    if (currentAudioPos < 0) {
      currentAudioPos = listAudioModelContent.length - 1;
    }

    //TH ko co bai nao
    if (currentAudioPos < 0) {
      currentAudioPos = 0;
    }
    audioPlayer.pause();
    stopPlayRotation();

    if (listAudioModelContent.length > currentAudioPos && currentAudioPos >= 0) {
      AudioModel audioModel = listAudioModelContent.elementAt(currentAudioPos);
      currentAudio = audioModel;
      setState(() {
        audioName = audioModel.name;
        audioFolder = audioModel.folder;
      });
      if (appState == AppState.PLAYING) {
        playAudio(audioModel.path);
        updateStatePlay();
        playAudio(audioModel.path);
      }
    }
  }

  void _onCompleteAudio() {
    handleActionNext();
  }

  void onButtonPauseClick() {
    if (appState == AppState.PLAYING) {
      audioPlayer.pause();
      appState = AppState.PAUSING;
      stopPlayRotation();
      updateStatePause();
    }
  }
}
