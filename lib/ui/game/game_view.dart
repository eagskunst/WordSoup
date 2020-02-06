import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/ui/game/widgets/custom_fab_row.dart';
import 'package:word_soup/ui/game/widgets/letter_box.dart';
import 'package:word_soup/ui/game/widgets/letters_grid_view.dart';
import 'package:word_soup/ui/game/widgets/word_selection_box.dart';
import 'package:word_soup/utils/constants.dart';
import 'package:word_soup/utils/overlay_widgets/game_complete_dialog.dart';
import 'package:word_soup/utils/overlay_widgets/level_complete_dialog.dart';
import 'package:word_soup/utils/overlay_widgets/words_bottom_sheet.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/custom_fabs_props_creator.dart';
import 'package:word_soup/utils/snackbar_util.dart';
import 'package:word_soup/utils/widgets/debug_button.dart';

class GameView extends StatefulWidget {

  final String sentence;
  final int tableSize;
  final int level;

  GameView({Key key, @required this.sentence, @required this.tableSize, @required this.level});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  var userSelection = '';
  WordsBloc wordsBloc;
  StreamSubscription<SelectionEvent> _subscription;

  @override
  void initState() {
    super.initState();
    wordsBloc = BlocProvider.of(context);
    _subscription = wordsBloc.userSelectionStream.listen((event) {
      if(event != null){
        checkEvent(event);
      }
    });

    print("Sentence: ${widget.sentence}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildGridView(),
        WordSelectionBox(selection: userSelection),
        CustomFabRow(
            fabsProps: CustomFabsPropsCreator.getProps(
                [
                  () => wordsBloc.clearUserSelection(),
                  () => wordsBloc.checkUserSelection(),
                  () => showModalBottomSheet(context: context,
                    builder: (context) => WordsBottomSheet(words: wordsBloc.createSoupWordsWidget()),
                  ),
                  () => wordsBloc.unlockWordEnable ? unlockWord() : SnackBarUtil.createErrorSnack(context, 'You have already unlocked a word')
                ],
                wordsBloc.unlockWordEnable
            )
        ),
        DebugButton(//Debug button
          showBtn: true,
          onPressed: () => wordsBloc.triggerLevelComplete(),
        ),
      ],
    );
  }

  Widget buildGridView(){
    final size = MediaQuery.of(context).size;
    final boardData = BoardData.responsiveBoardMap(size)[widget.tableSize];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 0.99,
        child: LettersGridView(
            onSelectionEnd: _onSelectionEnd,
            onSelectionUpdate: _onSelectionUpdate,
            foundIndexes: wordsBloc.getUserFoundWordsIndices(),
            itemCount: widget.tableSize * widget.tableSize,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: widget.tableSize,
              crossAxisSpacing: boardData.crossAxisSpacing,
              mainAxisSpacing: boardData.mainAxisSpacing,
            ),
            itemBuilder: (context, index, selected){
              return LetterBox(
                isSelected: selected,
                id: index,
                letter: widget.sentence[index],
                selectedColor: wordsBloc.getLetterColorByIndex(index),
              );
            }
        ),
      ),
    );
  }

  void _onSelectionEnd(List<int> selection){
    final userSelection = _createWordFromIndexes(selection);

    setState((){
      print("On selection end");
      if(wordsBloc.addedWords.contains(userSelection)){
        print("Word finded: $userSelection");
        if(wordsBloc.getUserFoundWords().contains(userSelection)){
          SnackBarUtil.createErrorSnack(context, 'You have already found $userSelection');
        }
        else{
          wordsBloc.addUserFoundWord(userSelection, selection);
          if(wordsBloc.getUserFoundWords().length == wordsBloc.addedWords.length){
            if(widget.level != 6) createLevelCompletedDialog();
            else createGameCompleteDialog();
          }
          else{
            SnackBarUtil.createSuccessSnack(context, 'You found $userSelection!');
          }
          wordsBloc.clearUserSelection();
        }
      }
      else{
        SnackBarUtil.createErrorSnack(context, 'Ups! That did not match a soup word');
        wordsBloc.clearUserSelection();
      }
    });
  }

  void _onSelectionUpdate(List<int> selection) => setState(() => userSelection = _createWordFromIndexes(selection));

  String _createWordFromIndexes(List<int> selection){
    final buffer = StringBuffer();
    selection.forEach( (ind) => ind != -1 ? buffer.write(widget.sentence[ind]) : {});
    return buffer.toString();
  }

  void checkEvent(SelectionEvent event){
    if(event == SelectionEvent.ClearSelection) _onSelectionUpdate([]);
  }

  void createLevelCompletedDialog() async {
    final goNextLevel = await LevelCompleteDialog.showLevelCompleteDialog(context, wordsBloc.userName, widget.level);
    if(goNextLevel) wordsBloc.triggerLevelComplete();
  }

  void createGameCompleteDialog() async {
    await GameCompleteDialog.showGameCompleteDialog(context, wordsBloc.userName);
    await SharedPreferences.getInstance()
      ..setString(Constants.GAME_BOARD_STATE_KEY, null);
    Navigator.pop(context);
  }

  void unlockWord() {
    wordsBloc.clearUserSelection();
    _onSelectionEnd(wordsBloc.getNotFoundWordIndexes());
    wordsBloc.unlockWordEnable = false;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

}
