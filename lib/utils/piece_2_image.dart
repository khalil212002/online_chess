import 'package:chess/chess.dart';

String piece2Image(Piece p) {
  if (p.type == PieceType.PAWN) {
    return p.color == Color.WHITE ? 'pieces/wP.svg' : 'pieces/bP.svg';
  } else if (p.type == PieceType.BISHOP) {
    return p.color == Color.WHITE ? 'pieces/wB.svg' : 'pieces/bB.svg';
  } else if (p.type == PieceType.ROOK) {
    return p.color == Color.WHITE ? 'pieces/wR.svg' : 'pieces/bR.svg';
  } else if (p.type == PieceType.KNIGHT) {
    return p.color == Color.WHITE ? 'pieces/wN.svg' : 'pieces/bN.svg';
  } else if (p.type == PieceType.QUEEN) {
    return p.color == Color.WHITE ? 'pieces/wQ.svg' : 'pieces/bQ.svg';
  } else {
    return p.color == Color.WHITE ? 'pieces/wK.svg' : 'pieces/bK.svg';
  }
}
