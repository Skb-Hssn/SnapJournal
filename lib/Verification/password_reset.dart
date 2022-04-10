import 'package:flutter/material.dart';

import '../Database/database.dart';
import '../Model/User/user.dart';
import '../SnapJournal/constants/enums.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  String ? answer;
  late User user;


  @override
  void initState() {
    super.initState();

    getUser();
  }

  Future getUser() async {
    List list = await DB.instance.readUser();

    if(list.isNotEmpty){
      user = list[0];
    }
  }

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
      '$user.favouriteQuestion'
    );
  }

  Widget _answer(){
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: "Enter Answer",
        labelText: "answer",
      ),
      validator: (value) => null,
      onChanged: (String text) {
         answer = text;
      },
    );
  }

  Widget _verifyQA(BuildContext context){
    return ElevatedButton(
        onPressed: () {
          if(answer == user.favouriteQuestionAnswer){
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: const Text('Verify')
    );
  }

}
