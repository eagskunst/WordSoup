import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LevelCompleteDialog {

  static Future showLevelCompleteDialog(BuildContext context, String userName, int level) =>
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                "Felicitaciones $userName!",
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
                  "Completaste el nivel $level!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MavenPro',
                      fontSize: 16),
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'MavenPro'),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Guardar y salir"),
                  isDestructiveAction: true,
                ),
                CupertinoDialogAction(
                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'MavenPro'),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Siguiente nivel"),
                  isDefaultAction: true,
                )
              ],
            );
          });
}
