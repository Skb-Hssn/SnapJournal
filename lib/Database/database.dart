import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Model/user_model.dart';

class DB {
  static const String userTable = 'userTable';
  static const String dayTable = 'dayTable';
  static const String imageTable = 'imageTable';

  static final DB instance = DB._init();
  static Database? _database;

  DB._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB('DB.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    var x = await openDatabase(path, version: 1);

    _createDB(x, 1);

    return x;
  }

  Future _createDB(Database db, int version) async {
    final db = await instance.database;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $userTable (
          ${UserFields.name} TEXT PRIMARY KEY,
          ${UserFields.dob} TEXT NOT NULL,
          ${UserFields.password} TEXT NOT NULL,
          ${UserFields.isPasswordSet} TEXT NOT NULL,
          ${UserFields.isLoggedOut} TEXT NOT NULL,
          ${UserFields.favouriteQuestion} TEXT NOT NULL,
          ${UserFields.favouriteQuestionAnswer} TEXT NOT NULL
        )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $imageTable (
          image BLOB 
        )
      ''');
  }

  Future insertUser(User user) async {
    final db = await instance.database;
    db.insert(userTable, user.toJson());
  }

  Future <List<User>> readUser() async {
    final db = await instance.database;

    final result = await db.query(userTable );
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future deleteUser(String name) async {
    final db = await instance.database;
    await db.delete(
      userTable, 
      where: '${UserFields.name} = ?',
      whereArgs: [name],
    );
  }

  Future insertImage(Map<String, Object ?> image) async {
    final db = await instance.database;
    print("__________4_______________");
    db.insert(imageTable, image);
    print("__________5_______________");

    final result = await db.query(imageTable);
    print("__________6_______________");

    print("insert success \n $result");
  }

  Future <Map<String, Object?>> getImage() async {
    final db = await instance.database;

    final result = await db.query(imageTable);

    return result[0];
  }
}