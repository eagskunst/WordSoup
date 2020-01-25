import 'package:flutter/material.dart';
import 'package:word_soup/ui/custom/letter_box.dart';
import 'package:word_soup/ui/custom/letters_grid_view.dart';
import 'package:word_soup/ui/game_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  final itemsNumber = 6*6;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GameView(),
    );
  }

}