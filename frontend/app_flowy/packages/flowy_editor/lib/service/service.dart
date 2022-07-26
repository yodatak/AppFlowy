import 'package:flowy_editor/service/floating_shortcut_service.dart';
import 'package:flowy_editor/service/selection_service.dart';
import 'package:flutter/material.dart';

class FlowyService {
  // selection service
  final selectionServiceKey = GlobalKey(debugLabel: 'flowy_selection_service');
  FlowySelectionService get selectionService {
    assert(selectionServiceKey.currentState != null &&
        selectionServiceKey.currentState is FlowySelectionService);
    return selectionServiceKey.currentState! as FlowySelectionService;
  }

  // keyboard service
  final keyboardServiceKey = GlobalKey(debugLabel: 'flowy_keyboard_service');

  // floating shortcut service
  final floatingShortcutServiceKey =
      GlobalKey(debugLabel: 'flowy_floating_shortcut_service');
  FlowyFloatingShortcutService get floatingToolbarService {
    assert(floatingShortcutServiceKey.currentState != null &&
        floatingShortcutServiceKey.currentState
            is FlowyFloatingShortcutService);
    return floatingShortcutServiceKey.currentState!
        as FlowyFloatingShortcutService;
  }
}