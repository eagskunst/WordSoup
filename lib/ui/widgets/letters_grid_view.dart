import 'package:flutter/material.dart';
import 'package:word_soup/utils/widgets/multi_select_child.dart';
import 'package:word_soup/utils/widgets/multi_select_child_element.dart';

typedef LettersGridViewBuilder = Widget Function(BuildContext context, int index, bool isSelected);
typedef OnSelectionChange = void Function(List<int> selection);

class LettersGridView extends StatefulWidget {

  //TODO: Pass finded words index as parameter
  const LettersGridView({
    Key key,
    this.onSelectionChanged,
    this.padding,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.gridDelegate,
    this.scrollPadding = const EdgeInsets.all(48.0),
  }) : super(key: key);

  final OnSelectionChange onSelectionChanged;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onLongPressMoveUpdate: _onLongPressUpdate,
      onLongPressEnd: _onLongPressEnd,
      child: IgnorePointer(
        ignoring: _isSelecting,
        child: GridView.builder(
          padding: widget.padding,
          itemCount: widget.itemCount,
          itemBuilder: (BuildContext context, int index) {
            final selected = indexList.contains(index);
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
    indexList.add(startIndex);
    _moreThanTwo = false;
    _setSelection(startIndex);
    setState(() => _isSelecting = (startIndex != -1));
  }

  void _onLongPressUpdate(LongPressMoveUpdateDetails details) {
    if (_isSelecting) {
      _updateEndIndex(details.localPosition);
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _updateEndIndex(details.localPosition);
    setState(() => _isSelecting = false);
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged?.call(indexList);
    }
  }

  void _updateEndIndex(Offset localPosition) {
    int endIndex = _findMultiSelectChildFromOffset(localPosition);
    if(!_moreThanTwo && endIndex != _startIndex && endIndex != -1){
      _moreThanTwo = true;
      if(endIndex < _startIndex) _goingBackwards = true;
      else _goingBackwards = false;
      indexList.add(endIndex);
    }
    else if (endIndex != -1){
      final lastIndex = indexList.last;
      if(lastIndex != endIndex && _goingBackwards){
        if(endIndex < lastIndex){
          if(!indexList.contains(endIndex))
            indexList.add(endIndex);
        }
        else{
          indexList.remove(lastIndex);
          endIndex = indexList.last;
          if(indexList.length == 1)
            _moreThanTwo = false;
        }
      }
      else if(lastIndex != endIndex && !_goingBackwards){
        if(endIndex > lastIndex){
          if(!indexList.contains(endIndex))
            indexList.add(endIndex);
        }
        else{
          indexList.remove(lastIndex);
          endIndex = indexList.last;
          if(indexList.length == 1)
            _moreThanTwo = false;
        }
      }
      else{
        if(!indexList.contains(endIndex))
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

}