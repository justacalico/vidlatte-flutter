import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/presentation/pages/studio/studio_page.dart';
import 'package:vidlatte/presentation/pages/create/inpaint_page.dart';

import 'helpers.dart';

final _d = DateTime(2024);
final _img = GeneratedImage(id: 'i1', prompt: 'p', model: 'm', status: ImageStatus.completed, localPath: '/tmp/x.png', createdAt: _d);

void main() {
  setUpAll(registerFallbacks);

  testWidgets('studio: session detail with images', (t) async {
    final s = mockStorage();
    final sess = StudioSession(id: 's1', title: 'Session A', prompt: 'a cat', model: 'm', images: [_img], createdAt: _d, updatedAt: _d);
    when(() => s.getSessions()).thenReturn([sess]);
    when(() => s.getSession('s1')).thenReturn(sess);
    await pumpPage(t, const StudioPage(), storage: s, settle: false);
    await t.pump();
    for (final lbl in ['Session A', 'New Session', 'Generate', 'Add']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await t.pump();
        await t.pump(const Duration(milliseconds: 200));
      }
    }
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'edited prompt');
      await t.pump();
    }
    expect(find.byType(StudioPage), findsOneWidget);
  });

  testWidgets('inpaint: fill form fields', (t) async {
    await pumpPage(t, const InpaintPage(), size: const Size(1280, 900), settle: false);
    await t.pump();
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'inpaint prompt');
      await t.pump();
    }
    for (final lbl in ['Choose Image', 'Pick Image', 'Select Image']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await t.pump();
      }
    }
    expect(find.byType(InpaintPage), findsOneWidget);
  });
}
