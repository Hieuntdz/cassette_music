import 'package:flutter/cupertino.dart';

import 'ControllerType.dart';

class ImageController extends StatefulWidget {
  String image;
  ControllerType controllerType;
  final void Function(ControllerType) callback;
  final void Function(ControllerType, int timeLongPress) longPressEndCallBack;
  final void Function(ControllerType) longPressStartCallBack;

  ImageController(
      this.image, this.controllerType, this.callback, this.longPressEndCallBack, this.longPressStartCallBack);

  @override
  State<StatefulWidget> createState() {
    return ImageControllerSate(controllerType, callback, longPressEndCallBack, longPressStartCallBack);
  }
}

class ImageControllerSate extends State<ImageController> {
  String TAG = "ImageControllerTAG";

  ControllerType controllerType;
  final void Function(ControllerType) callback;
  final void Function(ControllerType, int timeLongPress) longPressEndCallBack;
  final void Function(ControllerType) longPressStartCallBack;
  int startLongPress;

  ImageControllerSate(this.controllerType, this.callback, this.longPressEndCallBack, this.longPressStartCallBack);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Image.asset(widget.image, fit: BoxFit.fill),
        onTap: () {
          print(TAG + " onTAP");
          callback.call(controllerType);
        },
        onLongPress: () {
          print(TAG + " onLongPress");
        },
        onLongPressStart: (LongPressStartDetails details) {
          if (controllerType == ControllerType.BACK || controllerType == ControllerType.NEXT) {
            startLongPress = new DateTime.now().millisecondsSinceEpoch;
            longPressStartCallBack(controllerType);
          }
        },
        onLongPressEnd: (LongPressEndDetails detail) {
          if (controllerType == ControllerType.BACK || controllerType == ControllerType.NEXT) {
            int currentTime = new DateTime.now().millisecondsSinceEpoch;
            longPressEndCallBack(controllerType, currentTime - startLongPress);
          }
          print(TAG + "LongPressEndDetails " + detail.toString());
        },
      ),
    );
  }
}
