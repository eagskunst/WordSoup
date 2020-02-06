import 'dart:async';
import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/blocs/words_bloc.dart';
import 'package:word_soup/utils/base/selection_event.dart';
import 'package:word_soup/utils/widgets/multi_select_child.dart';
import 'package:word_soup/utils/widgets/multi_select_child_element.dart';

typedef LettersGridViewBuilder = Widget Function(BuildContext context, int index, bool isSelected);
typedef OnSelectionEnd = void Function(List<int> selection);
typedef OnSelectionUpdate = void Function(List<int> selection);
typedef SumBy = int Function(int position);

class LettersGridView extends StatefulWidget {

  //TODO: Pass finded words index as parameter
  const LettersGridView({
    Key key,
    this.onSelectionEnd,
    this.onSelectionUpdate,
    this.foundIndexes,
    this.padding,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.gridDelegate,
    this.scrollPadding = const EdgeInsets.all(48.0),
  }) : super(key: key);

  final OnSelectionEnd onSelectionEnd;
  final OnSelectionUpdate onSelectionUpdate;
  final List<int> foundIndexes;
  final EdgeInsetsGeometry padding;
  final int itemCount;
  final LettersGridViewBuilder itemBuilder;
  final SliverGridDelegate gridDelegate;
  final EdgeInsets scrollPadding;

  @override
  LettersGridViewState createState() => LettersGridViewState();
}

class LettersGridViewState extends State<LettersGridView> {
  final elements = List<MultiSelectChildElement>();

  bool _isSelecting = false;
  bool _moreThanTwo = false;
  bool _goingBackwards = false;
  int _startIndex = -1;
  final indexList = List<int>();
  var _admittedPositions = List<int>();

  StreamSubscription<SelectionEvent> _subscription;

  @override
  void initState() {
    super.initState();
    final WordsBloc bloc = BlocProvider.of(context);
    _subscription = bloc.userSelectionStream.listen((event) {
      print("Event: $event");
      if(event != null){
        switch(event){
          case SelectionEvent.ClearSelection:
            setState(() => indexList.clear());
            break;
          case SelectionEvent.CheckSelection:
            widget.onSelectionEnd.call(indexList);
            break;
          case SelectionEvent.LevelCompleteSelection:
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onLongPressMoveUpdate: _onLongPressUpdate,
      onLongPressEnd: _onLongPressEnd,
      child: IgnorePointer(
        ignoring: _isSelecting,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: widget.padding,
          itemCount: widget.itemCount,
          itemBuilder: (BuildContext context, int index) {
            final selected = indexList.contains(index) || widget.foundIndexes.contains(index);
            return MultiSelectChild(
              index: index,
              child: widget.itemBuilder(context, index, selected),
            );
          },
          gridDelegate: widget.gridDelegate,
        ),
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    final startIndex = _findMultiSelectChildFromOffset(details.localPosition);
    indexList.clear();
    _admittedPositions.clear();
    indexList.add(startIndex);
    _moreThanTwo = false;
    _setSelection(startIndex);
    setState(() => _isSelecting = (startIndex != -1));
  }

  void _onLongPressUpdate(LongPressMoveUpdateDetails details) {
    if (_isSelecting) {
      _updateEndIndex(details.localPosition);
      if(widget.onSelectionUpdate != null)
        widget.onSelectionUpdate?.call(indexList);
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _updateEndIndex(details.localPosition);
    setState(() => _isSelecting = false);
  }

  void _updateEndIndex(Offset localPosition) {
    int endIndex = _findMultiSelectChildFromOffset(localPosition);
    if(!_moreThanTwo && endIndex != _startIndex && endIndex != -1){
      _moreThanTwo = true;
      if(endIndex < _startIndex) _goingBackwards = true;
      else _goingBackwards = false;
      indexList.add(endIndex);
      _admittedPositions = _calculateAdmittedPositions();
    }
    else if (endIndex != -1){
      final lastIndex = indexList.last;
      if(lastIndex != endIndex && _goingBackwards){
        if(endIndex < lastIndex){
          if(!indexList.contains(endIndex) && _admittedPositions.contains(endIndex))
            indexList.add(endIndex);
        }
        else if(_admittedPositions.contains(endIndex)){
          indexList.remove(lastIndex);
          endIndex = indexList.last;
          if(indexList.length == 1)
            _moreThanTwo = false;
        }
      }
      else if(lastIndex != endIndex && !_goingBackwards){
        if(endIndex > lastIndex){
          if(!indexList.contains(endIndex) && _admittedPositions.contains(endIndex))
            indexList.add(endIndex);
        }
        else if(_admittedPositions.contains(endIndex)){
          indexList.remove(lastIndex);
          endIndex = indexList.last;
          if(indexList.length == 1)
            _moreThanTwo = false;
        }
      }
      else{
        if(!indexList.contains(endIndex) && _admittedPositions.contains(endIndex))
          indexList.add(endIndex);
      }
    }
    if (endIndex != -1) {
      _setSelection(_startIndex);
    }
  }

  void _setSelection(int start) {
    setState(() {
      _startIndex = start;
    });
  }

  int _findMultiSelectChildFromOffset(Offset offset) {
    final ancestor = context.findRenderObject();
    for (MultiSelectChildElement element in List.from(elements)) {
      if (element.containsOffset(ancestor, offset)) {
        if (widget.scrollPadding != null) {
          element.showOnScreen(widget.scrollPadding);
        }
        return element.widget.index;
      }
    }
    return -1;
  }

  List<int> _calculateAdmittedPositions(){
    final first = indexList.first;
    final last = indexList.last;

    final tableSize = sqrt(widget.itemCount).toInt();
    final offsetColumns = List<int>();

    if(last == first+tableSize || last == first-tableSize){
      for(var i = 0; i < tableSize; i++){
        offsetColumns.add(i);
        offsetColumns.add( (tableSize * (tableSize - 1)) + i);
      }
    }
    else{
      for(var i = 0; i < tableSize; i++){
        offsetColumns.add(i * tableSize);
        offsetColumns.add( (i * tableSize) + tableSize - 1);
      }
    }

    var newPos = last;
    //Normal horizontal
    if(last == first+1){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position+1);
    }
    //Backwards horizontal
    else if(last == first-1){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position-1);
    }

    //Normal vertical
    else if(last == first+tableSize){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position+tableSize);
    }


    //Backwards vertical
    else if(last == first-tableSize){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position-tableSize);
    }

    //Normal diagonal
    else if(last == first+tableSize+1){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position+tableSize+1);
    }

    //Backwards diagonal
    else if(last == first-tableSize-1){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position-tableSize-1);
    }

    //Second diagonal
    else if(last == first-tableSize+1){
      return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position-tableSize+1);
    }

    //Second diagonal backwards
    return _addAdmittedPositions(first, newPos, offsetColumns, (final position) => position+tableSize-1);
  }

  List<int> _addAdmittedPositions(final int first, int newPos, final List<int> offsetColumns, final SumBy sumBy){
    final positions = [first];

    if(offsetColumns.contains(newPos)){
      positions.add(newPos);
    }

    while(!offsetColumns.contains(newPos) && newPos < widget.itemCount && newPos > 0){
      positions.add(newPos);
      newPos = sumBy(newPos);
    }

    if(offsetColumns.contains(newPos)){
      positions.add(newPos);
    }
    return positions;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

}