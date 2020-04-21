import 'package:cassettemusic/orign/model/AudioModel.dart';
import 'package:cassettemusic/upgrate/control/bloc_update.dart';
import 'package:cassettemusic/upgrate/control/tabe_bloc_state.dart';
import 'package:cassettemusic/upgrate/control/tape_event.dart';
import 'package:cassettemusic/upgrate/model/song.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TapeBloc extends Bloc<TapeEvent, TapeBlocState> {
  double curentTime;
  double totalTime;
  Song song;
  AudioModel audioModel;

  TapeBloc() {
    curentTime = 0;
    totalTime = 0;
  }

  @override
  TapeBlocState get initialState => TapeBlocState(BlocUpdate("x"));

  @override
  Stream<TapeBlocState> mapEventToState(TapeEvent event) async* {
    print("TapeBlocState");
    yield TapeBlocState(BlocUpdate("y"));
  }

  void setCurentTime(double current, double total) {
    curentTime = current;
    totalTime = total;
    add(TapeEvent());
  }

  void setAudioModel(AudioModel audioModel) {
    this.audioModel = audioModel;
    add(TapeEvent());
  }

//  void dummy() {
//    song = new Song(
//      name: 'Dummy Song',
//      author: 'Dummy Author',
//      location: 'Dummy Location',
//    );
//    add(TapeEvent())
//  }
}
