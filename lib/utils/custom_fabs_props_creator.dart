import 'package:flutter/material.dart';
import 'package:word_soup/models/custom_fab_props.dart';

class CustomFabsPropsCreator {

  static List<CustomFabProps> getProps(List<VoidCallback> callbacks, bool unlockWordEnable) => [
    CustomFabProps(
        icon1: Icons.delete,
        name: "Clear selection",
        onTap: callbacks[0]
    ),
    CustomFabProps(
        icon1: Icons.check,
        name: "Confirm selection",
        onTap: callbacks[1]
    ),
    CustomFabProps(
        icon1: Icons.assignment,
        name: "Clues",
        onTap: callbacks[2]
    ),
    CustomFabProps(
        icon1: Icons.lock_open,
        icon2: Icons.lock_outline,
        isEnable: unlockWordEnable,
        name: "Unlock one word",
        onTap: callbacks[3],
    ),
  ];
}