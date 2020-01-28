import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget{

  final VoidCallback onTap;
  final String text;

  const CommonButton({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: RaisedButton(
        disabledColor: Colors.amberAccent.withOpacity(0.8),
        onPressed: onTap,
        padding: EdgeInsets.all(10),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        textColor: Colors.black,
        color: Colors.amberAccent,
        child: Center(
          child: Text(text.toUpperCase()),
        ),
      ),
    );
  }

}