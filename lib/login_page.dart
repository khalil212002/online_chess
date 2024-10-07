import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final user = TextEditingController();
  final password = TextEditingController();

  void _login(BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "${user.text}@khalil.fix", password: password.text)
        .then(
      (value) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Logged in"),
            backgroundColor: Colors.green,
          ));
        }
      },
    ).onError(
      (error, stackTrace) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text((error as FirebaseAuthException).message ?? 'error')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(fontSize: 30),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: user,
                                decoration: const InputDecoration(
                                    labelText: "Username")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextField(
                              decoration:
                                  const InputDecoration(labelText: "Password"),
                              obscureText: true,
                              controller: password,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: SizedBox(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _login(context);
                                      },
                                      child: const Text('Login'))),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
