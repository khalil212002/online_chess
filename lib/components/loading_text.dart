import 'dart:async';

import 'package:flutter/material.dart';

class LoadingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const LoadingText({super.key, required this.text, this.style});

  @override
  State<LoadingText> createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText> {
  var opicity = 0;
  bool rise = true;
  late Timer t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(milliseconds: 15), (x) {
      setState(() {
        opicity = opicity + (rise ? 1 : -1);
        if (opicity == 100) {
          rise = false;
        } else if (opicity == 3) {
          rise = true;
        }
      });
    });
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opicity / 100.0,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}
