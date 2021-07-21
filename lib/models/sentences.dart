import 'package:my_words/helpers/db_helpers.dart';

class Sentences {
  int id;
  String sentence;

  Sentences({
    this.id,
    this.sentence,
  });

  Sentences.fromMap(Map map) {
    this.id = map[DBHelper.sentenceId];
    this.sentence = map[DBHelper.sentenceText];
  }

  Map<String, dynamic> toMap() {
    return {
      DBHelper.sentenceText: this.sentence,
    };
  }
}