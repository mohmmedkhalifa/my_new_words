import 'package:flutter/material.dart';
import 'package:my_words/helpers/db_helpers.dart';
import 'package:my_words/models/words.dart';

class WordProvider extends ChangeNotifier {
  List<Word> words = [];

  insertIntoBookTable(Word word) async {
    await DBHelper.dbHelper.insertNewBook(word);
    getAllBook();
  }

  getAllBook() async {
    List<Map<String, dynamic>> rows = await DBHelper.dbHelper.getAllWords();
    List<Word> books =
        rows != null ? rows.map((e) => Word.fromMap(e)).toList() : [];
    fillLists(books);
  }

  fillLists(List<Word> words) {
    this.words = words;
    notifyListeners();
  }
}
