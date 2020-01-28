import 'package:flutter/material.dart';

class WordSelectionBox extends StatelessWidget {

  final String selection;
  final double margin1 = 25;
  final double margin2 = 5;

  const WordSelectionBox({Key key, this.selection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: EdgeInsets.only(left: margin1, right: margin1, top: margin2, bottom: margin2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            blurRadius: 6,
            spreadRadius: 0.8,
          )
        ]
      ),
      child: Center(
        child: Text(
          selection,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'MavenPro',
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: selection.length > 30 ? 16 : 25
          ),
        ),
      ),
    );
  }
}
