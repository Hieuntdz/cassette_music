import 'package:cassettemusic/upgrate/util/const.dart';
import 'package:flutter/services.dart';

class NotificationManager {
  MethodChannel _channel;

  NotificationManager() {
    _channel = new MethodChannel(BridgeNative.notificationChanel);
  }

  void show(String title, String author, bool isPlay) {
    Map<String, dynamic> params = new Map();
    params[BridgeNative.notificationParams.paramTitle] = title;
    params[BridgeNative.notificationParams.paramAuthor] = author;
    params[BridgeNative.notificationParams.paramIsPlay] = isPlay;
    _channel.invokeMethod(BridgeNative.notificationMethod.methodShow, params);
  }

  void pause() {
    _channel.invokeMethod(BridgeNative.notificationMethod.methodPause);
  }

  void play() {
    _channel.invokeMethod(BridgeNative.notificationMethod.methodPlay);
  }

  void updateTitle(String title) {
    _channel.invokeMethod(BridgeNative.notificationMethod.methodUpdateTitle);
  }
}
