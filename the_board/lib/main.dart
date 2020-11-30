import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return null; // TODO: error handling

        if (snapshot.connectionState == ConnectionState.done) {
          // Indicates successful connection
          return MaterialApp(
            title: 'The-Board',
            home: Scaffold(
                body: Center(
              child: Text("Hey there"),
            )),
          );
        }

        return null; // TODO: loading screen while future loading
      },
    );
  }
}
