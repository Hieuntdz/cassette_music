import 'dart:async';

import 'package:cassettemusic/orign/MenuScreen.dart';
import 'package:cassettemusic/orign/audioplayer/audioplayers.dart';
import 'package:cassettemusic/orign/model/AudioModel.dart';
import 'package:cassettemusic/upgrate/control/ControllState.dart';
import 'package:cassettemusic/upgrate/control/bloc_update.dart';
import 'package:cassettemusic/upgrate/control/control_event.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/model/song.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlBloc extends Bloc<ControllEvent, ControllBlocState> implements AudioCallback {
  BuildContext context;
  TapeBloc tapeBloc;
  SongProvider songProvider;

  AudioControl audioControl;
  Equalizer equalizer;
  List<AudioModel> listAudioModel = new List();
  List<AudioModel> listAudioModelContent = new List();
  int currentIndex;
  int timeLongPressStart;
  ButtonState rewind, play, forward, pause, stop, eject;
  EqualizerState bassControll, trebbleControll;

  double totalTime = 0; // tong time list nhac
  double currentTime = 0; // time hien tai da play dc

  ControlBloc(TapeBloc tapeBloc) {
    this.tapeBloc = tapeBloc;

    audioControl = new AudioControl(this);
    songProvider = new SongProvider();
    equalizer = new Equalizer(
      bass: Const.bass.def,
      treble: Const.treble.def,
      volume: Const.volume.def,
    );
    listAudioModel = new List();
    listAudioModelContent = new List();

    rewind = ButtonState(0, Images.rewind, false);
    play = ButtonState(1, Images.play, true);
    forward = ButtonState(2, Images.forward, false);
    pause = ButtonState(3, Images.pause, true);
    stop = ButtonState(4, Images.stop, false);
    eject = ButtonState(5, Images.eject, false);

    bassControll = EqualizerState(0, "B", equalizer.bass);
    trebbleControll = EqualizerState(1, "T", equalizer.treble);
  }

  update() {
    add(ControllEvent());
  }

  @override
  ControllBlocState get initialState => ControllBlocState(BlocUpdate("a"));

  @override
  Stream<ControllBlocState> mapEventToState(ControllEvent event) async* {
    yield ControllBlocState(BlocUpdate("x"));
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  setAnimationController(AnimationController animationController) {
    audioControl.setAnimationController(animationController);
  }

  @override
  void dispose() {
    audioControl.dispose();
  }

  void setTimeLongPressStart(int time) {
    audioControl.audioPlayer.pause();
    timeLongPressStart = time;
  }

  void setBass(double value) {
    audioControl.setBass(value);
    equalizer.bass = value;
    equalizer.verify();
    update();
  }

  void setTreble(double value) {
    audioControl.setTrebble(value);
    equalizer.treble = value;
    equalizer.verify();
    update();
  }

  void onEqualizerChange(EqualizerState state, double value) {
    state.progress = value;
    if (state == bassControll) {
      setBass(value);
    } else {
      setTreble(value);
    }
  }

  void setVolume(double value) {
    equalizer.volume = value;
    equalizer.verify();
    audioControl.setVolume(value);
  }

  getSongs() async {
    listAudioModel = await songProvider.getSongByBrideNative();
    listAudioModelContent.addAll(listAudioModel);
    currentIndex = 0;
    if (listAudioModelContent != null && listAudioModelContent.length > 0) {
      tapeBloc.setAudioModel(listAudioModelContent[currentIndex]);
    }
    for (AudioModel audioModel in listAudioModelContent) {
      totalTime += audioModel.duartion;
    }
    tapeBloc.setCurentTime(0, totalTime);

    update();
  }

  getPreviousSong() {
    currentIndex--;
    if (currentIndex < 0) {
      currentIndex = listAudioModelContent.length - 1;
    }
    //TH ko co bai nao
    if (currentIndex < 0) {
      currentIndex = 0;
    }

    if (listAudioModelContent.length > currentIndex && currentIndex >= 0) {
      currentTime = 0;
      for (int i = 0; i < currentIndex; i++) {
        AudioModel audioModel = listAudioModelContent[i];
        currentTime += audioModel.duartion;
      }
      tapeBloc.setCurentTime(currentTime, totalTime);
      tapeBloc.setAudioModel(listAudioModelContent[currentIndex]);
    }

    update();
  }

  getNextSong() {
    currentIndex++;
    if (currentIndex >= listAudioModelContent.length) {
      currentIndex = 0;
    }

    if (listAudioModelContent.length > currentIndex) {
      currentTime = 0;
      for (int i = 0; i < currentIndex; i++) {
        AudioModel audioModel = listAudioModelContent[i];
        currentTime += audioModel.duartion;
      }
      tapeBloc.setCurentTime(currentTime, totalTime);
      tapeBloc.setAudioModel(listAudioModelContent[currentIndex]);
    }

    update();
  }

  longPress(ButtonState state, int duration) {
    if (tapeBloc.audioModel == null) {
      return;
    }
    if (state == rewind) {
      if (audioControl.state == AudioState.play) {
        audioControl.playFromDuration(
            tapeBloc.audioModel.path, Duration(milliseconds: audioControl.audioDuration.inMilliseconds - duration));
      } else {
        audioControl.seek(Duration(milliseconds: audioControl.audioDuration.inMilliseconds - duration));
      }
    } else if (state == forward) {
      if (audioControl.state == AudioState.play) {
        audioControl.playFromDuration(
            tapeBloc.audioModel.path, Duration(milliseconds: audioControl.audioDuration.inMilliseconds + duration));
      } else {
        audioControl.seek(Duration(milliseconds: audioControl.audioDuration.inMilliseconds + duration));
      }
    } else {
      // Những thằng nào quan tâm thì thêm vào
    }
  }

  tapButton(ButtonState state) {
    if (state == play && audioControl.state == AudioState.pause) {
      // Trường hợp ấn play khi pause đang ấn      play.press();
      play.press();
      pause.nonPress();
    } else if (state == play && (audioControl.state == AudioState.play || audioControl.state == AudioState.resume)) {
      // chả làm gì cả, tắt thế đéo nào được, pause với stop chứ
    } else {
      state.trigger();
    }
    add(ControllEvent());
  }

  tapCancel(ButtonState state, bool isLongPress, int time) {
    if (state == stop) {
      // Trường hợp ấn stop
      rewind.nonPress();
      play.nonPress();
      forward.nonPress();
      pause.nonPress();
      stop.nonPress();
      eject.nonPress();
    } else if (state == rewind || state == forward) {
      state.cancel();
    }

    add(ControllEvent());

    if (state == rewind) {
      if (isLongPress) {
        longPress(state, time - timeLongPressStart);
      } else {
        getPreviousSong();
        if (tapeBloc.audioModel != null && audioControl.state == AudioState.play) {
          audioControl.play(tapeBloc.audioModel.path);
        }
      }
    } else if (state == forward) {
      if (isLongPress) {
        longPress(state, time - timeLongPressStart);
      } else {
        getNextSong();
        if (tapeBloc.audioModel != null && audioControl.state == AudioState.play) {
          audioControl.play(tapeBloc.audioModel.path);
        }
      }
    } else if (state == play) {
//      if (audioControl.state == AudioState.pause) {
//        audioControl.resume();
//      } else if (audioControl.state == AudioState.prepare || audioControl.state == AudioState.stop) {
      if (tapeBloc.audioModel != null) {
        audioControl.play(tapeBloc.audioModel.path);
      } else {
        print('Error song ?');
      }
//      }
    } else if (state == pause) {
      if (state.isPressed) {
        audioControl.pause();
      } else if (audioControl.state == AudioState.pause) {
        audioControl.resume();
      }
    } else if (state == stop) {
//      audioControl.stop();
      // Stop trên casset bản chất chỉ là pause
      audioControl.pause();
    } else if (state == eject) {
      navigateToMenuScreen(context);
    }
  }

  Future navigateToMenuScreen(context) async {
    Map result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuScreen(
                  listAudioModel: listAudioModel,
                )));

    eject.nonPress();
    update();

    if (result == null) {
      return;
    }

    String type = result[MenuScreen.KEY_TYPE];
    int pos = result[MenuScreen.KEY_POS];
    String value = result[MenuScreen.KEY_VALUE];
    if (type.isNotEmpty && type == MenuScreen.DANH_SACH) {
      listAudioModelContent.clear();
      listAudioModelContent.addAll(listAudioModel);
      currentIndex = pos;
      totalTime = 0;
      currentTime = 0;
      for (int i = 0; i < listAudioModelContent.length; i++) {
        AudioModel audioModel = listAudioModelContent[i];
        totalTime += audioModel.duartion;
        if (i <= currentIndex) {
          currentTime += audioModel.duartion;
        }
      }
    } else if (type.isNotEmpty && type == MenuScreen.ARTIST) {
      listAudioModelContent.clear();
      currentIndex = 0;
      for (AudioModel audioModel in listAudioModel) {
        if (audioModel.artist == value) {
          listAudioModelContent.add(audioModel);
        }
      }

      totalTime = 0;
      currentTime = 0;
      for (int i = 0; i < listAudioModelContent.length; i++) {
        AudioModel audioModel = listAudioModelContent[i];
        totalTime += audioModel.duartion;
      }
    } else if (type.isNotEmpty && type == MenuScreen.FOLDER) {
      listAudioModelContent.clear();
      currentIndex = 0;
      for (AudioModel audioModel in listAudioModel) {
        if (audioModel.folder == value) {
          listAudioModelContent.add(audioModel);
        }
      }

      totalTime = 0;
      currentTime = 0;
      for (int i = 0; i < listAudioModelContent.length; i++) {
        AudioModel audioModel = listAudioModelContent[i];
        totalTime += audioModel.duartion;
      }
    }
    if (listAudioModelContent.length > currentIndex) {
      tapeBloc.setAudioModel(listAudioModelContent[currentIndex]);
      tapeBloc.setCurentTime(currentTime, totalTime);
    }

    tapCancel(stop, false, 0);
  }

  @override
  onDurationChange(int duration) {
    print("onDurationChange value :  $duration");
    print("onDurationChange currentTime :  $currentTime  total time : $totalTime");
    tapeBloc.setCurentTime(currentTime + duration, totalTime);
  }
}

class Equalizer {
  double bass;
  double treble;
  double volume;

  Equalizer({
    this.bass,
    this.treble,
    this.volume,
  });

  verify() {
    if (volume < Const.volume.min)
      volume = Const.volume.min;
    else if (volume > Const.volume.max) volume = Const.volume.max;

    if (bass < Const.bass.min)
      bass = Const.bass.min;
    else if (bass > Const.bass.max) bass = Const.bass.max;

    if (treble < Const.treble.min)
      treble = Const.treble.min;
    else if (treble > Const.treble.max) treble = Const.treble.max;
  }
}

class EqualizerState {
  int id;
  String text;
  double progress;

  EqualizerState(this.id, this.text, this.progress);
}

class ButtonState {
  int id;
  String currentBackground;
  String currentIcon;
  bool isPressed;
  ButtonData data;
  bool isHasPressState;

  ButtonState(int id, ButtonData data, bool isHasPressState) {
    this.data = data;
    this.isHasPressState = isHasPressState;
    isPressed = false;
    currentBackground = data.background;
    currentIcon = data.icon;
  }

  trigger() {
    isPressed = !isPressed;
    if (isPressed) {
      press();
    } else {
      nonPress();
    }
  }

  cancel() {
    if (!isHasPressState) {
      nonPress();
    }
  }

  press() {
    isPressed = true;
    currentBackground = data.backgroundPressed;
    currentIcon = data.iconPressed;
  }

  nonPress() {
    isPressed = false;
    currentBackground = data.background;
    currentIcon = data.icon;
  }
}

enum AudioState { prepare, play, resume, pause, stop }

class AudioCallback {
  onDurationChange(int percent) {}
}

class AudioControl {
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription complete;
  StreamSubscription error;
  StreamSubscription duration;
  Duration audioDuration;
  AudioState state;
  AudioCallback callback;
  AnimationController animationController;
  int currentPercent;

  AudioControl(AudioCallback callback) {
    this.callback = callback;

    AudioPlayer.logEnabled = Const.isLog;
    state = AudioState.prepare;
    currentPercent = 0;

    audioPlayer = AudioPlayer(
      playerId: 'audio',
//      mode: PlayerMode.LOW_LATENCY,
    );

//    audioPlayer.setBass(Const.bass.def);
//    audioPlayer.setTreble(Const.treble.def);
//    audioPlayer.setVolume(Const.volume.def);

    complete = audioPlayer.onPlayerCompletion.listen((event) {
      print('AudioControl complete');
    });
    error = audioPlayer.onPlayerError.listen((msg) {
      print('AudioControl error $msg');
    });
    duration = audioPlayer.onAudioPositionChanged.listen((event) async {
      print('AudioControl duration change $event');
      audioDuration = event;
      final total = await audioPlayer.getDuration();
      final percent = (audioDuration.inMilliseconds / total * 100).toInt();
      if (currentPercent != percent) {
        currentPercent = percent;
        callback.onDurationChange(audioDuration.inMilliseconds);
      }
    });
  }

  setAnimationController(AnimationController animationController) {
    this.animationController = animationController;
  }

  playFromDuration(String path, Duration duration) async {
    print('playFromDuration play');
    state = AudioState.play;
    if (animationController != null) animationController.repeat();
    if (audioPlayer.isLocalUrl(path)) {
      int result = await audioPlayer.play(path, isLocal: true, position: duration);
      print("playFromDuration result : $result");
    } else {
      await audioPlayer.play(path, isLocal: false, position: duration);
    }
  }

  play(String path) async {
    print('AudioControl play');
    state = AudioState.play;
    if (animationController != null) animationController.repeat();
    if (audioPlayer.isLocalUrl(path)) {
      return await audioPlayer.play(path, isLocal: true);
    } else {
      return await audioPlayer.play(path, isLocal: false);
    }
  }

  seek(Duration duration) {
    audioPlayer.seek(duration);
  }

  resume() async {
    print('AudioControl resume');
    state = AudioState.resume;
    if (animationController != null) animationController.repeat();
    return await audioPlayer.resume();
  }

  pause() async {
    print('AudioControl pause');
    state = AudioState.pause;
    if (animationController != null) animationController.stop();
    return await audioPlayer.pause();
  }

  stop() async {
    print('AudioControl stop');
    state = AudioState.stop;
    if (animationController != null) animationController.stop();
    return await audioPlayer.stop();
  }

  void setBass(double bass) {
    audioPlayer.setBass(bass / Const.bass.max);
  }

  void setTrebble(double trebble) {
    audioPlayer.setBass(trebble / Const.treble.max);
  }

  void setVolume(double volume) {
    audioPlayer.setVolume(volume);
  }

  dispose() {
    print('AudioControl dispose');
    if (animationController != null) animationController.stop();
    if (complete != null) complete.cancel();
    if (error != null) error.cancel();
    if (duration != null) duration.cancel();
  }
}
