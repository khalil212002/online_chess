import 'package:flutter/material.dart';

class LettersRow extends StatelessWidget {
  const LettersRow(
      {super.key,
      required this.size,
      required this.isWhite,
      required this.color});
  final double size;
  final bool isWhite;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final c in isWhite
              ? const {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
              : const {'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a'})
            SizedBox(
                width: size / 1.3,
                height: size / 1.3,
                child: Center(
                  child: Text(
                    c.toString(),
                    style: TextStyle(fontSize: size / 2, color: color),
                  ),
                ))
        ],
      ),
    );
  }
}
