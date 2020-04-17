import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/orign/audioplayer/audioplayers.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/model/song.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/animation.dart';

class ControlBloc extends BlocBase implements AudioCallback {
  TapeBloc tapeBloc;
  SongProvider songProvider;

  AudioControl audioControl;
  Equalizer equalizer;
  List<Song> songs;
  int currentIndex;

  ButtonState rewind, play, forward, pause, stop, eject;

  ControlBloc(TapeBloc tapeBloc) {
    this.tapeBloc = tapeBloc;

    audioControl = new AudioControl(this);
    songProvider = new SongProvider();
    equalizer = new Equalizer(
      bass: Const.bass.def,
      treble: Const.treble.def,
      volume: Const.volume.def,
    );
    songs = new List();

    rewind = ButtonState(0, Images.rewind, false);
    play = ButtonState(1, Images.play, true);
    forward = ButtonState(2, Images.forward, false);
    pause = ButtonState(3, Images.pause, true);
    stop = ButtonState(4, Images.stop, false);
    eject = ButtonState(5, Images.eject, false);
  }

  setAnimationController(AnimationController animationController) {
    audioControl.setAnimationController(animationController);
  }

  @override
  void dispose() {
    super.dispose();
    audioControl.dispose();
  }

  void setBass(double value) {
    equalizer.bass = value;
    equalizer.verify();
    notifyListeners();
  }

  void setTreble(double value) {
    equalizer.treble = value;
    equalizer.verify();
    notifyListeners();
  }

  void setVolume(double value) {
    equalizer.treble = value;
    equalizer.verify();
    notifyListeners();
  }

  void increaseVolume(int value) {
    equalizer.volume++;
    equalizer.verify();
    notifyListeners();
  }

  void decreaseVolume(int value) {
    equalizer.volume--;
    equalizer.verify();
    notifyListeners();
  }

  setSongs(List<Song> value) {
    songs.clear();
    songs.addAll(value);
    notifyListeners();
  }

  addSong(Song value) {
    songs.add(value);
    notifyListeners();
  }

  getSongs() async {
    songs = await songProvider.getSong();
    currentIndex = 0;
    if (songs != null && songs.length > 0) {
      tapeBloc.setSong(songs[currentIndex]);
    }
    notifyListeners();
  }

  getPreviousSong() {
    currentIndex--;
    if (currentIndex < 0) {
      currentIndex = 0;
    }
    if (songs != null && songs.length > 0) {
      tapeBloc.setSong(songs[currentIndex]);
    }
    notifyListeners();
  }

  getNextSong() {
    currentIndex++;
    if (currentIndex > songs.length - 1) {
      currentIndex = songs.length - 1;
    }
    if (songs != null && songs.length > 0) {
      tapeBloc.setSong(songs[currentIndex]);
    }
    notifyListeners();
  }

  longPress(ButtonState state) {
    if (state == rewind) {
      // TODO Tua bài như nào thì tua
    } else if (state == forward) {
      // TODO Tua bài như nào thì tua
    } else {
      // Những thằng nào quan tâm thì thêm vào
    }
  }

  tapButton(ButtonState state) {
    if (state == play && audioControl.state == AudioState.pause) {
      // Trường hợp ấn play khi pause đang ấn
      play.press();
      pause.nonPress();
    } else if (state == play &&
        (audioControl.state == AudioState.play ||
            audioControl.state == AudioState.resume)) {
      // chả làm gì cả, tắt thế đéo nào được, pause với stop chứ
    } else {
      state.trigger();
    }
    notifyListeners();
  }

  tapCancel(ButtonState state, bool isLongPress) {
    if (state == pause &&
        (audioControl.state == AudioState.prepare ||
            audioControl.state == AudioState.pause ||
            audioControl.state == AudioState.stop)) {
      // Trường hợp ấn pause khi play không được ấn
      state.nonPress();
    } else if (state == stop) {
      // Trường hợp ấn stop
      rewind.nonPress();
      play.nonPress();
      forward.nonPress();
      pause.nonPress();
      stop.nonPress();
      eject.nonPress();
    } else {
      state.cancel();
    }
    notifyListeners();

    if (state == rewind) {
      if (isLongPress) {
        // TODO kill cái gì khi tạo trong long press
      } else {
        // TODO kill cái gì thì tạo trong tap
      }
    } else if (state == forward) {
      if (isLongPress) {
        // TODO kill cái gì khi tạo trong long press
      } else {
        // TODO kill cái gì thì tạo trong tap
      }
    } else if (state == play) {
      if (audioControl.state == AudioState.pause) {
        audioControl.resume();
      } else if (audioControl.state == AudioState.prepare ||
          audioControl.state == AudioState.stop) {
        if (tapeBloc.song != null) {
          audioControl.play(tapeBloc.song.path);
        } else {
          print('Error song ?');
        }
      }
    } else if (state == pause) {
      if (state.isPressed) {
        audioControl.pause();
      } else {
        audioControl.resume();
      }
    } else if (state == stop) {
//      audioControl.stop();
      // Stop trên casset bản chất chỉ là pause
      audioControl.pause();
    } else if (state == eject) {
      // TODO : mở ra cái chọn bài
    }
  }

  @override
  updateDuration(int percent) {
    tapeBloc.setPercent(percent);
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
  updateDuration(int percent) {}
}
class AudioControl {
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription complete;
  StreamSubscription error;
  StreamSubscription duration;
  Duration audiDuration;
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
      audiDuration = event;
      final total = await audioPlayer.getDuration();
      final percent = (audiDuration.inMilliseconds / total * 100).toInt();
      if(currentPercent != percent) {
        currentPercent = percent;
      }
      callback.updateDuration(currentPercent);
    });
  }

  setAnimationController(AnimationController animationController) {
    this.animationController = animationController;
  }

  play(String path) async {
    print('AudioControl play');
    state = AudioState.play;
    if(animationController != null) animationController.repeat();
    if (audioPlayer.isLocalUrl(path)) {
      return await audioPlayer.play(path, isLocal: true);
    } else {
      return await audioPlayer.play(path, isLocal: false);
    }
  }

  resume() async {
    print('AudioControl resume');
    state = AudioState.resume;
    if(animationController != null) animationController.repeat();
    return await audioPlayer.resume();
  }

  pause() async {
    print('AudioControl pause');
    state = AudioState.pause;
    if(animationController != null)  animationController.stop();
    return await audioPlayer.pause();
  }

  stop() async {
    print('AudioControl stop');
    state = AudioState.stop;
    if(animationController != null)  animationController.stop();
    return await audioPlayer.stop();
  }

  dispose() {
    print('AudioControl dispose');
    if(animationController != null)  animationController.stop();
    if (complete != null) complete.cancel();
    if (error != null) error.cancel();
    if (duration != null) duration.cancel();
  }
}
