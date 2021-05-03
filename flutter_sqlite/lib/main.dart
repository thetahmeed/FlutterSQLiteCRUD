import 'package:flutter/material.dart';
import 'package:flutter_sqlite/ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sepio Notes',
      home: HomePage(),
    );
  }
}


/*
LOGO FONT: MEDDON
COLOR CODE: 4a4e69
*/