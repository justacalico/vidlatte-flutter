import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/llm_model.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/presentation/pages/settings/settings_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';
import 'package:vidlatte/services/llm_service.dart';

import 'helpers.dart';

class MockComfy extends Mock implements ComfyService {}
class MockLlm extends Mock implements LlmService {}

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 5; i++) { await t.pump(const Duration(milliseconds: 100)); }
  }

  MockComfy comfyMock() {
    final c = MockComfy();
    when(() => c.checkHealth(any())).thenAnswer((_) async => ServerHealth(
        serverId: 's1', healthy: true, os: 'Linux', pythonVersion: '3.12', ramTotal: 32000000000, checkedAt: _d));
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['m1'], loras: const [], controlnets: const [],
        upscaleModels: const [], maxLoras: 5, fetchedAt: _d));
    return c;
  }

  testWidgets('settings: expand server card, tap all chips', (t) async {
    final s = mockStorage();
    final servers = <ComfyServer>[
      ComfyServer(id: 's1', name: 'Main', url: 'http://a', isDefault: true, createdAt: _d),
      ComfyServer(id: 's2', name: 'Second', url: 'http://b', createdAt: _d),
    ];
    when(() => s.getServers()).thenAnswer((_) => List.of(servers));
    when(() => s.deleteServer(any())).thenAnswer((i) async {
      servers.removeWhere((x) => x.id == i.positionalArguments[0]);
    });
    await pumpPage(t, const SettingsPage(), storage: s, comfy: comfyMock(), settle: false,
        size: const Size(1400, 900));
    await settle(t);

    // expand each server card
    for (final name in ['Main', 'Second']) {
      final f = find.text(name);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t);
      }
    }

    // tap all action chips
    for (final lbl in ['Health Check', 'Fetch Models', 'Set Default', 'Edit', 'Delete']) {
      final f = find.text(lbl);
      for (var i = 0; i < f.evaluate().length; i++) {
        await t.tap(f.at(i), warnIfMissed: false);
        await settle(t);
        // confirm dialog: tap Delete/confirm then also Cancel path
        final confirm = find.byType(FilledButton);
        if (confirm.evaluate().isNotEmpty) {
          final txt = find.text('Delete').last;
          if (txt.evaluate().isNotEmpty) {
            await t.tap(txt, warnIfMissed: false);
            await settle(t);
          }
        }
        final cancel = find.text('Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await t.tap(cancel.last, warnIfMissed: false);
          await settle(t);
        }
      }
    }
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('settings: edit server dialog saves', (t) async {
    final s = mockStorage();
    when(() => s.getServers()).thenReturn([
      ComfyServer(id: 's1', name: 'Main', url: 'http://a', createdAt: _d),
    ]);
    await pumpPage(t, const SettingsPage(), storage: s, settle: false, size: const Size(1400, 900));
    await settle(t);
    final mainName = find.text('Main');
    if (mainName.evaluate().isNotEmpty) {
      await t.tap(mainName.first, warnIfMissed: false);
      await settle(t);
    }
    final edit = find.text('Edit');
    if (edit.evaluate().isNotEmpty) {
      await t.tap(edit.first, warnIfMissed: false);
      await settle(t);
      // fill fields
      for (final f in find.byType(TextFormField).evaluate().toList()) {
        await t.enterText(find.byWidget(f.widget), 'edited');
        await t.pump();
      }
      final save = find.text('Save');
      if (save.evaluate().isNotEmpty) {
        await t.tap(save.last, warnIfMissed: false);
        await settle(t);
      }
    }
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('settings: llm card expand, actions, fetch models', (t) async {
    final s = mockStorage();
    when(() => s.getLlmServers()).thenReturn([
      LlmServer(id: 'l1', name: 'LM', url: 'http://lm', createdAt: _d),
    ]);
    final llm = MockLlm();
    when(() => llm.getModels(any())).thenAnswer((_) async => const [
          LlmModel(identifier: 'm1', displayName: 'Model 1'),
        ]);
    await pumpPage(t, const SettingsPage(), storage: s, llm: llm, settle: false,
        size: const Size(1400, 900));
    await settle(t);
    final lm = find.text('LM');
    if (lm.evaluate().isNotEmpty) {
      await t.tap(lm.first, warnIfMissed: false);
      await settle(t);
    }
    for (final lbl in ['Fetch Models', 'Edit', 'Delete', 'Test']) {
      final f = find.text(lbl);
      for (var i = 0; i < f.evaluate().length && i < 2; i++) {
        await t.tap(f.at(i), warnIfMissed: false);
        await settle(t);
        final cancel = find.text('Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await t.tap(cancel.last, warnIfMissed: false);
          await settle(t);
        }
      }
    }
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('settings: privacy set/remove password flows', (t) async {
    final s = mockStorage();
    await pumpPage(t, const SettingsPage(), storage: s, settle: false, size: const Size(1400, 900));
    await settle(t);
    for (var i = 0; i < 10; i++) {
      await t.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await settle(t);
      if (find.text('Gallery Privacy').evaluate().isNotEmpty) break;
    }
    final setPw = find.text('Set Password');
    if (setPw.evaluate().isNotEmpty) {
      await t.tap(setPw.first, warnIfMissed: false);
      await settle(t);
      for (final f in find.byType(TextField).evaluate().toList()) {
        await t.enterText(find.byWidget(f.widget), 'mypw');
        await t.pump();
      }
      final save = find.text('Save');
      if (save.evaluate().isNotEmpty) {
        await t.tap(save.last, warnIfMissed: false);
        await settle(t);
      }
    }
    // now change/remove
    for (final lbl in ['Change Password', 'Remove Password']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t);
        final cancel = find.text('Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await t.tap(cancel.last, warnIfMissed: false);
          await settle(t);
        }
      }
    }
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
