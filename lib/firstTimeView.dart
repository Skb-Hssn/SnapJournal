// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'SnapJournal/constants/enums.dart';



class FirstTimeView extends StatelessWidget {
  const FirstTimeView({Key? key}) : super(key: key);


  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: const Image(
              height: 150,
              width: 150,
              image: AssetImage('assets/images/logo.png'),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Text(
              'SnapJournal',
              style: TextStyle(
                fontFamily: 'OpenSansBold',
                fontWeight: FontWeight.w900,
                fontSize: 40,
                color: Color(darkViolet),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          Container(
            child: Text(
              'Continue with password?',
              style: TextStyle(
                fontFamily: 'OpenSansRegular',
                fontSize: 20,
                color: Color(darkViolet),
              ),
            ),
          ),

          SizedBox(height: 20,),

          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                SizedBox(width: 50,),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    }, 
                    child: const Text(
                      'NO',
                      style: TextStyle(
                        fontFamily: 'OpenSansRegular',
                        color: Colors.red,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/userRegistration');
                    }, 
                    child: Text(
                      'YES',
                      style: TextStyle(
                        fontFamily: 'OpenSansRegular',
                        color: Color(darkViolet),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 50,),
              ],
            ),
          ),
        ],
      ),   
    );
  }
}