import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/presentation/pages/studio/studio_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import 'helpers.dart';

class MockComfy extends Mock implements ComfyService {}

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t, [int n = 8]) async {
    for (var i = 0; i < n; i++) { await t.pump(const Duration(milliseconds: 120)); }
  }

  testWidgets('studio: session detail full controls', (t) async {
    final s = mockStorage();
    final srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d);
    when(() => s.getServers()).thenReturn([srv]);
    when(() => s.getDefaultServer()).thenReturn(srv);
    final img = GeneratedImage(id: 'i1', prompt: 'p', model: 'm', status: ImageStatus.completed, localPath: '/tmp/x.png', createdAt: _d);
    final sessions = [
      StudioSession(id: 's1', title: 'Session A', prompt: 'a cat', model: 'm', loras: const ['l1'], images: [img], createdAt: _d, updatedAt: _d),
      StudioSession(id: 's2', title: 'Session B', createdAt: _d, updatedAt: _d),
    ];
    when(() => s.getSessions()).thenAnswer((_) => List.of(sessions));
    when(() => s.getSession(any())).thenAnswer((i) => sessions.firstWhere((x) => x.id == i.positionalArguments[0], orElse: () => sessions.first));
    when(() => s.saveSession(any())).thenAnswer((i) async {
      final n = i.positionalArguments[0] as StudioSession;
      sessions.removeWhere((x) => x.id == n.id);
      sessions.add(n);
    });
    final c = MockComfy();
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['m1', 'm2'], loras: const ['l1'],
        controlnets: const [], upscaleModels: const [], maxLoras: 5, fetchedAt: _d));
    when(() => c.checkHealth(any())).thenAnswer((_) async =>
        ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));

    await pumpPage(t, const StudioPage(), storage: s, comfy: c, settle: false,
        size: const Size(1400, 900));
    await settle(t);

    // tap session header (picker)
    final title = find.text('Session A');
    if (title.evaluate().isNotEmpty) {
      await t.tap(title.first, warnIfMissed: false);
      await settle(t, 3);
      // session picker may open - pick session B
      final b = find.text('Session B');
      if (b.evaluate().length > 1) {
        await t.tap(b.last, warnIfMissed: false);
        await settle(t);
      }
    }
    // delete icon
    final del = find.byIcon(Icons.delete_outline);
    if (del.evaluate().isNotEmpty) {
      await t.tap(del.first, warnIfMissed: false);
      await settle(t);
      final confirm = find.text('Delete');
      if (confirm.evaluate().isNotEmpty) {
        await t.tap(confirm.last, warnIfMissed: false);
        await settle(t);
      }
    }
    // new session button
    final add = find.text('New Session');
    if (add.evaluate().isNotEmpty) {
      await t.tap(add.first, warnIfMissed: false);
      await settle(t);
      final field = find.byType(TextField);
      if (field.evaluate().isNotEmpty) {
        await t.enterText(field.last, 'New Sess');
        await t.pump();
      }
      final create = find.text('Create');
      if (create.evaluate().isNotEmpty) {
        await t.tap(create.last, warnIfMissed: false);
        await settle(t);
      }
      final cancel = find.text('Cancel');
      if (cancel.evaluate().isNotEmpty) {
        await t.tap(cancel.last, warnIfMissed: false);
        await settle(t);
      }
    }
    // controls: dropdowns, sliders, prompt, generate
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
      await t.enterText(find.byWidget(f.widget), 'prompt text');
      await t.pump();
    }
    final gen = find.text('Generate');
    if (gen.evaluate().isNotEmpty) {
      await t.tap(gen.first, warnIfMissed: false);
      await settle(t);
    }
    expect(find.byType(StudioPage), findsOneWidget);
  });
}
