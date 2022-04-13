import 'package:path/path.dart';
import 'package:snapjournal/Model/photo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Model/event_image_row.dart';
import '../Model/text_model.dart';
import '../Model/user_model.dart';

class DB {
  static const String userTable = 'userTable';
  static const String dayTable = 'dayTable';
  static const String imageTable = 'imageTable';
  static const String textTable = 'textTable';
  static const String eventImageRowTable = 'eventImageRowTable';

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
          ${PhotoFields.imagepath} TEXT 
        )
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $textTable (
          ${EventTextFields.eventId} INTEGER PRIMARY KEY, 
          ${EventTextFields.text} TEXT
        )
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $eventImageRowTable (
          ${EventImageRowFields.eventId} INTEGER, 
          ${EventImageRowFields.imageId} INTEGER,
          PRIMARY KEY(${EventImageRowFields.eventId}, ${EventImageRowFields.imageId})
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

  Future<int> insertImage(Map<String, Object ?> image) async {
    final db = await instance.database;
    var ret = db.insert(imageTable, image);
    return ret;
  }

  Future <Map<String, Object?>> getImage(int id) async {
    final db = await instance.database;

    final result = await db.query(
      imageTable,
      columns: ['rowid', (PhotoFields.imagepath)],
      where: 'rowid = ?',
      whereArgs: [id]
    );

    return result[0];
  }

  Future insertText(EventText eventText) async {
    final db = await instance.database;
    db.insert(textTable, eventText.toJson());
  }

  Future <String> readText(int id) async {
    final db = await instance.database;

    final result = await db.query(
      textTable,
      columns: [EventTextFields.eventId, EventTextFields.text],
      where: '${EventTextFields.eventId} = ?',
      whereArgs: [id],
    );

    var res = result.map((json) => EventText.fromJson(json)).toList();

    if(res.isEmpty) {
      return '';
    } else {
      return res[0];
    }
  }

  Future <int> nextEventId() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT MAX(${EventTextFields.eventId}) FROM $textTable'
    );

    if(result[0]['MAX(${EventTextFields.eventId})'] == null) {
      return 0;
    } else {
      return (result[0]['MAX(${EventTextFields.eventId})'] as int) + 1;
    }
  }

  Future insertEventImageRow(EventImageRow eventImageRow) async {
    final db = await instance.database;
    db.insert(eventImageRowTable, eventImageRow.toJson());
  }

  Future<List<int>> getImageId(int eventId) async {
    final db = await instance.database;
    final result = await db.query(
      eventImageRowTable,
      columns: [EventImageRowFields.eventId, EventImageRowFields.imageId],
      where: '${EventImageRowFields.eventId} = ?',
      whereArgs: [eventId],
    );

    return result.map((json) => EventImageRow.fromJson(json)).toList(); 
  }
}