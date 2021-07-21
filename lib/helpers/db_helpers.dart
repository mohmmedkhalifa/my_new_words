import 'dart:io';


import 'package:my_words/models/sentences.dart';
import 'package:my_words/models/words.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper dbHelper = DBHelper._();
  static final String dbName = 'words.db';

  ///////////// Book Table
  static final String wordTable = 'wordTable';
  static final String sentenceTable = 'sentenceTable';
  static final String wordId = 'wordId';
  static final String sentenceId = 'sentenceId';
  static final String wordText = 'wordText';
  static final String sentenceText = 'sentenceText';


  /////////////
  Database database;

  initializeTasksDatabase() async {
    if (database == null) {
      database = await connectToDatabase();
    }
  }

  Future<Database> connectToDatabase() async {
    Directory pathDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(pathDirectory.path, dbName);
    Database database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        try {
          createBookTable(db);
          createSentenceTable(db);
        } on Exception catch (e) {
          print(e);
        }
      },
    );
    return database;
  }

  createBookTable(Database db) {
    db.execute('''CREATE TABLE $wordTable(
    $wordId INTEGER PRIMARY KEY AUTOINCREMENT,
    $wordText TEXT NOT NULL
   )''');
  }


  createSentenceTable(Database db) {
    db.execute('''CREATE TABLE $sentenceTable(
    $sentenceId INTEGER PRIMARY KEY AUTOINCREMENT,
    $sentenceText TEXT NOT NULL
   )''');
  }


  insertNewBook(Word word) async {
    try {
      int result = await database.insert(
        wordTable,
        word.toMap(),
      );
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }


  insertNewSentence(Sentences value) async {
    try {
      int result = await database.insert(
        sentenceTable,
        value.toMap(),
      );
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    try {
      List<Map<String, dynamic>> allRows = await database.query(wordTable);
      return allRows;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllSentences() async {
    try {
      List<Map<String, dynamic>> allRows = await database.query(sentenceTable);
      return allRows;
    } on Exception catch (e) {
      print(e);
    }
  }
}