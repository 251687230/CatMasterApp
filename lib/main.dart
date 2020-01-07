import 'package:flutter/material.dart';

import 'login_in_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "喵管家",
        home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        buttonTheme: ButtonThemeData(minWidth: double.infinity,height: 40
        ,buttonColor: Colors.pinkAccent,focusColor: Colors.pink,
        hoverColor: Colors.pink),
      ),
    );
  }
}
