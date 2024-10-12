import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_chess/chess_board.dart';
import 'package:online_chess/components/online_board.dart';

class BoardLoader extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> ref;
  late final OnlineBoard game;
  BoardLoader({super.key, required this.ref}) {
    game = OnlineBoard(doc: ref);
  }

  @override
  Widget build(BuildContext context) {
    return ChessBoard(
      game: game,
    );
  }
}
