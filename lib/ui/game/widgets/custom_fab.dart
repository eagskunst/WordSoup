import 'package:flutter/material.dart';
import 'package:word_soup/models/custom_fab_props.dart';

class CustomFab extends StatelessWidget{

  final CustomFabProps props;

  const CustomFab({Key key, this.props}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: props.isEnable ? 1.0 : 0.7,
      duration: Duration(seconds: 1, milliseconds: 500),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
          onPressed: props.onTap,
          heroTag: props.name,
          mini: false,
          tooltip: props.name,
          backgroundColor: CustomFabProps.COMMON_COLOR,
          child: Icon(
            props.isEnable ? props.icon1 : props.icon2,
            color: CustomFabProps.COMMON_COLOR_IC,
          ),
        ),
      ),
    );
  }
}