import 'package:flutter/material.dart';

import 'custom/letter_box.dart';
import 'custom/letters_grid_view.dart';

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
    print("Sentence: ${widget.sentence}");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(20),
      child: LettersGridView(
          onSelectionChanged: (selection) => setState(() => {}),
          itemCount: tableSize * tableSize,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 50,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index, selected){
            return LetterBox(
              isSelected: selected,
              id: index,
              letter: widget.sentence[index],
            );
          }
      ),
    );
  }
}
