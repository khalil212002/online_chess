import 'dart:math';

import 'package:chess/chess.dart' as ch;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_chess/components/loading_text.dart';
import 'package:online_chess/components/num_col_view.dart';
import 'package:online_chess/components/letters_row.dart';
import 'package:online_chess/components/online_board.dart';
import 'package:online_chess/components/promotion_dialog.dart';
import 'package:online_chess/components/svg_piece.dart';
import 'package:online_chess/utils/piece_2_image.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key, required this.game});
  final OnlineBoard game;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  List<ch.Move>? moveOptions;

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
    Color cur = (int.parse(postion[1]) +
                    postion[0].codeUnits.first -
                    'a'.codeUnits.first) %
                2 ==
            0
        ? Colors.white
        : Colors.black;

    if (moveOptions?.any((element) => element.fromAlgebraic == postion) ==
        true) {
      return Color.alphaBlend(Colors.amber.withAlpha(230), cur);
    } else if (moveOptions?.any((element) => element.toAlgebraic == postion) ??
        false) {
      return Color.alphaBlend(
          widget.game.get(postion) == null
              ? Colors.green.withAlpha(230)
              : Colors.red.withAlpha(230),
          cur);
    }
    return cur;
  }

  void _onTap(String position) {
    if (!widget.game.isTurn()) {
      moveOptions = null;
      return;
    }
    ch.Move? moveTo = moveOptions
        ?.where((element) => element.toAlgebraic == position)
        .firstOrNull;
    ch.Move? moveFrom = moveOptions
        ?.where((element) => element.fromAlgebraic == position)
        .firstOrNull;

    if (moveFrom != null) {
      setState(() {
        moveOptions = null;
      });
    } else if (moveTo != null) {
      if (moveTo.flags & ch.Chess.BITS_PROMOTION != 0) {
        showDialog(
            context: context,
            builder: (context) => promotionDialog(
                  isWhite: widget.game.isWhite,
                  onTap: (p0) {
                    setState(() {
                      widget.game.move({
                        'from': moveTo.fromAlgebraic,
                        'to': moveTo.toAlgebraic,
                        'promotion': p0
                      });
                      moveOptions = null;
                    });
                  },
                ));
      } else {
        setState(() {
          widget.game.move(moveTo);
          moveOptions = null;
        });
      }
    } else {
      setState(() {
        moveOptions =
            widget.game.generate_moves(<String, String>{'square': position});
      });
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
              Container(
                color: Theme.of(context).primaryColor,
                width: size * 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LoadingText(
                      text: widget.game.isTurn() ? "Your Turn" : "",
                      style:
                          const TextStyle(fontSize: 200, color: Colors.green),
                    ),
                    LoadingText(
                      text: widget.game.isMate() ? "Mate" : "",
                      style: const TextStyle(fontSize: 200, color: Colors.red),
                    )
                  ],
                ),
              ),
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
