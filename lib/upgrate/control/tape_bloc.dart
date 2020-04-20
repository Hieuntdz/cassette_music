import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/orign/model/AudioModel.dart';
import 'package:cassettemusic/upgrate/model/song.dart';

class TapeBloc extends BlocBase {
  double curentTime;
  double totalTime;
  Song song;
  AudioModel audioModel;

  TapeBloc() {
    curentTime = 0;
    totalTime = 0;
  }

  void setCurentTime(double current, double total) {
    curentTime = current;
    totalTime = total;
    notifyListeners();
  }

  void setSong(Song value) {
    song = value;
    notifyListeners();
  }

  void setAudioModel(AudioModel audioModel) {
    this.audioModel = audioModel;
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
