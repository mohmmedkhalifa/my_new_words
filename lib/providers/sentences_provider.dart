import 'package:flutter/material.dart';
import 'package:my_words/helpers/db_helpers.dart';
import 'package:my_words/models/sentences.dart';


class SentencesProvider extends ChangeNotifier {
  List<Sentences> sentences = [];

  insertIntoSentencesTable(Sentences value) async {
    await DBHelper.dbHelper.insertNewSentence(value);
    getAllSente();
  }

  getAllSente() async {
    List<Map<String, dynamic>> rows = await DBHelper.dbHelper.getAllSentences();
    List<Sentences> sentences =
    rows != null ? rows.map((e) => Sentences.fromMap(e)).toList() : [];
    fillLists(sentences);
  }

  fillLists(List<Sentences> sentences) {
    this.sentences = sentences;
    notifyListeners();
  }
}
