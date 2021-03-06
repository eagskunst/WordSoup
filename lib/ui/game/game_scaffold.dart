import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/models/gameboard_state.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/overlay_widgets/close_game_dialog.dart';
import 'package:word_soup/utils/word_theme_generator.dart';

import 'game_view.dart';

class GameScaffold extends StatefulWidget {

  final GameBoardState boardState;
  final String name;//User's name

  const GameScaffold({Key key, this.boardState, this.name}) : super(key: key);

  @override
  _GameScaffoldState createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold>  with WidgetsBindingObserver{

  var itemsNumber = 7;
  var level = 1;
  WordsBloc wordsBloc;
  StreamSubscription<SelectionEvent> _subscription;

  @override
  void initState() {
    super.initState();
    wordsBloc = BlocProvider.of(context);
    _subscription = wordsBloc.userSelectionStream.listen((event) => updateLevel(event));
    WidgetsBinding.instance.addObserver(this);
    if(widget.boardState == null){
      wordsBloc.generateWords(itemsNumber, BoardData.BOARD_MAP[itemsNumber].wordsNumber, level);
    }
    else{
      itemsNumber = widget.boardState.tableSize;
      level = widget.boardState.level;
      wordsBloc.generateWordsFromSavedState(widget.boardState);
    }
    wordsBloc.userName = widget.name;
  }

  @override
  void dispose() {
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.paused){
      wordsBloc.saveGameBoardData(this.level);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    return WillPopScope(
      onWillPop: () async {
        final saveAndExit = await popNavigation();
        if(saveAndExit){
          await wordsBloc.saveGameBoardData(level);
        }
        return saveAndExit;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: CupertinoNavigationBar(
          leading: InkWell(
            onTap: () async {
              if(await popNavigation()){
                wordsBloc.saveGameBoardData(level).then((_) => Navigator.pop(context));
              }
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          middle: Column(
            children: [
              Text(
                'Nivel $level',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: shortestSide < 500 ? 22 : 13
                ),
              ),
              Text(
                'Jugador: ${widget.name} - Tema: ${WordThemeGenerator.getTheme(wordsBloc.themesIntegers[level-1])}',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontWeight: FontWeight.normal,
                    fontSize: shortestSide < 500 ? 12 : 10
                ),
              ),
            ]
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<String>(
              stream: wordsBloc.wordsStream,
              builder: (context, snapshot) {
                if(snapshot.data == null || snapshot.data.isEmpty)
                  return progressWidget();
                else
                  return GameView(sentence: snapshot.data, tableSize: itemsNumber, level: level);
              }
          ),
        ),
      ),
    );
  }

  Future<bool> popNavigation() async => await CloseGameDialog.showCloseGameDialog(context);

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
                child: Text('Cargando')
            )
          ],
        )
    );
  }

  void updateLevel(SelectionEvent event){
    print("Nivel actualizado, evento: $event");
    if(event != SelectionEvent.LevelCompleteSelection) return;
    if(!mounted) return;
    setState(() {
      wordsBloc.cleanWordsSink();
      itemsNumber = itemsNumber == 12 ? 7 : itemsNumber+1;
      level = level == 6 ? 1 : level+1;
      if(level == 1) wordsBloc.themesIntegers.clear();
      wordsBloc.generateWords(itemsNumber, BoardData.BOARD_MAP[itemsNumber].wordsNumber, level);
    });
  }
}
