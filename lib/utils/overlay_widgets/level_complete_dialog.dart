import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LevelCompleteDialog {

  static Future showLevelCompleteDialog(BuildContext context, String userName, int level) =>
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                "Congratulations $userName!",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color(0xff32DE8A),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MavenPro',
                    fontSize: 26),
              ),
              content: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "You completed level $level!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Save and quit"),
                ),
                CupertinoDialogAction(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Next level"),
                )
              ],
            );
          });
}
