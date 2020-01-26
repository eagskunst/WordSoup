import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/ui/game_view.dart';


void main() => runApp(
    BlocProvider(
        creator: (_context, _bag) {
          WordsBloc();
        },
        child: MyApp()
    )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  final itemsNumber = 6;

  @override
  Widget build(BuildContext context) {
    final wordsBloc = WordsBloc();
    wordsBloc.generateWords(itemsNumber);
    return Scaffold(
      body: StreamBuilder<String>(
        stream: wordsBloc.wordsStream,
        builder: (context, snapshot) {
          if(snapshot.data == null || snapshot.data.isEmpty)
            return CircularProgressIndicator();
          else
            return GameView(sentence: snapshot.data);
        }
      ),
    );
  }

}