import 'package:flutter/material.dart';
import 'package:word_soup/models/custom_fab_props.dart';

class CustomFabsPropsCreator {

  static List<CustomFabProps> getProps(List<VoidCallback> callbacks) => [
    CustomFabProps(
        icon: Icons.delete,
        name: "Clear selection",
        onTap: callbacks[0]
    ),
    CustomFabProps(
        icon: Icons.check,
        name: "Confirm selection",
        onTap: callbacks[1]
    ),
    CustomFabProps(
        icon: Icons.assignment,
        name: "Words list",
        onTap: callbacks[2]
    ),
  ];
}