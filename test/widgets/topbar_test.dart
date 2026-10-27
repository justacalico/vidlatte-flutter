import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/presentation/widgets/shell/desktop_top_bar.dart';
import 'package:vidlatte/utils/platform_utils.dart';

import '../flutter_test_config.dart';
import '../helpers.dart';

void main() {
  setUpAll(registerFallbacks);

  testWidgets('top bar buttons drive window controls', (t) async {
    fakeWindowControls.closed = false;
    fakeWindowControls.minimized = false;
    fakeWindowControls.maximized = false;
    fakeWindowControls.toggleCount = 0;
    await pumpPage(t, const Scaffold(body: DesktopTopBar()), size: const Size(1280, 800));

    final gesture = await t.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.moveTo(t.getCenter(find.byType(DesktopTopBar)));
    await t.pump();

    await t.tap(find.bySemanticsLabel('close'));
    await t.pump();
    expect(fakeWindowControls.closed, isTrue);

    await t.tap(find.bySemanticsLabel('minimize'));
    await t.pump();
    expect(fakeWindowControls.minimized, isTrue);

    await t.tap(find.bySemanticsLabel('maximize'));
    await t.pump();
    expect(fakeWindowControls.toggleCount, 1);

    await gesture.removePointer();
  });

  testWidgets('top bar hidden on non-desktop', (t) async {
    debugDesktopPlatformOverride = false;
    addTearDown(() => debugDesktopPlatformOverride = true);
    await pumpPage(t, const Scaffold(body: DesktopTopBar()), size: const Size(400, 800));
    expect(find.bySemanticsLabel('close'), findsNothing);
  });
}
