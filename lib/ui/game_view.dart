import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/ui/widgets/letter_box.dart';
import 'package:word_soup/ui/widgets/letters_grid_view.dart';

class GameView extends StatefulWidget {

  final String sentence;

  GameView({Key key, @required this.sentence});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  final tableSize = 6;

  @override
  Widget build(BuildContext context) {
    final WordsBloc wordsBloc = BlocProvider.of(context);

    print("Sentence: ${widget.sentence}");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(20),
      child: LettersGridView(
          onSelectionChanged: (selection) => setState((){
            print("ENTER SELECTION CHANGE");
            final buffer = StringBuffer();
            selection.forEach( (ind) => ind != -1 ? buffer.write(widget.sentence[ind]) : {});
            if(wordsBloc.addedWords.contains(buffer.toString())){
              print("Word finded: ${buffer.toString()}");
            }
          }),
          itemCount: tableSize * tableSize,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 50,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index, selected){
            return LetterBox(
              isSelected: wordsBloc.filledIndexes.containsKey(index),
              id: index,
              letter: widget.sentence[index],
            );
          }
      ),
    );
  }
}
