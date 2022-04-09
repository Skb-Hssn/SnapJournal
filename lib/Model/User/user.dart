import 'package:intl/intl.dart';

class UserFields {
  static var name = 'name';
  static var dob = 'dob';
  static var password = 'password';
  static var isPasswordSet = 'isPasswordSet';
  static var isLoggedOut = 'isLoggedOut';
  static var favouriteQuestion = 'favouriteQuestion';
  static var favouriteQuestionAnswer = 'favouriteQuestionAnswer';
}

class User {
  String? name;
  DateTime? dob;
  String? password;
  bool? isPasswordSet;
  bool? isLoggedOut;
  String? favouriteQuestion;
  String? favouriteQuestionAnswer;

  User({this.name, this.dob, this.password}) {
    isPasswordSet = false;
    isLoggedOut = true;
    favouriteQuestion = "";
    favouriteQuestionAnswer = "";
  }

  User.allFields({
    this.name,
    this.dob,
    this.password,
    this.isPasswordSet,
    this.isLoggedOut,
    this.favouriteQuestion,
    this.favouriteQuestionAnswer
  }
  );

  static bool verifyPassword(String password) {
    return true;
  }

  Map<String, Object?> toJson() => {
    UserFields.name: name,
    UserFields.dob: DateFormat('yyyy-MM-dd').format(dob!),
    UserFields.password: password,
    UserFields.isPasswordSet: isPasswordSet!? "1" : "0",
    UserFields.isLoggedOut: isLoggedOut!? "1" : "0",
    UserFields.favouriteQuestion: favouriteQuestion,
    UserFields.favouriteQuestionAnswer: favouriteQuestionAnswer,
  };

  static User fromJson(Map<String, Object?> json) => User.allFields(
    name: json[UserFields.name] as String,
    dob: DateTime.parse(json[UserFields.dob] as String),
    password: json[UserFields.password] as String,
    isPasswordSet: json[UserFields.isPasswordSet] as String == "1" ? true : false,
    isLoggedOut: json[UserFields.isLoggedOut] as String == "1" ? true : false,
    favouriteQuestion: json[UserFields.favouriteQuestion] as String,
    favouriteQuestionAnswer: json[UserFields.favouriteQuestionAnswer] as String
  );
}