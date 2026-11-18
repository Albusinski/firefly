import 'package:firefly/Screens/buttonscreen.dart';
import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Screens/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromRGBO(25, 42, 86, 100),
        scaffoldBackgroundColor: Color.fromRGBO(245, 240, 250, 100),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(25, 42, 86, 100),
            foregroundColor: Color.fromRGBO(220, 221, 225, 100),
            padding: EdgeInsets.all(20)
          )
        )
      ),
      home: buttonscreen(),
    );
  }
}
