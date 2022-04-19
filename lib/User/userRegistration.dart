// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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

  late User user;

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
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _usernameField(),
              dobField(),
              _passwordField(),
              _retypedPasswordField(),
              _errorMassage(),
              _securityQA(),
              _securityQAnswer(),
              _loginButton(context),
            ],
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

  Widget _dobText() {
    return Text(dobText);
  }

  Widget _dobField() {
    return GestureDetector(
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
      }
    );
  }

  Widget dobField() {
    return Row(
      children: [
        Expanded(
          child: Text("Date of birth: $dobText"),
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
          } else if (password == '') {
            errorMassage = 'Password can\'t be empty';
          } else if (dob == null) {
            errorMassage = 'Date of birth cannot be empty';
          } else if(password != retypedPassword) {
            errorMassage = 'Password doesn\'t match';
          } else if(securityquestionanswer == null) {
            errorMassage = 'Answert cannot be empty.';
          } else {
            if(user != null) {
              DB.instance.deleteUser(user.name!);
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
      child: const Text('Login')
  );

 }
  final List<String> securityquestions = ["What is your pet's name?", "What is your favourite color?", "What is the name of your first friend?"];

  Widget _securityQA() {
    return DropdownButtonFormField(
        value: securityquestion ?? securityquestions[0],
        items: securityquestions.map((sQA){
          return DropdownMenuItem(
            value: sQA,
            child: Text('$sQA'),
          );
        }).toList(),
        onChanged: (val){
          securityquestion = val as String?;
        });
  }


  Widget _securityQAnswer() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: " ",
        labelText: "Your answer",
      ),
      validator: (value) => null,
      onChanged: (String text) {
        securityquestionanswer = text;
      },
    );
  }
}