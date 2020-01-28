import 'package:flutter/material.dart';
import 'package:word_soup/models/custom_fab_props.dart';

class CustomFab extends StatelessWidget{

  final CustomFabProps props;

  const CustomFab({Key key, this.props}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: FloatingActionButton(
        onPressed: props.onTap,
        heroTag: props.name,
        mini: false,
        tooltip: props.name,
        backgroundColor: CustomFabProps.COMMON_COLOR,
        child: Icon(
          props.icon,
          color: CustomFabProps.COMMON_COLOR_IC,
        ),
      ),
    );
  }
}