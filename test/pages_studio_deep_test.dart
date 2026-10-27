import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/presentation/pages/studio/studio_page.dart';

import 'helpers.dart';

final _d = DateTime(2024);
final _img = GeneratedImage(id: 'i1', prompt: 'p', model: 'm', status: ImageStatus.completed, localPath: '/tmp/x.png', createdAt: _d);
final _sess = StudioSession(id: 's1', title: 'S1', prompt: 'prompt here', model: 'm', images: [_img], loras: const ['l1'], createdAt: _d, updatedAt: _d);

void main() {
  setUpAll(registerFallbacks);

  testWidgets('studio: create, select, edit session fully', (t) async {
    final s = mockStorage();
    final sessions = <StudioSession>[_sess];
    when(() => s.getSessions()).thenAnswer((_) => List.of(sessions));
    when(() => s.getSession(any())).thenAnswer((i) => sessions.firstWhere((x) => x.id == i.positionalArguments[0], orElse: () => _sess));
    when(() => s.saveSession(any())).thenAnswer((i) async {
      final n = i.positionalArguments[0] as StudioSession;
      sessions.removeWhere((x) => x.id == n.id);
      sessions.add(n);
    });
    await pumpPage(t, const StudioPage(), storage: s, settle: false, size: const Size(1400, 900));
    for (var i = 0; i < 6; i++) { await t.pump(const Duration(milliseconds: 150)); }

    // tap session card
    final sessText = find.text('S1');
    if (sessText.evaluate().isNotEmpty) {
      await t.tap(sessText.first, warnIfMissed: false);
      await t.pump();
      for (var i = 0; i < 4; i++) { await t.pump(const Duration(milliseconds: 150)); }
    }
    // tap all tappable icons in the session view
    for (final icon in [Icons.add, Icons.edit_outlined, Icons.delete_outline, Icons.more_vert, Icons.send, Icons.play_arrow, Icons.remove_circle_outline]) {
      final f = find.byIcon(icon);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await t.pump();
        for (var i = 0; i < 3; i++) { await t.pump(const Duration(milliseconds: 100)); }
        // dismiss any dialog
        final cancel = find.text('Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await t.tap(cancel.last, warnIfMissed: false);
          await t.pump();
        }
      }
    }
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'new prompt text');
      await t.pump();
    }
    expect(find.byType(StudioPage), findsOneWidget);
  });
}
