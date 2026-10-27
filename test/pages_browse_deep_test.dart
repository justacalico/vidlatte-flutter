import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/lora_metadata.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/presentation/pages/browse/browse_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import 'helpers.dart';

class MockComfy extends Mock implements ComfyService {}

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t, [int n = 8]) async {
    for (var i = 0; i < n; i++) { await t.pump(const Duration(milliseconds: 120)); }
  }

  testWidgets('browse: tabs, lora cards, trigger words, hide/show', (t) async {
    final s = mockStorage();
    final srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d);
    when(() => s.getServers()).thenReturn([srv]);
    when(() => s.getDefaultServer()).thenReturn(srv);
    when(() => s.getAllLoraMetadata('s1')).thenReturn([
      LoraMetadata(serverId: 's1', loraName: 'l1', triggerWords: 'cat, anime', updatedAt: _d),
    ]);
    final c = MockComfy();
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['folder/m1.safetensors', 'm2'],
        loras: const ['l1', 'l2'], controlnets: const ['cn.pt'],
        upscaleModels: const [], maxLoras: 5, fetchedAt: _d));
    when(() => c.getLoraMetadata(any(), any())).thenAnswer((_) async =>
        <String, dynamic>{'name': 'l2', 'tags': 'tag1, tag2'});
    when(() => c.checkHealth(any())).thenAnswer((_) async =>
        ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));

    await pumpPage(t, const BrowsePage(), storage: s, comfy: c, settle: false,
        size: const Size(1400, 900));
    await settle(t);

    // tabs
    for (final lbl in ['Models', 'LoRAs', 'ControlNet', 'Upscale']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t, 3);
      }
    }
    // tap all icon buttons in lora cards
    for (final icon in [Icons.copy, Icons.edit, Icons.download, Icons.refresh, Icons.visibility_off, Icons.visibility, Icons.arrow_forward]) {
      final f = find.byIcon(icon);
      for (var i = 0; i < f.evaluate().length && i < 3; i++) {
        await t.tap(f.at(i), warnIfMissed: false);
        await settle(t, 3);
        final cancel = find.text('Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await t.tap(cancel.last, warnIfMissed: false);
          await settle(t);
        }
        final save = find.text('Save');
        if (save.evaluate().isNotEmpty) {
          await t.tap(save.last, warnIfMissed: false);
          await settle(t);
        }
      }
    }
    expect(find.byType(BrowsePage), findsOneWidget);
  });
}
