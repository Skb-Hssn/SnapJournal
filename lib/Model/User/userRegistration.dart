import 'package:flutter/material.dart';

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

  String dobText = "Enter Date of Birth";
  String errorMassage = "";

  final _formKey = GlobalKey<FormState>();

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
              _dobText(),
              _dobField(),
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
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
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
            initialDate: new DateTime.now(),
            firstDate: new DateTime(1900),
            lastDate: new DateTime(2100)
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
        } else if (password == retypedPassword) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          errorMassage = 'Password doesn\'t match';
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
        } );
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