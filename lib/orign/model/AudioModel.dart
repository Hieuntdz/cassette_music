class AudioModel {
  String path;
  String name;
  String album;
  String artist;
  String genre;
  String folder;
  int duartion;

  AudioModel({this.path, this.name, this.album, this.artist, this.genre, this.folder, this.duartion});

  factory AudioModel.fromJson(dynamic json) {
    return AudioModel(
        path: json['path'] as String,
        name: json['name'] as String,
        album: json['album'] as String,
        artist: json['artist'] as String,
        genre: json['genre'] as String,
        folder: json['folder'] as String,
        duartion: json['duartion'] as int);
  }
}
