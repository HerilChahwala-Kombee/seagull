import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardNavigationHelper<U> {
  final int Function() getCurrentIndex;
  final void Function(int newIndex) setCurrentIndex;
  final List<U> Function() getDataList;
  final void Function(U item) onItemSelected;
  final VoidCallback? onShouldPop;

  KeyboardNavigationHelper({
    required this.getCurrentIndex,
    required this.setCurrentIndex,
    required this.getDataList,
    required this.onItemSelected,
    this.onShouldPop,
  });

  void handleKeyboardEvent(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return;
    }

    final dataList = getDataList();
    final int currentIndex = getCurrentIndex();

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (currentIndex < dataList.length - 1) {
        setCurrentIndex(currentIndex + 1);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (currentIndex > 0) {
        setCurrentIndex(currentIndex - 1);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (currentIndex >= 0 && currentIndex < dataList.length) {
        final U selectedItem = dataList[currentIndex];
        onItemSelected(selectedItem);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
      final bool metaPressed = HardwareKeyboard.instance.isMetaPressed;
      final bool controlPressed = HardwareKeyboard.instance.isControlPressed;
      final bool isApplePlatform =
          defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.iOS;

      bool shouldPop = false;

      if (metaPressed && isApplePlatform) {
        shouldPop = true;
      } else if (controlPressed && !isApplePlatform) {
        shouldPop = true;
      }
      if (shouldPop) {
        onShouldPop?.call();
        debugPrint('shouldpop -- pop router');
        // AppRouter.goRouter.pop();
      }
    }
  }
}
