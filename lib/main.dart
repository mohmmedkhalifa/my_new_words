import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_words/models/words.dart';
import 'package:my_words/providers/sentences_provider.dart';
import 'package:my_words/providers/word_providers.dart';
import 'package:my_words/splash.dart';
import 'package:provider/provider.dart';

import 'helpers/db_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var s = await DBHelper.dbHelper.initializeTasksDatabase();
  await DBHelper.dbHelper.connectToDatabase();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
       ChangeNotifierProvider(create: (context)=>WordProvider()),
       ChangeNotifierProvider(create: (context)=>SentencesProvider()),
    ],
      child: MaterialApp(
        title: 'كلماتي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Kufa',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Splash(),
      ),
    );
  }
}
