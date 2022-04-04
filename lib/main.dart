// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'firstTimeView.dart';

void main() {
  runApp(SnapJournal());
}

class SnapJournal extends StatelessWidget {
  const SnapJournal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/firstTime',
      routes: {
        '/firstTime' : (context) => FirstTimeView(),
      },
      theme: ThemeData(),
    );
  }

  bool isFirstTime() {
    return true;
  }
}