import 'dart:math';

import 'package:chess/chess.dart' as ch;
import 'package:flutter/material.dart';
import 'package:online_chess/components/num_col_view.dart';
import 'package:online_chess/components/letters_row.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard(
      {super.key,
      required this.isWhite,
      required this.pgn,
      required this.moveFun});
  final bool isWhite;
  final String pgn;
  final Function(String) moveFun;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late final ch.Chess game;
  String? wantToMove;
  List<String>? canMoveTo;
  static const positionsColor = Color.fromARGB(255, 168, 160, 157);

  @override
  void initState() {
    super.initState();
    game = ch.Chess();
  }

  Color _getSqaureColor(String postion) {
    if (wantToMove == postion) {
      return Colors.amber;
    } else if (canMoveTo?.contains(postion) ?? false) {
      return Colors.green;
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
    if (game.turn == (widget.isWhite ? ch.Color.WHITE : ch.Color.BLACK)) {
      if (wantToMove == position) {
        setState(() {
          wantToMove = null;
          canMoveTo = null;
        });
      } else if (game.get(position)?.color ==
          (widget.isWhite ? ch.Color.WHITE : ch.Color.BLACK)) {
        final moves = game.generate_moves(<String, String>{'square': position});

        setState(() {
          wantToMove = position;
          canMoveTo = moves.map<String>((m) => m.toAlgebraic).toList();
        });
      } else if (canMoveTo?.contains(position) ?? false) {
        setState(() {
          game.move(<String, String>{'from': wantToMove ?? '', 'to': position});
          final move = game.pgn().split(' ').last;
          widget.moveFun(move);
          wantToMove = null;
          canMoveTo = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    game.load_pgn(widget.pgn);
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
                  size: size, isWhite: widget.isWhite, color: positionsColor),
              for (final r in !widget.isWhite
                  ? const {1, 2, 3, 4, 5, 6, 7, 8}
                  : const {8, 7, 6, 5, 4, 3, 2, 1})
                Row(
                  children: [
                    NumColView(size: size, color: positionsColor, num: r),
                    for (final c in widget.isWhite
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
                            final piece = game.get("$c$r");
                            return Text(
                              (piece?.color == ch.Color.WHITE
                                      ? piece?.type.name.toUpperCase()
                                      : piece?.type.name.toLowerCase()) ??
                                  '',
                              style: TextStyle(
                                  fontSize: size / 2, color: Colors.red),
                            );
                          }),
                        ),
                      ),
                    NumColView(color: positionsColor, num: r, size: size),
                  ],
                ),
              LettersRow(
                color: positionsColor,
                isWhite: widget.isWhite,
                size: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
