import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/ui/game/game_scaffold.dart';
import 'package:word_soup/ui/initial_screen/widgets/common_button.dart';

class InitialScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 150,
          child: TypewriterAnimatedTextKit(
            text: ['Word \nSoup'],
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                BlocProvider<WordsBloc>(
                    creator: (_context, bag) => WordsBloc(),
                    child: GameScaffold()
                )
            )
          ),
        ),
        CommonButton(
          text: 'Continue'.toUpperCase(),
        ),
        CommonButton(
          text: 'Instructions'.toUpperCase(),
        ),
        CommonButton(
          text: 'Delete save'.toUpperCase(),
        ),
      ],
    );
  }
}