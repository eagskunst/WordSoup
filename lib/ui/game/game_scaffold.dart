import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/overlay_widgets/close_game_dialog.dart';

import 'game_view.dart';

class GameScaffold extends StatefulWidget {
  @override
  _GameScaffoldState createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold> {

  var itemsNumber = 7;
  var level = 1;
  WordsBloc wordsBloc;
  StreamSubscription<SelectionEvent> _subscription;

  @override
  void initState() {
    super.initState();
    wordsBloc = BlocProvider.of(context);
    _subscription = wordsBloc.userSelectionStream.listen((event) => updateLevel(event));
    //wordsBloc.generateWords(itemsNumber);*/
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wordsBloc.generateWords(itemsNumber, BoardData.BOARD_MAP[itemsNumber].wordsNumber);
    return WillPopScope(
      onWillPop: () async => await popNavigation(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: CupertinoNavigationBar(
          leading: InkWell(
            onTap: () async {
              if(await popNavigation()){
                Navigator.pop(context);
              }
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          middle: Text(
            'Level $level',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<String>(
              stream: wordsBloc.wordsStream,
              builder: (context, snapshot) {
                if(snapshot.data == null || snapshot.data.isEmpty)
                  return progressWidget();
                else
                  return gameColumn(snapshot);
              }
          ),
        ),
      ),
    );
  }

  Future<bool> popNavigation() async => await CloseGameDialog.showCloseGameDialog(context);

  Widget gameColumn(AsyncSnapshot snapshot){
    return Column(
      children: <Widget>[
        GameView(sentence: snapshot.data, tableSize: itemsNumber, level: level),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: FloatingActionButton(
            child: Icon(Icons.update),
            onPressed: () => updateLevel(SelectionEvent.LevelCompleteSelection),
          ),
        )
      ],
    );
  }

  Widget progressWidget(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text('Loading')
            )
          ],
        )
    );
  }

  void updateLevel(SelectionEvent event){
    print("Enter update level, event: $event");
    if(event != SelectionEvent.LevelCompleteSelection) return
      print("Enter update level");
    setState(() {
      wordsBloc.cleanWordsSink();
      itemsNumber = itemsNumber == 12 ? 7 : itemsNumber+1;
      level = level == 6 ? 1 : level+1;
    });
  }
}
