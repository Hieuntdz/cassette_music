import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/orign/audioplayer/audioplayers.dart';
import 'package:cassettemusic/upgrate/control/tape_bloc.dart';
import 'package:cassettemusic/upgrate/model/song.dart';
import 'package:cassettemusic/upgrate/util/data.dart';

class ControlBloc extends BlocBase {
  TapeBloc tapeBloc;
  SongProvider songProvider;

  AudioControl audioControl;
  Equalizer equalizer;
  List<Song> songs;
  int currentIndex;

  ButtonState rewind, play, forward, pause, stop, eject;

  ControlBloc(TapeBloc tapeBloc) {
    this.tapeBloc = tapeBloc;

    audioControl = new AudioControl();
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

  void setBass(int value) {
    equalizer.bass = value;
    equalizer.verify();
    notifyListeners();
  }

  void setTreble(int value) {
    equalizer.treble = value;
    equalizer.verify();
    notifyListeners();
  }

  void setVolume(int value) {
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

  tapButton(ButtonState state) {
    state.trigger();
    notifyListeners();
  }

  tapCancel(ButtonState state) {
    if (state == pause && play.isPressed == false) {
      state.nonPress();
    } else if (state == stop) {
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
  }
}

class Equalizer {
  int bass;
  int treble;
  int volume;

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

class AudioControl {
}
