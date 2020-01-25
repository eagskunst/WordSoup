import 'package:flutter/material.dart';
import 'package:word_soup/ui/custom/letters_grid_view.dart';
import 'package:word_soup/utils/multi_select_child.dart';

class MultiSelectChildElement extends ProxyElement {
  MultiSelectChildElement(MultiSelectChild widget) : super(widget);

  @override
  MultiSelectChild get widget => super.widget;

  LettersGridViewState _ancestorState;

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
    _ancestorState = findAncestorStateOfType();
    _ancestorState?.elements?.add(this);
  }

  @override
  void unmount() {
    _ancestorState?.elements?.remove(this);
    _ancestorState = null;
    super.unmount();
  }

  bool containsOffset(RenderObject ancestor, Offset offset) {
    final RenderBox box = renderObject;
    final rect = box.localToGlobal(Offset.zero, ancestor: ancestor) & box.size;
    return rect.contains(offset);
  }

  void showOnScreen(EdgeInsets scrollPadding) {
    final RenderBox box = renderObject;
    box.showOnScreen(
      rect: scrollPadding.inflateRect(Offset.zero & box.size),
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void notifyClients(ProxyWidget oldWidget) {
  }
}