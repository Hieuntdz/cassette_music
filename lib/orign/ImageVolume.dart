import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class ImageVolume extends StatefulWidget {
  ImageVolume({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageVolumeState();
  }
}

class ImageVolumeState extends State<ImageVolume> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/bg_volume.png",
      ),
    );
  }
}
