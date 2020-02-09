import 'package:flutter/material.dart';

class LetterBox extends StatefulWidget {
  final int id;
  final bool isSelected;
  final String letter;
  final Color selectedColor;

  LetterBox({Key key, @required this.letter, @required this.isSelected,
    @required this.id, @required this.selectedColor}): super(key: key);

  @override
  _LetterBoxState createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> with TickerProviderStateMixin {
  static const double FULL_WIDTH = 46;
  static const double FULL_HEIGHT = 50;
  static const double BOX_SCALE = 0.85;
  var currentScale = BOX_SCALE;
  AnimationController _animController;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      lowerBound: BOX_SCALE,
      upperBound: 1.0,
      duration: Duration(milliseconds: 350)
    );
    _animController.addListener(() => setState( () => currentScale = _animController.value ));
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double scaleWidget(){
    if(widget.isSelected){
      _animController.reverse(from: 0.0);
    }
    else
      _animController.forward();
    return currentScale;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleWidget(),
      child: AnimatedContainer(
        width: FULL_WIDTH,
        height: FULL_HEIGHT,
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.only(left: 1, top: 1, right: 1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.isSelected ? widget.selectedColor : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ]),
        child: Center(
          child: Text(
            widget.letter,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : Colors.black
            ),
          ),
        ),
      ),
    );
  }
}