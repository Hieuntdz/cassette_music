class AudioModel {
  String path;
  String name;
  String album;
  String artist;
  String genre;
  String folder;

  AudioModel(this.path, this.name, this.album, this.artist, this.genre, this.folder);

  factory AudioModel.fromJson(dynamic json) {
    return AudioModel(json['path'] as String, json['name'] as String, json['album'] as String, json['artist'] as String,
        json['genre'] as String, json['folder'] as String);
  }
}
