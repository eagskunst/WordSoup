import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroduceNameDialog {

  static Future showInputNameDialog(context) =>
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return _IntroduceNameDialog();
          });
}

class _IntroduceNameDialog extends StatefulWidget {
  @override
  _IntroduceNameDialogState createState() => _IntroduceNameDialogState();

}

class _IntroduceNameDialogState extends State<_IntroduceNameDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: EdgeInsets.all(25),
        child: Text(
          "Ingresa tu nombre: ",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontFamily: 'MavenPro',
              fontSize: 22),
        ),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: CupertinoTextField(
          onChanged: (t) => setState( () =>{}),
          controller: controller,
          maxLength: 20,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          style: TextStyle(
            fontFamily: 'MavenPro'
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          textStyle:
          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          onPressed: controller.text.isEmpty ? null : () => Navigator.pop(context, controller.text),
          child: Text("Guardar"),
        ),
      ],
    );
  }
}
