import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chess/chess_board.dart';
import 'package:online_chess/components/loading_text.dart';
import 'package:online_chess/utils/get_game.dart';

class BoardLoader extends StatelessWidget {
  const BoardLoader({super.key, required this.ref});
  final DocumentReference<Map<String, dynamic>> ref;

  void move(String mov) {
    ref.update({
      "pgn": FieldValue.arrayUnion([mov])
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGame(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingText(text: "Loading game");
        }
        if (snapshot.hasData && snapshot.data!.isValid()) {
          var pgn = '';
          for (var element in snapshot.data!.pgn!) {
            if (element.contains(' ')) {
              pgn += "${element.substring(element.indexOf(' '))} ";
            } else {
              pgn += '$element ';
            }
          }
          log(pgn);
          return ChessBoard(
              isWhite: snapshot.data!.white ==
                  FirebaseAuth.instance.currentUser!.uid,
              pgn: pgn,
              moveFun: move);
        }
        return ElevatedButton(
            onPressed: () {}, child: const Text("Try loading game again"));
      },
    );
  }
}
