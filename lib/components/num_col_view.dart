import 'package:flutter/material.dart';

class NumColView extends StatelessWidget {
  const NumColView(
      {super.key, required this.color, required this.num, required this.size});
  final double size;
  final Color color;
  final int num;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size / 1.3,
      height: size / 1.3,
      child: Center(
        child: Text(
          num.toString(),
          style: TextStyle(fontSize: size / 2, color: color),
        ),
      ),
    );
  }
}
