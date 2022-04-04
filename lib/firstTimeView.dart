import 'package:flutter/material.dart';
import 'constants/enums.dart';



class FirstTimeView extends StatelessWidget {
  const FirstTimeView({Key? key}) : super(key: key);


  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(backgroundColor),
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
                color: Colors.grey[700],
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
                color: Colors.grey[700],
              ),
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                Expanded(
                  child: TextButton(
                    onPressed: () {}, 
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
                    onPressed: () {}, 
                    child: Text(
                      'YES',
                      style: TextStyle(
                        fontFamily: 'OpenSansRegular',
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),   
    );
  }
}