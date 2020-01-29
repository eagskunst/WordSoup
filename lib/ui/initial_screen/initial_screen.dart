import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/gameboard_state.dart';
import 'package:word_soup/ui/game/game_scaffold.dart';
import 'package:word_soup/ui/initial_screen/widgets/common_button.dart';
import 'package:word_soup/utils/constants.dart';

class InitialScreen extends StatefulWidget{

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> with WidgetsBindingObserver {

  GameBoardState _gameboardState;

  void loadGameBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final boardString = prefs.getString(Constants.GAME_BOARD_STATE_KEY);
    if(boardString != null){
      Map boardJson = jsonDecode(boardString);
      final boardState = GameBoardState.fromJson(boardJson);
      setState(() => _gameboardState = boardState);
    }
    else setState(() => _gameboardState = null);
  }

  void deleteGameBoard() async {
    await SharedPreferences.getInstance()
        ..setString(Constants.GAME_BOARD_STATE_KEY, null);
    setState(() => _gameboardState = null);
  }

  @override
  Widget build(BuildContext context) {
    loadGameBoard();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 150,
          child: TypewriterAnimatedTextKit(
            text: ['Word \nSearch'],
            textAlign: TextAlign.center,
            isRepeatingAnimation: true,
            speed: Duration(milliseconds: 500),
            totalRepeatCount: 100000, // :p
            textStyle: TextStyle(
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.bold,
              fontSize: 48
            ),
            pause: Duration(seconds: 2),
          ),
        ),
        CommonButton(
          text: 'New game'.toUpperCase(),
          onTap: () => navigateToGame(context, null),
        ),
        CommonButton(
          text: 'Continue'.toUpperCase(),
          onTap: _gameboardState == null ? null : () => navigateToGame(context, _gameboardState),
        ),
        CommonButton(
          text: 'Instructions'.toUpperCase(),
        ),
        CommonButton(
          text: 'Delete save'.toUpperCase(),
          onTap: _gameboardState == null ? null : () => deleteGameBoard(),
        ),
      ],
    );
  }

  void navigateToGame(BuildContext context, GameBoardState gameBoardState){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            BlocProvider<WordsBloc>(
                creator: (_context, bag) => WordsBloc(),
                child: GameScaffold(boardState: gameBoardState)
            )
        )
    );
  }
}