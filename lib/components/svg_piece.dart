import 'package:chess/chess.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_chess/utils/piece_2_image.dart';

SvgPicture svgPicture(Piece p) {
  return SvgPicture.asset(piece2Image(p));
}
