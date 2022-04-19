import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Database/database.dart';
import '../Model/user_model.dart';
import '../SnapJournal/constants/enums.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  String ? answer;
  User ? user;


  @override
  void initState() {
    super.initState();

    getUser();
  }

  Future getUser() async {
    List list = await DB.instance.readUser();

    if(list.isNotEmpty){
      setState(() {
        user = list[0];
      });
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
      user == null ? '' : '${user!.favouriteQuestion}'
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
          createDummy();
        },
        child: const Text('Verify')
    );
  }


  Future createDummy() async{
    if(answer == user!.favouriteQuestionAnswer){

      await DB.instance.deleteUser(user!.name!);

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

      Navigator.pushReplacementNamed(context, '/home');
    }
    else {
      showToast("The answer is incorrect!!");
    }

  }


  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(LightViolet),
        textColor: Colors.black,
        fontSize: 16.0
    );
  }



}
