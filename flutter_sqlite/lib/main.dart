import 'package:flutter/material.dart';
import 'package:flutter_sqlite/ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite Demo',
      home: HomePage(),
    );
  }
}
