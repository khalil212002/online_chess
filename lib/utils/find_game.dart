import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, DocumentReference<Map<String, dynamic>>>?>
    findGames() async {
  final doc =
      await FirebaseFirestore.instance.collection('games').doc('root').get();
  if (doc.data() != null) {
    final data = doc.data()!;
    if (data.containsKey('ref')) {
      final ref = (data['ref'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, value as DocumentReference<Map<String, dynamic>>),
      );
      return ref;
    }
  }
  return null;
}
