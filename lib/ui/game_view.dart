import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/ui/widgets/letter_box.dart';
import 'package:word_soup/ui/widgets/letters_grid_view.dart';

class GameView extends StatefulWidget {

  final String sentence;
  final int tableSize;

  GameView({Key key, @required this.sentence, @required this.tableSize});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  @override
  Widget build(BuildContext context) {
    final WordsBloc wordsBloc = BlocProvider.of(context);
    final boardData = BoardData.BOARD_MAP[widget.tableSize];
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
          itemCount: widget.tableSize * widget.tableSize,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: boardData.maxCrossAxisExtent,
            crossAxisSpacing: boardData.crossAxisSpacing,
            mainAxisSpacing: boardData.mainAxisSpacing,
          ),
          itemBuilder: (context, index, selected){
            return LetterBox(
              isSelected: selected /*wordsBloc.filledIndexes.containsKey(index)*/,
              id: index,
              letter: widget.sentence[index],
            );
          }
      ),
    );
  }
}
