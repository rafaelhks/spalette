import 'package:flutter/material.dart';
import 'package:mediapp/screens/home.dart';
import 'package:mediapp/util/palette.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPALETTE',
      theme: ThemeData(
        primarySwatch: Palette.baseColor,
      ),
      home: HomePage(),
    );
  }
}
