import 'package:cassettemusic/orign/HexColor.dart';
import 'package:flutter/cupertino.dart';

class VerticalLine extends StatelessWidget {
  final String color;
  final double weight;

  VerticalLine(this.color, this.weight);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: weight,
      color: HexColor(color),
    );
  }
}

class HorizontalLine extends StatelessWidget {
  final String color;
  final double weight;

  HorizontalLine(this.color, this.weight);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: weight,
      height: double.infinity,
      color: HexColor(color),
    );
  }
}
