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
                  "Quieres salir del juego?",
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
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'MavenPro'),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Guardar y salir"),
                  isDestructiveAction: true,
                ),
                CupertinoDialogAction(
                  textStyle:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'MavenPro'),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Continuar"),
                  isDefaultAction: true,
                )
              ],
            );
          });
}