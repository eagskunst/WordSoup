import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {

  final bool showBtn;
  final VoidCallback onPressed;

  const DebugButton({Key key, this.showBtn, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showBtn ? Container(
        margin: EdgeInsets.only(top: 15),
        child: FloatingActionButton(
          child: Icon(Icons.update),
          onPressed: onPressed,
        )
    ) : Container();
  }
}
