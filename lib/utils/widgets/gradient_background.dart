import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget{

  final Widget child;

  const GradientBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffe3de5b),
                  Color(0xffe6c337),
                ]
            )
        ),
      child: child,
    );
  }
}