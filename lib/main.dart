import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/history_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Page App',
      home: HomePage(), // Start with HomePage
    );
  }
}
