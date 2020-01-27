import 'package:flutter/material.dart';
import 'package:word_soup/utils/widgets/multi_select_child_element.dart';

class MultiSelectChild extends ProxyWidget {
  const MultiSelectChild({
    Key key,
    @required this.index,
    @required Widget child,
  }) : super(key: key, child: child);

  final int index;

  @override
  MultiSelectChildElement createElement() => MultiSelectChildElement(this);
}