import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/presentation/pages/create/inpaint_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import 'helpers.dart';

class MockComfy extends Mock implements ComfyService {}

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t, [int n = 8]) async {
    for (var i = 0; i < n; i++) { await t.pump(const Duration(milliseconds: 120)); }
  }

  testWidgets('inpaint: populated state, all controls', (t) async {
    final s = mockStorage(settings: const AppSettings(
      lastModel: 'm1', defaultServerId: 's1', lastWidth: 512, lastHeight: 512));
    final srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d);
    when(() => s.getServers()).thenReturn([srv]);
    when(() => s.getDefaultServer()).thenReturn(srv);
    final c = MockComfy();
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['m1', 'm2'], loras: const [],
        controlnets: const [], upscaleModels: const [], maxLoras: 5, fetchedAt: _d));
    when(() => c.checkHealth(any())).thenAnswer((_) async =>
        ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));

    await pumpPage(t, const InpaintPage(), storage: s, comfy: c, settle: false,
        size: const Size(1400, 900));
    await settle(t);

    // all fields
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'inpaint');
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
      await t.drag(find.byWidget(f.widget), const Offset(20, 0), warnIfMissed: false);
      await t.pump();
    }
    // pick image + generate buttons
    for (final lbl in ['Choose Image', 'Select Image', 'Pick Image', 'Generate', 'Clear Mask']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t, 4);
      }
    }
    expect(find.byType(InpaintPage), findsOneWidget);
  });

  testWidgets('inpaint: no server state', (t) async {
    await pumpPage(t, const InpaintPage(), storage: mockStorage(), settle: false);
    await t.pump();
    final gen = find.text('Generate');
    if (gen.evaluate().isNotEmpty) {
      await t.tap(gen.first, warnIfMissed: false);
      await t.pump();
    }
    expect(find.byType(InpaintPage), findsOneWidget);
  });
}
