import 'package:flutter/material.dart';

import 'custom/letter_box.dart';
import 'custom/letters_grid_view.dart';

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  final itemsNumber = 6*6;
  final dict = "qwertyuiopasdfghjklzxcvbnmqwertyuiopa";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LettersGridView(
          onSelectionChanged: (selection) => setState(() => {}),
          itemCount: itemsNumber,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 60,
            crossAxisSpacing: 8,
            mainAxisSpacing: 46,
          ),
          itemBuilder: (context, index, selected){
            return LetterBox(
              isSelected: selected,
              id: index,
              letter: dict[index],
            );
          }
      ),
    );
  }
}
