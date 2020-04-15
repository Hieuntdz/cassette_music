import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/upgrate/model/song.dart';

class TapeBloc extends BlocBase {
  int percent;
  Song song;

  TapeBloc() {
    percent = 0;
    song = new Song(
      name: '',
      author: '',
      location: '',
    );
  }

  void setPercent(int value) {
    percent = value;
    notifyListeners();
  }

  void setSong(Song value) {
    song = value;
    notifyListeners();
  }

  void dummy() {
    song = new Song(
      name: 'Dummy Song',
      author: 'Dummy Author',
      location: 'Dummy Location',
    );
    notifyListeners();
  }
}
