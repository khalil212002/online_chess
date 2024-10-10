import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_chess/board_loader.dart';
import 'package:online_chess/components/loading_text.dart';
import 'package:online_chess/utils/find_game.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Fix Chess'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.sync)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: FutureBuilder(
              future: findGames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingText(text: "Finding Games");
                }
                if (snapshot.hasData &&
                    snapshot.data!
                        .containsKey(FirebaseAuth.instance.currentUser!.uid)) {
                  return BoardLoader(
                      ref: snapshot
                          .data![FirebaseAuth.instance.currentUser!.uid]!);
                }
                return ElevatedButton(
                    onPressed: () {},
                    child: const Text("Try finding games again"));
              }),
        ),
      ),
    );
  }
}
