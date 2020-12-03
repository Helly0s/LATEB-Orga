import 'package:flutter/material.dart';

import 'screens/HomePage.dart';
import 'screens/SignUp.dart';
import 'screens/Start.dart';
import 'screens/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange
      ),
      home: Start(),
      routes: {
        '/Start':(BuildContext context) => Start(),
        '/Login': (BuildContext context) => Login(),
        '/SignUp': (BuildContext context) => SignUp(),
        '/HomePage':(BuildContext context) => HomePage(),
      },
    );
  }
}