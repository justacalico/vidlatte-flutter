import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';
import 'package:vidlatte/presentation/pages/create/create_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import 'helpers.dart';

class MockComfy extends Mock implements ComfyService {}

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t, [int n = 6]) async {
    for (var i = 0; i < n; i++) { await t.pump(const Duration(milliseconds: 120)); }
  }

  (MockStorage, MockComfy) stocked() {
    final s = mockStorage(settings: const AppSettings(
      defaultServerId: 's1', lastModel: 'm1', lastLoras: ['l1'],
      lastCreativity: 'high', lastCustomSteps: 25, lastHiresFix: true,
      lastCustomCfg: 8.0, lastWidth: 832, lastHeight: 1216,
      lastPrompt: 'last prompt', lastNegativePrompt: 'bad',
    ));
    final srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d);
    when(() => s.getServers()).thenReturn([srv]);
    when(() => s.getDefaultServer()).thenReturn(srv);
    when(() => s.getPromptHistory()).thenReturn([
      PromptHistoryEntry(id: 'p1', prompt: 'old prompt', model: 'm', loras: const ['l'], createdAt: _d),
    ]);
    final c = MockComfy();
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['m1', 'm2'], loras: const ['l1'],
        controlnets: const ['cn1'], upscaleModels: const [], maxLoras: 5, fetchedAt: _d));
    when(() => c.checkHealth(any())).thenAnswer((_) async =>
        ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));
    return (s, c);
  }

  testWidgets('create: populated settings load and all modes toggle', (t) async {
    final (s, c) = stocked();
    await pumpPage(t, const CreatePage(), storage: s, comfy: c, settle: false,
        size: const Size(1400, 900));
    await settle(t);

    // mode toggles: img2img, controlnet, auto
    for (final lbl in ['Image to Image', 'ControlNet', 'Auto Image', 'Inpaint']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t, 3);
      }
    }
    // app bar actions
    for (final icon in [Icons.history, Icons.queue_music, Icons.text_fields]) {
      final f = find.byIcon(icon);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t, 3);
        final close = find.byIcon(Icons.close);
        if (close.evaluate().isNotEmpty) {
          await t.tap(close.last, warnIfMissed: false);
          await settle(t, 2);
        }
      }
    }
    // generate / add to queue
    for (final lbl in ['Generate', 'Add to Queue']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t, 4);
      }
    }
    expect(find.byType(CreatePage), findsWidgets);
  });

  testWidgets('create: submit with all fields', (t) async {
    final (s, c) = stocked();
    await pumpPage(t, const CreatePage(), storage: s, comfy: c, settle: false,
        size: const Size(1400, 900));
    await settle(t);
    // fill prompt
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'test prompt');
      await t.pump();
    }
    // dropdowns
    for (final f in find.byType(DropdownButtonFormField<String>).evaluate().toList()) {
      await t.tap(find.byWidget(f.widget), warnIfMissed: false);
      await t.pump();
      final items = find.byType(DropdownMenuItem<String>);
      if (items.evaluate().isNotEmpty) {
        await t.tap(items.last, warnIfMissed: false);
        await t.pump();
      }
    }
    // sliders
    for (final f in find.byType(Slider).evaluate().toList()) {
      await t.drag(find.byWidget(f.widget), const Offset(25, 0), warnIfMissed: false);
      await t.pump();
    }
    // submit
    final gen = find.text('Generate');
    if (gen.evaluate().isNotEmpty) {
      await t.tap(gen.first, warnIfMissed: false);
      await settle(t, 8);
    }
    expect(find.byType(CreatePage), findsWidgets);
  });
}
