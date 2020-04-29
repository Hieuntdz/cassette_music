import 'package:flutter/cupertino.dart';

import 'hex_color.dart';

class BreakLine extends StatelessWidget {
  final String color;
  final double weight;

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
