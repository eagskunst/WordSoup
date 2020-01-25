import 'package:flutter/material.dart';

class LetterBox extends StatefulWidget {
  final int id;
  final bool isSelected;

  LetterBox({Key key, this.isSelected, this.id}): super(key: key);

  @override
  _LetterBoxState createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 50,
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.isSelected ? Colors.indigo : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ]),
    );
  }
}