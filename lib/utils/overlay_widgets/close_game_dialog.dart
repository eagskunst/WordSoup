import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseGameDialog {
  static Future showCloseGameDialog(context) =>
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  "Do you you want to quit the game?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MavenPro',
                      fontSize: 22),
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  textStyle:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Save and quit"),
                ),
                CupertinoDialogAction(
                  textStyle:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Continue"),
                )
              ],
            );
          });
}