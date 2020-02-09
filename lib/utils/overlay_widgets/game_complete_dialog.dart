import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameCompleteDialog {
  static Future showGameCompleteDialog(context, String userName) =>
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
                  "Completaste todos los niveles!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'MavenPro'),
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar",
                  style: TextStyle(fontFamily: 'MavenPro'),
                  ),
                  isDestructiveAction: true,
                ),
              ],
            );
          });
}