import 'package:flutter/cupertino.dart';

class AppSummary {
  double screenWidth;
  double screenHeight;

  AppSummary(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
