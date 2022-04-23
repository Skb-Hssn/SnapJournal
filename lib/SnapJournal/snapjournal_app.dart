// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:snapjournal/Database/database.dart';
import 'package:snapjournal/Home/calendar.dart';
import 'package:snapjournal/SnapJournal/constants/enums.dart';
import 'package:snapjournal/TagSearch/tagsearch.dart';
import 'package:snapjournal/TagSearch/tagsearch_widget.dart';
import 'package:snapjournal/Verification/password_reset.dart';
import '../Day/day_view.dart';
import '../Model/user_model.dart';
import '../User/userRegistration.dart';
import '../Verification/verification_view.dart';
import '../firstTimeView.dart';
import '../Home/home.dart';

class SnapJournal extends StatefulWidget {
  const SnapJournal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SnapJournal();
}

class _SnapJournal extends State<SnapJournal> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/loadingView',
      debugShowCheckedModeBanner: false,
      routes: {
        '/loadingView' : (context) => _Loading(),
        '/firstTime' : (context) => FirstTimeView(),
        '/home' : (context) => Home(),
        '/userRegistration' : (context) => UserRegistration(),
        '/verificationView': (context) => VerificationView(),
        '/passwordreset': (context) => ResetPassword(),
        '/dayView': (context) => DayView(),
        '/calendarView': (context) => CalendarView(),
        '/searchtag': (context) => TagSearch(),
      },
      theme: ThemeData().copyWith(
        // change the focus border color of the TextField
        colorScheme: ThemeData().colorScheme.copyWith(primary: Color(darkViolet)),
        // change the focus border color when the errorText is set
        errorColor: Colors.purple,
      ),
    );
  }

}

class _Loading extends StatefulWidget {
  _Loading({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingView();
}


class _LoadingView extends State<_Loading> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshStates();
  }

  Future refreshStates() async {


    bool x = await userAlreayExists();

    bool y = await isPasswordSet();

    bool z = await isLoggedOut();

    // setState(() async {
      if(x) {
        if(y && z) {
          Navigator.pushReplacementNamed(context, '/verificationView');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        await DB.instance.insertUser(
          User.allFields(
            name: 'User',
            dob: DateTime.now(),
            password: 'dummy',
            isPasswordSet: false,
            isLoggedOut: false,
            favouriteQuestion: '',
            favouriteQuestionAnswer: '',
          ),
        );

        Navigator.pushReplacementNamed(context, '/firstTime');
      }

  }

  static Future<bool> userAlreayExists() async {
    List<User> list = await DB.instance.readUser();
    return list.isNotEmpty;
  }

  static Future<bool> isPasswordSet() async {
    List list = await DB.instance.readUser();
    if(list.isEmpty) return false;
    return list[0].isPasswordSet;
  }

  static Future<bool> isLoggedOut() async {
    List list = await DB.instance.readUser();
    if(list.isEmpty) return false;
    return list[0].isLoggedOut;
  }
}