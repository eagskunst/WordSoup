import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/models/board_data.dart';
import 'package:word_soup/ui/widgets/custom_fab_row.dart';
import 'package:word_soup/ui/widgets/letter_box.dart';
import 'package:word_soup/ui/widgets/letters_grid_view.dart';
import 'package:word_soup/ui/widgets/word_selection_box.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/custom_fabs_props_creator.dart';

class GameView extends StatefulWidget {

  final String sentence;
  final int tableSize;

  GameView({Key key, @required this.sentence, @required this.tableSize});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {

  var userSelection = '';

  @override
  void initState() {
    super.initState();
    final WordsBloc bloc = BlocProvider.of(context);
    bloc.userSelectionStream.listen((event) {
      if(event != null && event == SelectionEvent.ClearSelection){
        _onSelectionUpdate([]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Sentence: ${widget.sentence}");
    final WordsBloc wordsBloc = BlocProvider.of(context);
    return Column(
      children: <Widget>[
        buildGridView(),
        WordSelectionBox(selection: userSelection),
        CustomFabRow(
            fabsProps: CustomFabsPropsCreator.getProps([
                  () => wordsBloc.clearUserSelection(),
                  () => {},
                  () => showModalBottomSheet(context: context, builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(25),
                    );
                  })
            ])
        ),
      ],
    );
  }

  Widget buildGridView(){
    final boardData = BoardData.BOARD_MAP[widget.tableSize];
    return Container(
      height: 410,
      margin: EdgeInsets.all(20),
      child: LettersGridView(
          onSelectionChanged: _onSelectionChange,
          onSelectionUpdate: _onSelectionUpdate,
          itemCount: widget.tableSize * widget.tableSize,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.7,
            crossAxisCount: widget.tableSize,
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

  void _onSelectionChange(List<int> selection){
    final WordsBloc wordsBloc = BlocProvider.of(context);

    setState((){
      print("ENTER SELECTION CHANGE");
      final userSelection = _createWordFromIndexes(selection);
      if(wordsBloc.addedWords.contains(userSelection)){
        print("Word finded: $userSelection");
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

}
