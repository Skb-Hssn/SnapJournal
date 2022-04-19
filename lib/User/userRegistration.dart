// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snapjournal/Database/database.dart';
import 'package:snapjournal/SnapJournal/constants/enums.dart';
import '../Model/user_model.dart';

class UserRegistration extends StatefulWidget {
  UserRegistration({Key? key}) : super(key: key);

  State<StatefulWidget> createState() => _UserRegistration();
}

class _UserRegistration extends State<UserRegistration> {

  String? name = '';
  DateTime? dob;  
  String? password = '';
  String? retypedPassword;

  String? securityquestion;
  String? securityquestionanswer;

  String dobText = "";
  String errorMassage = "";

  final _formKey = GlobalKey<FormState>();

  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    List list = await DB.instance.readUser();
    if(list.isNotEmpty) {
      user = list[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loginform(context);
  }

  Widget _loginform(BuildContext context) {
    return Scaffold(
      body: Form (
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
          child: SingleChildScrollView( child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _usernameField(),
              SizedBox(height: 25,),
              dobField(),
              SizedBox(height: 5,),
              _passwordField(),
              SizedBox(height: 5,),
              _retypedPasswordField(),
              SizedBox(height: 10,),
              _securityQA(context),
              SizedBox(height: 5,),
              _securityQAnswer(context),
              SizedBox(height: 25,),
              _loginButton(context),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _usernameField() {
    FocusNode focusNode = new FocusNode();
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        icon: Icon(
          Icons.person,
        ),
        hintText: "Enter username",
        labelText: "Username",
      ),
      validator: (value) => null,
      onChanged: (String text) {
        name = text;
      },
    );
  }


  Widget dobField() {
    return Row(
      children: [
        Icon(
          Icons.calendar_month,
          color: Colors.grey,
        ),
        SizedBox(width: 15,),
        Expanded(
          child: Text(
            "Date of birth: $dobText",
            style: TextStyle(
              color: Color.fromARGB(255, 88, 88, 88),
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(width: 20,),
        GestureDetector(
          child: new Icon(Icons.calendar_today),
          onTap: () async {
            final datePick= await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100)
            );

            if(datePick != null) {
              setState(() {
                dob = datePick;
                dobText = "${dob?.day}/${dob?.month}/${dob?.year}";
              });
            }
        }),
      ],
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

  Widget _retypedPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.security),
        hintText: "Retype Password",
        labelText: "Retype Password",
      ),
      validator: (value) => null,
      onChanged: (String text) {
        retypedPassword = text;
      },
    );
  }

  Widget _errorMassage() {
    return Text(errorMassage);
  }

  Widget _loginButton(BuildContext context){
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (name == '') {
            errorMassage = 'Username can\'t be empty';
            showToast(errorMassage);
          } else if (password == '') {
            errorMassage = 'Password can\'t be empty';
            showToast(errorMassage);
          } else if (dob == null) {
            errorMassage = 'Date of birth cannot be empty';
            showToast(errorMassage);
          } else if(password != retypedPassword) {
            errorMassage = 'Password doesn\'t match';
            showToast(errorMassage);
          } else if(securityquestionanswer == null) {
            errorMassage = 'Answert cannot be empty.';
            showToast(errorMassage);
          } else {
            if(user != null) {
              DB.instance.deleteUser(user!.name!);
            }

            DB.instance.insertUser(
              User.allFields(
                name: name,
                dob: dob,
                password: password,
                isLoggedOut: false,
                isPasswordSet: true,
                favouriteQuestion: securityquestion,
                favouriteQuestionAnswer: securityquestionanswer
              )
            );
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      },
      child: const Text('Register')
  );

 }
  final List<String> securityquestions = ["What is your pet's name?", "What is your favourite color?", "What is the name of your first friend?"];

  Widget _securityQA(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.question_mark,
          // color: Color.fromARGB(255, 88, 88, 88),
          color: Colors.grey,
        ),
        SizedBox(width: 15,),
        Container(
          width: MediaQuery.of(context).size.width - 100,
          child: DropdownButtonFormField(
            value: securityquestion ?? securityquestions[0],
            items: securityquestions.map((sQA){
              return DropdownMenuItem(
                value: sQA,
                child: Text(
                  '$sQA',
                  style: TextStyle(
                    color: Color.fromARGB(255, 88, 88, 88),
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (val){
              securityquestion = val as String?;
            }
          )
        )
      ]
    );
  }


  Widget _securityQAnswer(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.question_answer,
          // color: Color.fromARGB(255, 88, 88, 88),
          color: Colors.grey,
        ),
        SizedBox(width: 15,),
        Container(
          width: MediaQuery.of(context).size.width - 100,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: " ",
              labelText: "Your answer",
            ),
            validator: (value) => null,
            onChanged: (String text) {
              securityquestionanswer = text;
            },
          )
        ),
      ]
    );
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

  // Future saveUser(User user) async {
  //   await DB.instance.updateUserAllFields(user);
  // }
}