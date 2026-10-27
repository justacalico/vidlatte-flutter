import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/services/window_controls.dart';
import 'package:vidlatte/utils/platform_utils.dart';

class FakeWindowControls implements WindowControls {
  bool closed = false;
  bool minimized = false;
  bool maximized = false;
  int toggleCount = 0;

  @override
  Future<void> close() async => closed = true;

  @override
  Future<void> minimize() async => minimized = true;

  @override
  Future<bool> isMaximized() async => maximized;

  @override
  Future<void> maximizeOrUnmaximize() async {
    maximized = !maximized;
    toggleCount++;
  }
}

FakeWindowControls fakeWindowControls = FakeWindowControls();

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final roboto = FontLoader('Roboto')
    ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
  await roboto.load();

  windowControls = fakeWindowControls;
  debugDesktopPlatformOverride = true;

  await testMain();
}
