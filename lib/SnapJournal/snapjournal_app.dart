import 'package:flutter/material.dart';
import 'package:snapjournal/Database/database.dart';
import 'package:snapjournal/Verification/password_reset.dart';
import '../Model/User/userRegistration.dart';
import '../Verification/verification_view.dart';
import '../firstTimeView.dart';
import '../Home/home.dart';
import '../Model/User/user.dart';
import '../Model/Day/day.dart';

class SnapJournal extends StatefulWidget {
  const SnapJournal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SnapJournal();
}

class _SnapJournal extends State<SnapJournal> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/dayView',
      routes: {
        '/loadingView' : (context) => _Loading(),
        '/firstTime' : (context) => FirstTimeView(),
        '/home' : (context) => Home(),
        '/userRegistration' : (context) => UserRegistration(),
        '/verificationview': (context) => VerificationView(),
        '/passwordreset': (context) => ResetPassword(),
        '/dayView': (context) => DayView(),
      },
      theme: ThemeData(),
    );
  }

}

class _Loading extends StatefulWidget {
  _Loading({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingView();
}


class _LoadingView extends State<_Loading> {

  bool userAlreayExistsVar = false;
  bool isPasswordSetVar = false;

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

    setState(() async {
      if(x) {
        if(y) {
          Navigator.pushReplacementNamed(context, '/userRegistration');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        await DB.instance.insertUser(
          User(
            name: 'User',
            dob: DateTime.now(),
            password: 'dummy',
          ),
        );

        Navigator.pushReplacementNamed(context, '/firstTime');
      }
    });
  }

  static Future<bool> userAlreayExists() async {
    List list = await DB.instance.readUser();
    return list.isNotEmpty;
  }

  static Future<bool> isPasswordSet() async {
    List list = await DB.instance.readUser();
    if(list.isEmpty) return false;
    return list[0].isPasswordSet;
  }
}