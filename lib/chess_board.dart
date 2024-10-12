import 'dart:math';

import 'package:chess/chess.dart' as ch;
import 'package:flutter/material.dart';
import 'package:online_chess/components/num_col_view.dart';
import 'package:online_chess/components/letters_row.dart';
import 'package:online_chess/components/online_board.dart';
import 'package:online_chess/components/svg_piece.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key, required this.game});
  final OnlineBoard game;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  String? wantToMove;
  List<String>? canMoveTo;

  @override
  void initState() {
    super.initState();
    widget.game.init();
    widget.game.setListener(() {
      if (context.mounted) {
        setState(() {
          widget.game;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.game.dispose();
    super.dispose();
  }

  Color _getSqaureColor(String postion) {
    if (wantToMove == postion) {
      return Colors.amber;
    } else if (canMoveTo?.contains(postion) ?? false) {
      return widget.game.get(postion) == null ? Colors.green : Colors.red;
    }
    return (int.parse(postion[1]) +
                    postion[0].codeUnits.first -
                    'a'.codeUnits.first) %
                2 ==
            0
        ? Colors.white
        : Colors.black;
  }

  void _onTap(String position) {
    if (widget.game.turn ==
        (widget.game.isWhite ? ch.Color.WHITE : ch.Color.BLACK)) {
      if (wantToMove == position) {
        setState(() {
          wantToMove = null;
          canMoveTo = null;
        });
      } else if (widget.game.get(position)?.color ==
          (widget.game.isWhite ? ch.Color.WHITE : ch.Color.BLACK)) {
        final moves =
            widget.game.generate_moves(<String, String>{'square': position});

        setState(() {
          wantToMove = position;
          canMoveTo = moves.map<String>((m) => m.toAlgebraic).toList();
        });
      } else if (canMoveTo?.contains(position) ?? false) {
        setState(() {
          widget.game
              .move(<String, String>{'from': wantToMove ?? '', 'to': position});
          wantToMove = null;
          canMoveTo = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final win = MediaQuery.of(context).size;
    final size = min(win.width, win.height);
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          color: const Color.fromARGB(255, 41, 24, 22),
          child: Column(
            children: [
              LettersRow(
                  size: size,
                  isWhite: widget.game.isWhite,
                  color: Colors.white),
              for (final r in !widget.game.isWhite
                  ? const {1, 2, 3, 4, 5, 6, 7, 8}
                  : const {8, 7, 6, 5, 4, 3, 2, 1})
                Row(
                  children: [
                    NumColView(size: size, color: Colors.white, num: r),
                    for (final c in widget.game.isWhite
                        ? const {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
                        : const {'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a'})
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => _onTap("$c$r"),
                        child: Container(
                          width: size,
                          height: size,
                          color: _getSqaureColor("$c$r"),
                          child: Builder(builder: (context) {
                            final piece = widget.game.get("$c$r");
                            if (piece != null) {
                              return svgPicture(piece);
                            } else {
                              return Container();
                            }
                          }),
                        ),
                      ),
                    NumColView(color: Colors.white, num: r, size: size),
                  ],
                ),
              LettersRow(
                color: Colors.white,
                isWhite: widget.game.isWhite,
                size: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
