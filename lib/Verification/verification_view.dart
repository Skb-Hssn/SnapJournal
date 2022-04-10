import 'package:flutter/material.dart';
import 'package:snapjournal/Database/database.dart';

import '../Model/User/user.dart';
import '../SnapJournal/constants/enums.dart';


class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  State<StatefulWidget> createState() => _VerificationView();
}



class _VerificationView extends State<VerificationView> {
  
  late User user;
  
  String? password;
  
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

          _passwordField(),
          _loginButton(context),
          _forgotpass(),
        ],
      ),
    );
  }


  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.security),
        hintText: "Password",
        labelText: "Password",
      ),
      validator: (value) => null,
      onChanged: (String text) {
        password = text;
      },
    );
  }


  Widget _loginButton(BuildContext context){
    return ElevatedButton(
        onPressed: () {
          if(password != null && user.verifyPassword(password)){
            Navigator.pushReplacementNamed(context, '/home');
          }
          //print('$password');
        },
        child: const Text('Login')
    );
  }

 Widget _forgotpass(){
    return TextButton(
        onPressed: (){
          Navigator.pushReplacementNamed(context, '/passwordreset');
        },
        child: Text('Forgot password?'),


    );
 }


}
