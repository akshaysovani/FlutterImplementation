import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:first_flutter_app/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper
      _databaseHelper; //Siggleton DatabaseHelper Object ==> Can be instantiated only once throughout the application.
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  DatabaseHelper.create_instance_once(); //Constructor with name 'create_instance_once'.

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          .create_instance_once(); //Create a databasehelper class object if it doesn't exists
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _create_db);
    return notesDatabase;
  }

  void _create_db(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT'
        ', $colDate TEXT, $colPriority INTEGER)');
  }

  //Fetch List of Map objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority');
    return result;
  }

//Insert Note objects into database
  Future<int> putNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

//Update operation
  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

//Delete a note object from database
  Future<int> deleteNote(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

//Get number of notes in the database currently present
  Future<int> getNumberOfNotes() async{
    Database db = await this.database;
    List<Map<String,dynamic>> result = await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    return Sqflite.firstIntValue(result);
  }

//Get the notes from database in terms of List of Map objects and put that list into List of Note objects by converting.
  Future<List<Note>> getNotesFromDB() async{
    var noteMapList = await getNoteMapList();
    int length = noteMapList.length;

    List<Note> noteList = List<Note>();

    for (int i=0;i<length;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
