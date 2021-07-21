import 'package:flutter/material.dart';
import 'package:my_words/home.dart';
import 'package:my_words/providers/sentences_provider.dart';
import 'package:my_words/providers/word_providers.dart';
import 'package:provider/provider.dart';

import 'helpers/db_helpers.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) {
      Provider.of<WordProvider>(context, listen: false).getAllBook();
      Provider.of<SentencesProvider>(context, listen: false).getAllSente();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe1e2e1),
      body: Image.asset(
        'assets/images/words.png',
        fit: BoxFit.fitHeight,
        height: 737.4545,
      ),
    );
  }
}
