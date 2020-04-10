//class AudioController {
//  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
//  AudioController() {
//    audioPlayer.startHeadlessService();
//  }
//
//  void playLocal(String localPath) async {
//    await audioPlayer.play(localPath, isLocal: true);
//  }
//
//  void pause() async {
//    await audioPlayer.pause();
//  }
//
//  Future<void> stop() async {
//    await audioPlayer.stop();
//  }
//}
