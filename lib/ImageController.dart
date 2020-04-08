import 'package:flutter/cupertino.dart';

import 'ControllerType.dart';

class ImageController extends StatefulWidget {
  String image;
  ControllerType controllerType;
  final void Function(ControllerType) callback;

  ImageController(this.image, this.controllerType, this.callback);

  @override
  State<StatefulWidget> createState() {
    return ImageControllerSate(controllerType, callback);
  }
}

class ImageControllerSate extends State<ImageController> {
  ControllerType controllerType;
  final void Function(ControllerType) callback;

  ImageControllerSate(this.controllerType, this.callback);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        child: Image.asset(widget.image, fit: BoxFit.fill),
        onTap: () {
          callback.call(controllerType);
        },
      ),
    );
  }
}
