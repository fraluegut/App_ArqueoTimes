import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(ArqueoTimesApp());
}

class ArqueoTimesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArqueoTimes',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: WelcomeScreen(),
    );
  }
}
