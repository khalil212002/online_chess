import 'package:chess/chess.dart';

String piece2Image(Piece p) {
  if (p.type == PieceType.PAWN) {
    return p.color == Color.WHITE
        ? 'assets/pieces/wP.svg'
        : 'assets/pieces/bP.svg';
  } else if (p.type == PieceType.BISHOP) {
    return p.color == Color.WHITE
        ? 'assets/pieces/wB.svg'
        : 'assets/pieces/bB.svg';
  } else if (p.type == PieceType.ROOK) {
    return p.color == Color.WHITE
        ? 'assets/pieces/wR.svg'
        : 'assets/pieces/bR.svg';
  } else if (p.type == PieceType.KNIGHT) {
    return p.color == Color.WHITE
        ? 'assets/pieces/wN.svg'
        : 'assets/pieces/bN.svg';
  } else if (p.type == PieceType.QUEEN) {
    return p.color == Color.WHITE
        ? 'assets/pieces/wQ.svg'
        : 'assets/pieces/bQ.svg';
  } else {
    return p.color == Color.WHITE
        ? 'assets/pieces/wK.svg'
        : 'assets/pieces/bK.svg';
  }
}
