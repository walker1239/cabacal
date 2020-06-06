import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../bloc_users/models/_user.dart';
import 'package:sqflite/sqflite.dart';

class DbUser {
  DbUser._();

  static final DbUser db = DbUser._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
        "id INTEGER PRIMARY KEY,"
        "userName TEXT,"
        "motherSurname TEXT,"
        "fatherSurname TEXT,"
        "gender TEXT"
        "birth TEXT,"
        "weight TEXT,"
        "tall TEXT,"
        "email TEXT,"
        "password TEXT"
        ")"
      );
    });
  }

  newUser(User newUser) async {
    final db = await database;
    //String dateSlug ="${newUser.birth.year.toString()}-${newUser.birth.month.toString().padLeft(2,'0')}-${newUser.birth.day.toString().padLeft(2,'0')}";
    //get the biggest id in the table
    //insert to the table using the new id
    var result = await db.rawQuery("SELECT * FROM User WHERE id=1");
    if(!result.isNotEmpty){
      var raw = await db.rawInsert(
        "INSERT Into User (id,userName,motherSurname,fatherSurname,gende,birth,weight,tall,email,password)"
        " VALUES (?,?,?,?)",
        [newUser.id,newUser.userName,newUser.motherSurname,newUser.fatherSurname,newUser.gender,newUser.birth,newUser.weight,newUser.tall,newUser.email,newUser.password]);
      return raw;
    }
    else{
      var resp = await db.update("User", newUser.toMap(),
          where: "id = 1");
      return resp;
    }
  }


  updateUser(User newUser) async {
    final db = await database;
    var res = await db.update("User", newUser.toMap(),
        where: "id = ?", whereArgs: [newUser.id]);
    return res;
  }

  getUser() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM User WHERE id=1");
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }
  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("User");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }
  deleteUser() async {
    final db = await database;
    await db.delete(
      'User',
      where: "id = ?",
      whereArgs: [1],
    );
  }
}