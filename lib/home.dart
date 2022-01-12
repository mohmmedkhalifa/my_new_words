import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_words/models/sentences.dart';
import 'package:my_words/models/words.dart';
import 'package:my_words/providers/sentences_provider.dart';
import 'package:my_words/providers/word_providers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int i = 0;
  String myWord;
  List<Word> words;

  @override
  Widget build(BuildContext context) {
    words = Provider.of<WordProvider>(context).words;

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                  Colors.deepPurple[700],
                  Colors.deepPurple[600],
                  Colors.deepPurple[500],
                  Colors.purple[900],
                  Colors.purple[800],
                  Colors.purple[700],
                  Colors.purple[600],
                  Colors.purple[400],
                ])),
          ),
          bottom: TabBar(
            indicatorColor: Colors.pink,
            indicatorWeight: 3.5,
            tabs: [
              Tab(
                child: Text(
                  'جملي',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  'كلماتي',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: Text('يرجى الاختيار'),
                        content: Row(
                          children: [
                            Expanded(
                              child: myButtom(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    showSheet();
                                  },
                                  label: 'إضافة كلمة'),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: myButtom(
                                onPressed: () {
                                  Navigator.pop(context);
                                  words.length < 10
                                      ? showError()
                                      : showAddSentence();
                                },
                                label: 'إنشاء جملة',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
          title: Text(
            'كلماتي',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Consumer<SentencesProvider>(
              builder: (context, value, child) => Center(
                child: value.sentences.length == 0
                    ? Text(
                        'لا يوجد جمل',
                        style: TextStyle(fontSize: 30, fontFamily: 'Harm'),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: value.sentences.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(
                              value.sentences[index].sentence ?? ' خطأ',
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Harm',
                              ),
                              textAlign: TextAlign.right,
                            ),
                            leading: IconButton(
                                onPressed: () {
                                  FlutterClipboard.copy(
                                          value.sentences[index].sentence)
                                      .then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text('تم النسخ'))));
                                },
                                icon: Icon(Icons.copy)),
                          ),
                        ),
                      ),
              ),
            ),
            Consumer<WordProvider>(
              builder: (context, value, child) => Center(
                child: value.words.length == 0
                    ? Text(
                        'لا يوجد كلمات مضافة',
                        style: TextStyle(fontSize: 30, fontFamily: 'Harm'),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: value.words.length,
                        itemBuilder: (context, index) => Directionality(
                          textDirection: TextDirection.rtl,
                          child: Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              value.deleteWord(words[index]);
                            },
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                  size: 45,
                                ),
                              ),
                            ),
                            direction: DismissDirection.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Text(
                                value.words[index].word,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Harm',
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        height: 430,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    onChanged: (value) {
                      myWord = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'يرجى كتابة كلمتك الجديدة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              myButtom(
                  onPressed: () {
                    Provider.of<WordProvider>(context, listen: false)
                        .insertIntoBookTable(Word(word: myWord));
                    Navigator.pop(context);
                  },
                  label: 'إضافة')
            ],
          ),
        ),
      ),
    );
  }

  Widget myButtom({Function onPressed, String label}) {
    return SizedBox(
      width: 230,
      height: 60,
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.purple,
        child: Center(
          child: FittedBox(
            child: Text(
              label,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  showError() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
              title: Text('خطأ'),
              content: Text('يجب أن يكون عدد كلماتك ١٠ كلمات على الأقل')),
        );
      },
    );
  }

  showAddSentence() {
    words.shuffle();
    int random1 = Random().nextInt(2) + 1;
    int random2 = Random().nextInt(4) + 3;
    int num1 = 4;
    int num2 = 6;
    List first = words.sublist(2 + random1, 5 + random2);
    Word s;
    List newList = [];
    for (s in first) {
      newList.add(s.word);
    }
    String sentence = newList.join(' ');
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تم إنشاء جملة جديدة'),
            content: ListTile(
              title: Text(sentence),
              subtitle: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          FlutterClipboard.copy(sentence).then((value) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم النسخ'))));
                        },
                        icon: Icon(Icons.copy)),
                    IconButton(
                        onPressed: () {
                          Provider.of<SentencesProvider>(context, listen: false)
                              .insertIntoSentencesTable(
                                  Sentences(sentence: sentence));
                        },
                        icon: Icon(CupertinoIcons.plus_circled)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showAddSentence();
                        },
                        icon: Icon(Icons.insert_comment_outlined)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
