import 'package:window_manager/window_manager.dart';

abstract class WindowControls {
  Future<void> close();
  Future<void> minimize();
  Future<bool> isMaximized();
  Future<void> maximizeOrUnmaximize();
}

// coverage:ignore-start
class WindowManagerControls implements WindowControls {
  @override
  Future<void> close() => windowManager.close();

  @override
  Future<void> minimize() => windowManager.minimize();

  @override
  Future<bool> isMaximized() => windowManager.isMaximized();

  @override
  Future<void> maximizeOrUnmaximize() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }
}

WindowControls windowControls = WindowManagerControls();
// coverage:ignore-end
