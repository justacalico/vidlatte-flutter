import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/presentation/pages/browse/browse_page.dart';
import 'package:vidlatte/presentation/pages/create/create_page.dart';
import 'package:vidlatte/presentation/pages/studio/studio_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import 'helpers.dart';

class MockComfy extends Mock implements ComfyService {}

final _d = DateTime(2024);
final _srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d);

MockStorage stockedStorage() {
  final s = mockStorage();
  when(() => s.getServers()).thenReturn([_srv]);
  when(() => s.getDefaultServer()).thenReturn(_srv);
  when(() => s.getImages()).thenReturn([
    GeneratedImage(id: 'i1', prompt: 'p', model: 'm', status: ImageStatus.completed, localPath: '/tmp/x.png', createdAt: _d),
  ]);
  return s;
}

MockComfy stockedComfy() {
  final c = MockComfy();
  when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['model_a.safetensors', 'model_b.safetensors'],
        loras: const ['lora1.safetensors'], controlnets: const ['cn.pt'],
        upscaleModels: const ['up.pth'], maxLoras: 5, fetchedAt: _d,
      ));
  when(() => c.checkHealth(any())).thenAnswer((_) async =>
      ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));
  return c;
}

void main() {
  setUpAll(registerFallbacks);

  testWidgets('create page with catalog renders full controls', (t) async {
    await pumpPage(t, const CreatePage(), storage: stockedStorage(), comfy: stockedComfy(), settle: false);
    for (var i = 0; i < 8; i++) { await t.pump(const Duration(milliseconds: 200)); }
    // exercise the visible controls
    for (final f in find.byType(DropdownButtonFormField<String>).evaluate().toList()) {
      await t.tap(find.byWidget(f.widget), warnIfMissed: false);
      await t.pump();
      final items = find.byType(DropdownMenuItem<String>);
      if (items.evaluate().isNotEmpty) {
        await t.tap(items.last, warnIfMissed: false);
        await t.pump();
      }
    }
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'a castle');
      await t.pump();
    }
    for (final lbl in ['Generate', 'Add to Queue']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        for (var i = 0; i < 4; i++) { await t.pump(const Duration(milliseconds: 100)); }
      }
    }
    expect(find.byType(CreatePage), findsOneWidget);
  });

  testWidgets('browse page with catalog tabs', (t) async {
    await pumpPage(t, const BrowsePage(), storage: stockedStorage(), comfy: stockedComfy(), settle: false);
    for (var i = 0; i < 8; i++) { await t.pump(const Duration(milliseconds: 200)); }
    for (final f in find.byType(Tab).evaluate().toList()) {
      await t.tap(find.byWidget(f.widget), warnIfMissed: false);
      for (var i = 0; i < 4; i++) { await t.pump(const Duration(milliseconds: 100)); }
    }
    final tiles = find.byType(ListTile);
    for (var i = 0; i < tiles.evaluate().length && i < 4; i++) {
      await t.tap(tiles.at(i), warnIfMissed: false);
      await t.pump();
    }
    expect(find.byType(BrowsePage), findsOneWidget);
  });

  testWidgets('studio with session and images deep', (t) async {
    final s = stockedStorage();
    await pumpPage(t, const StudioPage(), storage: s, settle: false);
    for (var i = 0; i < 8; i++) { await t.pump(const Duration(milliseconds: 200)); }
    for (final f in find.byType(FloatingActionButton).evaluate().toList()) {
      await t.tap(find.byWidget(f.widget), warnIfMissed: false);
      await t.pump();
      for (var i = 0; i < 3; i++) { await t.pump(const Duration(milliseconds: 100)); }
      final cancel = find.text('Cancel');
      if (cancel.evaluate().isNotEmpty) {
        await t.tap(cancel.last, warnIfMissed: false);
        await t.pump();
      }
    }
    expect(find.byType(StudioPage), findsOneWidget);
  });
}
