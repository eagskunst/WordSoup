import 'package:flutter/material.dart';

class CustomFabProps {
  final String name;
  final VoidCallback onTap;
  final IconData icon;

  CustomFabProps({@required this.onTap, this.icon, this.name});

  static const COMMON_COLOR = Colors.amberAccent;
  static const COMMON_COLOR_IC = Colors.white;

}