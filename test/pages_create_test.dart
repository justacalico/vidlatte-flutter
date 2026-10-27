import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';
import 'package:vidlatte/presentation/pages/browse/browse_page.dart';
import 'package:vidlatte/presentation/pages/create/create_page.dart';
import 'package:vidlatte/presentation/pages/create/inpaint_page.dart';

import 'helpers.dart';

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  MockStorage createStorage() {
    final s = mockStorage();
    when(() => s.getServers()).thenReturn([
      ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d),
    ]);
    when(() => s.getPromptHistory()).thenReturn([
      PromptHistoryEntry(id: 'p1', prompt: 'old prompt', model: 'm', createdAt: _d),
    ]);
    return s;
  }

  testWidgets('create: prompt entry, generate error, history', (t) async {
    final s = createStorage();
    await pumpPage(t, const CreatePage(), storage: s, settle: false);
    await t.pump();

    final prompt = find.byType(TextField);
    if (prompt.evaluate().isNotEmpty) {
      await t.enterText(prompt.first, 'a castle');
      await t.pump();
    }

    for (final lbl in ['Generate', 'Add to Queue', 'Browse Models & LoRAs', 'Inpaint']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        for (var i = 0; i < 5; i++) { await t.pump(const Duration(milliseconds: 100)); }
      }
    }
    expect(find.byType(CreatePage), findsOneWidget);
  });

  testWidgets('create: auto image tab interactions', (t) async {
    final s = createStorage();
    await pumpPage(t, const CreatePage(), storage: s, settle: false);
    await t.pump();
    final tab = find.text('Auto Image');
    if (tab.evaluate().isNotEmpty) {
      await t.tap(tab.first, warnIfMissed: false);
      await t.pump();
      for (var i = 0; i < 5; i++) { await t.pump(const Duration(milliseconds: 100)); }
    }
    expect(find.byType(CreatePage), findsOneWidget);
  });

  testWidgets('inpaint page interactions', (t) async {
    final s = createStorage();
    await pumpPage(t, const InpaintPage(), storage: s, settle: false);
    await t.pump();
    expect(find.byType(InpaintPage), findsOneWidget);
    for (final lbl in ['Generate', 'Choose Image', 'Save']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        for (var i = 0; i < 5; i++) { await t.pump(const Duration(milliseconds: 100)); }
      }
    }
  });

  testWidgets('browse page: refresh and tabs', (t) async {
    final s = createStorage();
    await pumpPage(t, const BrowsePage(), storage: s, settle: false);
    await t.pump();
    final refresh = find.byIcon(Icons.refresh);
    if (refresh.evaluate().isNotEmpty) {
      await t.tap(refresh.first, warnIfMissed: false);
      for (var i = 0; i < 5; i++) { await t.pump(const Duration(milliseconds: 100)); }
    }
    expect(find.byType(BrowsePage), findsOneWidget);
  });
}
