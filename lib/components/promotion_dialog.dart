import 'package:chess/chess.dart' as ch;
import 'package:flutter/material.dart';
import 'package:online_chess/components/svg_piece.dart';

class promotionDialog extends StatelessWidget {
  final bool isWhite;
  final Function(String) onTap;
  const promotionDialog(
      {super.key, required this.isWhite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        height: 400,
        child: SimpleDialog(
          title: const Text("Select promotion piece:"),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final p in [
                  ch.PieceType.QUEEN,
                  ch.PieceType.ROOK,
                  ch.PieceType.BISHOP,
                  ch.PieceType.KNIGHT
                ])
                  InkWell(
                    onTap: () {
                      onTap(p.name);
                      Navigator.pop(context);
                    },
                    child: svgPicture(
                        ch.Piece(p, isWhite ? ch.Color.WHITE : ch.Chess.BLACK)),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
