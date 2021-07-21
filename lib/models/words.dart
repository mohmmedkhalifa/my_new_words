import 'package:my_words/helpers/db_helpers.dart';

class Word {
  int id;
  String word;

  Word({
    this.id,
    this.word,
  });

  Word.fromMap(Map map) {
    this.id = map[DBHelper.wordId];
    this.word = map[DBHelper.wordText];
  }

  Map<String, dynamic> toMap() {
    return {
      DBHelper.wordText: this.word,
    };
  }
}
