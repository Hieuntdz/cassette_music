class AudioModel {
  String path;
  String name;
  String album;
  String artist;
  String genre;
  String folder;
  int duartion;

  AudioModel(this.path, this.name, this.album, this.artist, this.genre, this.folder, this.duartion);

  factory AudioModel.fromJson(dynamic json) {
    return AudioModel(json['path'] as String, json['name'] as String, json['album'] as String, json['artist'] as String,
        json['genre'] as String, json['folder'] as String, json['duartion'] as int);
  }
}
