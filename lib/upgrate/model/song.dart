import 'dart:convert';
import 'dart:io';

import 'package:cassettemusic/orign/model/AudioModel.dart';
import 'package:cassettemusic/upgrate/util/data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SongProvider {
  static const platform = const MethodChannel('CHANNEL_GET_AUDIO_LIST');

  Future<List<AudioModel>> getSong() async {
    final data = await getSongByFlutter();
    List<AudioModel> songs = new List();
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        print(data[i]);
        if (data[i] is File) {
          final item = (data[i] as File);
          final strings = path.dirname(item.path).split('/');
          String location = '';
          if (strings != null && strings.length > 0) {
            location = strings[strings.length - 1];
          }
          songs.add(AudioModel(
            name: path.basename(item.path),
            folder: location,
            path: item.path,
            artist: '',
          ));
        }
      }
    }
    return songs;
  }

  Future<List> getSongByFlutter() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final grant = await Permission.storage.request();
    print(await getApplicationDocumentsDirectory());
    if (grant.isGranted) {
      final files = await FileManager(
        root: Directory('/storage/emulated/0/'),
        filter: SimpleFileFilter(
          fileOnly: true,
          directoryOnly: false,
          hidden: false,
          allowedExtensions: Const.filter,
        ),
      ).walk().toList();
      print(DateTime.now().millisecondsSinceEpoch - now);
      return files;
    }
    return null;
  }

  Future<List> getSongByBrideNative() async {
    List<AudioModel> listAudioModel = new List();
    try {
      String result = await platform.invokeMethod('getAudioList');
      var arrJson = jsonDecode(result) as List;
      List<AudioModel> listSong = arrJson.map((tagJson) => AudioModel.fromJson(tagJson)).toList();
      listAudioModel.addAll(listSong);
      return listSong;
    } on PlatformException catch (e) {}
  }
}

class Song {
  String name;
  String author;
  String location;
  String path;

  Song({
    this.name,
    this.author,
    this.location,
    this.path,
  });
}
