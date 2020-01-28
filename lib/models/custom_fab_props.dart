import 'package:flutter/material.dart';

class CustomFabProps {
  final String name;
  final VoidCallback onTap;
  final IconData icon1;
  final IconData icon2;
  final bool isEnable;

  CustomFabProps({@required this.onTap, this.icon1, this.name, this.icon2 = Icons.add, this.isEnable = true});

  static const COMMON_COLOR = Colors.amberAccent;
  static const COMMON_COLOR_IC = Colors.white;

}