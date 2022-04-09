import 'package:flutter/material.dart';

import '../SnapJournal/constants/enums.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(backgroundColor),
      body: Column(
        children: [
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

          _question(),
          _answer(),
          _verifyQA(context),
        ],
      ),
    );
  }


  Widget _question(){
    return Text(
      "string"
    );
  }

  Widget _answer(){
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: "Enter username",
        labelText: "Username",
      ),
    );
  }

  Widget _verifyQA(BuildContext context){
    return ElevatedButton(
        onPressed: () {
        },
        child: const Text('Verify')
    );
  }

}
