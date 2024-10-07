import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_chess/components/loading_text.dart';
import 'package:online_chess/firebase_options.dart';
import 'package:online_chess/home_page.dart';
import 'package:online_chess/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: LoadingText(
                  text: "Fix Chess",
                  style: TextStyle(fontSize: 70),
                ),
              ),
            );
          }
          return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                      body: Center(
                          child: LoadingText(
                    text: "Fix Chess",
                    style: TextStyle(fontSize: 70),
                  )));
                }
                if (snapshot.hasData) {
                  if (snapshot.data?.uid != null) {
                    return const HomePage();
                  }
                }
                return LoginPage();
              });
        },
      ),
    );
  }
}
