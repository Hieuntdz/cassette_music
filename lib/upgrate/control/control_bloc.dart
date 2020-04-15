import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/model/song.dart';
import 'package:cassettemusic/upgrate/util/data.dart';

class ControlBloc extends BlocBase {
  Equalizer equalizer;
  List<Song> songs;

  ControlBloc() {
    equalizer = new Equalizer(
      bass: Const.bass.def,
      treble: Const.treble.def,
      volume: Const.volume.def,
    );
    songs = new List();
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
