import 'package:cloud_firestore/cloud_firestore.dart';

Stream<GameDoc> getGame(DocumentReference<Map<String, dynamic>> ref) {
  return ref.snapshots().map(
    (event) {
      final data = GameDoc();
      if (event.data() != null) {
        final mp = event.data()!;
        if (mp.containsKey('white')) {
          data.white = mp['white'];
        } else {
          throw Exception("Game doc doesn't have white field");
        }
        if (mp.containsKey('black')) {
          data.black = mp['black'];
        } else {
          throw Exception("Game doc doesn't have black field");
        }
        if (mp.containsKey('pgn')) {
          data.pgn =
              (mp['pgn'] as List<dynamic>).map((e) => e.toString()).toList();
        } else {
          throw Exception("Game doc doesn't have pgn field");
        }
      }
      return data;
    },
  );
}

class GameDoc {
  late String? black, white;
  late List<String>? pgn;
  GameDoc({this.black, this.pgn, this.white});
  bool isValid() {
    return black != null && white != null && pgn != null;
  }
}
