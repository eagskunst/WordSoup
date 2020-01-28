import 'package:flutter/material.dart';

class SnackBarUtil {

  static void createErrorSnack(BuildContext context, String msg) => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
    )
  );


  static void createSuccessSnack(BuildContext context, String msg) => Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.lightBlueAccent,
      )
  );
}