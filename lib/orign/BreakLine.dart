import 'package:flutter/cupertino.dart';

import 'HexColor.dart';

class BreakLine extends StatelessWidget {
  String color;
  double weight;

  BreakLine(this.color, this.weight);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: weight,
      color: HexColor(color),
    );
  }
}
