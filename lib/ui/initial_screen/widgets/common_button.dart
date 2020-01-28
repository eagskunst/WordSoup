import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/models/custom_fab_props.dart';

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
        disabledColor: CustomFabProps.COMMON_COLOR.withOpacity(0.8),
        onPressed: onTap,
        padding: EdgeInsets.all(10),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        textColor: Colors.black,
        color: CustomFabProps.COMMON_COLOR,
        child: Center(
          child: Text(text.toUpperCase()),
        ),
      ),
    );
  }

}