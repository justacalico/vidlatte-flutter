import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/llm_model.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/presentation/widgets/create/auto_image_content.dart';
import 'package:vidlatte/services/comfyui_service.dart';
import 'package:vidlatte/services/llm_service.dart';
import 'package:vidlatte/bloc/autogen/autogen_bloc.dart';

import '../helpers.dart';

class MockComfy extends Mock implements ComfyService {}
class MockLlm extends Mock implements LlmService {}

final _d = DateTime(2024);

void main() {
  setUpAll(() {
    registerFallbacks();
    registerFallbackValue(const LlmChatMessage(role: 'u', content: 'x'));
  });

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 5; i++) { await t.pump(const Duration(milliseconds: 100)); }
  }

  (MockStorage, MockComfy, MockLlm) stocked() {
    final s = mockStorage();
    final img = ComfyServer(id: 's1', name: 'img', url: 'http://x', isDefault: true, createdAt: _d);
    final llmSrv = LlmServer(id: 'l1', name: 'lm', url: 'http://y', createdAt: _d);
    when(() => s.getServers()).thenReturn([img]);
    when(() => s.getDefaultServer()).thenReturn(img);
    when(() => s.getLlmServers()).thenReturn([llmSrv]);
    when(() => s.getLlmServer('l1')).thenReturn(llmSrv);

    final c = MockComfy();
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['m1', 'm2'], loras: const ['l1'],
        controlnets: const [], upscaleModels: const [], maxLoras: 5, fetchedAt: _d));
    when(() => c.checkHealth(any())).thenAnswer((_) async =>
        ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));
    when(() => c.generateImage(any(),
            prompt: any(named: 'prompt'), model: any(named: 'model'),
            loras: any(named: 'loras'), seed: any(named: 'seed'),
            width: any(named: 'width'), height: any(named: 'height'),
            steps: any(named: 'steps'), hiresFix: any(named: 'hiresFix')))
        .thenAnswer((_) async => ComfyJobResult(success: true, filename: 'f.png', imageBytes: Uint8List(4)));

    final l = MockLlm();
    when(() => l.chatCompletion(server: any(named: 'server'), model: any(named: 'model'),
            messages: any(named: 'messages'), temperature: any(named: 'temperature'),
            maxTokens: any(named: 'maxTokens')))
        .thenAnswer((_) async => const LlmChatResult(success: true, content: 'a dog'));
    return (s, c, l);
  }

  testWidgets('auto image: config controls and run', (t) async {
    final (s, c, l) = stocked();
    await pumpPage(t, Scaffold(body: AutoImageContent(controller: AutoImageController())), storage: s, comfy: c, llm: l,
        size: const Size(1400, 900), settle: false);
    await settle(t);

    // segmented mode buttons
    final seg = find.byType(SegmentedButton<AutoGenMode>);
    if (seg.evaluate().isNotEmpty) {
      final options = find.descendant(of: seg, matching: find.byType(Text));
      for (var i = 0; i < options.evaluate().length; i++) {
        await t.tap(options.at(i), warnIfMissed: false);
        await t.pump();
      }
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
      await t.drag(find.byWidget(f.widget), const Offset(30, 0), warnIfMissed: false);
      await t.pump();
    }
    // text fields
    for (final f in find.byType(TextField).evaluate().toList()) {
      await t.enterText(find.byWidget(f.widget), 'cats');
      await t.pump();
    }
    // switches/checkboxes
    for (final f in find.byType(Switch).evaluate().toList()) {
      await t.tap(find.byWidget(f.widget), warnIfMissed: false);
      await t.pump();
    }
    // start/stop
    for (final lbl in ['Start', 'Start Auto Image', 'Begin']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t);
      }
    }
    for (final lbl in ['Stop', 'Stop Auto Image', 'Pause']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t);
      }
    }
    expect(find.byType(AutoImageContent), findsOneWidget);
  });
}
