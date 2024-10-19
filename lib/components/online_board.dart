import 'dart:async';

import 'package:chess/chess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_chess/utils/get_game.dart';

class OnlineBoard extends Chess {
  final DocumentReference<Map<String, dynamic>> _doc;
  StreamSubscription<GameDoc>? _stream;
  late bool _isWhite;
  Function? update;

  OnlineBoard({required DocumentReference<Map<String, dynamic>> doc})
      : _doc = doc {
    _isWhite = false;
  }

  void setListener(Function func) {
    update = func;
  }

  void init() {
    _stream = getGame(_doc).listen(_onData);
  }

  bool isTurn() {
    return turn == (isWhite ? Color.WHITE : Color.BLACK);
  }

  bool isMate() {
    return king_attacked((isWhite ? Color.WHITE : Color.BLACK));
  }

  void _onData(GameDoc snapshot) {
    if (snapshot.isValid()) {
      if (snapshot.black == FirebaseAuth.instance.currentUser?.uid) {
        _isWhite = false;
        update?.call();
      } else if (snapshot.white == FirebaseAuth.instance.currentUser?.uid) {
        _isWhite = true;
        update?.call();
      } else {
        throw Exception("Player is not white nither black");
      }
      if (snapshot.pgn?.length != move_number) {
        if (snapshot.pgn?.length == move_number + 1) {
          super.move(snapshot.pgn!.last.trim().split(' ')[0]);
        } else {
          load_pgn(snapshot.pgn!
              .map((v) => v.trim().split(' ')[0])
              .toList()
              .join(' '));
        }
        update?.call();
      }
    }
  }

  @override
  bool move(dynamic move) {
    bool result = super.move(move);
    if (result) {
      _doc.update({
        "pgn": FieldValue.arrayUnion([pgn().trim().split(' ').last])
      }).onError(
        (error, stackTrace) {
          throw Exception(
              "Couldn't write ${pgn().trim().split(' ').last} to the server\n${error.toString()}");
        },
      );
    }
    return result;
  }

  bool get isWhite {
    return _isWhite;
  }

  void dispose() {
    _stream?.cancel();
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == runtimeType) {
      OnlineBoard oth = other as OnlineBoard;
      return oth.move_number == move_number && oth.pgn() == pgn();
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(move_number, pgn());
}
