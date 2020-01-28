import 'package:flutter/material.dart';
import 'package:word_soup/models/custom_fab_props.dart';
import 'custom_fab.dart';

class CustomFabRow extends StatelessWidget {

  final List<CustomFabProps> fabsProps;

  const CustomFabRow({Key key, this.fabsProps}) : super(key: key);

  List<CustomFab> get buttons => fabsProps.map( (props) => CustomFab(props: props)).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttons,
    );
  }
}