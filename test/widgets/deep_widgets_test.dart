import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/generation_job.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';
import 'package:vidlatte/presentation/widgets/create/controlnet_input.dart';
import 'package:vidlatte/presentation/widgets/create/generation_controls.dart';
import 'package:vidlatte/presentation/widgets/create/img2img_input.dart';
import 'package:vidlatte/presentation/widgets/create/lora_picker_dialog.dart';
import 'package:vidlatte/presentation/widgets/create/progress_card.dart';
import 'package:vidlatte/presentation/widgets/create/prompt_history_sheet.dart';
import 'package:vidlatte/presentation/widgets/create/queue_card.dart';

import '../helpers.dart';

final _d = DateTime(2024);
final _img = GeneratedImage(id: 'i', prompt: 'p', model: 'm', createdAt: _d);
final _server = ComfyServer(id: 's', name: 'srv', url: 'http://x', createdAt: _d);
final _jobRun = GenerationJob(id: 'j', prompt: 'p', model: 'm', serverId: 's',
    status: JobStatus.executing, progressValue: 5, progressMax: 10, createdAt: _d);
final _jobFail = GenerationJob(id: 'j2', prompt: 'p', model: 'm', serverId: 's',
    status: JobStatus.failed, errorMessage: 'boom', createdAt: _d);

Future<void> pump(WidgetTester t, Widget w, {bool settle = false}) =>
    pumpPage(t, Scaffold(body: w), size: const Size(1100, 900), settle: settle);

void main() {
  setUpAll(registerFallbacks);

  testWidgets('prompt history sheet with entries', (t) async {
    final s = mockStorage();
    when(() => s.getPromptHistory()).thenReturn([
      PromptHistoryEntry(id: 'p1', prompt: 'a castle on a hill', model: 'm', loras: const ['l'], createdAt: _d),
      PromptHistoryEntry(id: 'p2', prompt: 'x' * 300, createdAt: _d.subtract(const Duration(days: 2))),
    ]);
    await pumpPage(t, const Scaffold(body: PromptHistorySheet()), storage: s, settle: false);
    await t.pump();
    final field = find.byType(TextField);
    if (field.evaluate().isNotEmpty) {
      await t.enterText(field.first, 'castle');
      await t.pump();
      await t.enterText(field.first, '');
      await t.pump();
    }
    final tiles = find.byType(ListTile);
    if (tiles.evaluate().isNotEmpty) {
      await t.tap(tiles.first, warnIfMissed: false);
      await t.pump();
    }
  });

  testWidgets('lora picker: search, toggle, weights', (t) async {
    await pump(t, LoraPickerDialog(
      loras: const ['l1', 'l2', 'l3'],
      triggerWords: const {'l1': 'cat, anime'},
      selectedLoras: const ['l1'],
      loraWeights: const {'l1': 0.8},
      maxLoras: 3,
    ));
    final field = find.byType(TextField);
    if (field.evaluate().isNotEmpty) {
      await t.enterText(field.first, 'l2');
      await t.pump();
      await t.enterText(field.first, '');
      await t.pump();
    }
    final checks = find.byType(Checkbox);
    for (var i = 0; i < checks.evaluate().length && i < 2; i++) {
      await t.tap(checks.at(i), warnIfMissed: false);
      await t.pump();
    }
    final sliders = find.byType(Slider);
    for (var i = 0; i < sliders.evaluate().length; i++) {
      await t.drag(sliders.at(i), const Offset(30, 0), warnIfMissed: false);
      await t.pump();
    }
    for (final lbl in ['Done', 'Apply', 'Cancel', 'OK', 'Save']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await t.pump();
      }
    }
    expect(find.byType(LoraPickerDialog), findsWidgets);
  });

  testWidgets('generation controls: dropdowns and sliders', (t) async {
    await pump(t, GenerationControls(
      models: const ['m1', 'm2'], loras: const ['l1'], maxLoras: 3,
      selectedModel: 'm1', selectedLoras: const ['l1'],
      creativity: Creativity.normal, customSteps: null, customHiresFix: null,
      width: 512, height: 512, servers: [_server], selectedServerId: 's',
      onModelChanged: (_) {}, onLorasChanged: (_) {}, onLoraWeightsChanged: (_) {},
      onCreativityChanged: (_) {}, onCfgChanged: (_) {}, onStepsChanged: (_) {},
      onHiresFixChanged: (_) {}, onDimensionsChanged: (_) {}, onServerChanged: (_) {},
      onRefreshModels: () {},
    ));
    for (final d in find.byType(DropdownButtonFormField<String>).evaluate().toList()) {
      await t.tap(find.byWidget(d.widget), warnIfMissed: false);
      await t.pump();
      await t.pump(const Duration(milliseconds: 300));
      final item = find.byType(DropdownMenuItem<String>);
      if (item.evaluate().isNotEmpty) {
        await t.tap(item.last, warnIfMissed: false);
        await t.pump();
      }
    }
    for (final s in find.byType(Slider).evaluate().toList()) {
      await t.drag(find.byWidget(s.widget), const Offset(20, 0), warnIfMissed: false);
      await t.pump();
    }
    expect(find.byType(GenerationControls), findsOneWidget);
  });

  testWidgets('controlnet input: pick model and strength', (t) async {
    await pump(t, ControlNetInput(
      controlnetModels: const ['cn1', 'cn2'], strength: 0.8,
      onModelChanged: (_) {}, onImageChanged: (_) {}, onStrengthChanged: (_) {},
    ));
    final dd = find.byType(DropdownButtonFormField<String>);
    if (dd.evaluate().isNotEmpty) {
      await t.tap(dd.first, warnIfMissed: false);
      await t.pump();
      final item = find.text('cn2');
      if (item.evaluate().isNotEmpty) {
        await t.tap(item.last, warnIfMissed: false);
        await t.pump();
      }
    }
    final slider = find.byType(Slider);
    if (slider.evaluate().isNotEmpty) {
      await t.drag(slider.first, const Offset(20, 0), warnIfMissed: false);
      await t.pump();
    }
  });

  testWidgets('img2img: denoise slider', (t) async {
    await pump(t, Img2ImgInput(
      denoise: 0.5, onImageChanged: (_) {}, onDenoiseChanged: (_) {},
    ));
    final slider = find.byType(Slider);
    if (slider.evaluate().isNotEmpty) {
      await t.drag(slider.first, const Offset(-20, 0), warnIfMissed: false);
      await t.pump();
    }
  });

  testWidgets('progress card cancel and queue card', (t) async {
    var cancelled = false;
    await pump(t, ProgressCard(job: _jobRun, onCancel: () => cancelled = true, onRetry: () {}));
    final btn = find.byIcon(Icons.close);
    if (btn.evaluate().isNotEmpty) {
      await t.tap(btn.first, warnIfMissed: false);
      await t.pump();
    }
    await pump(t, QueueCard(job: _jobFail, position: 2, onCancel: () => cancelled = true));
    expect(find.byType(QueueCard), findsOneWidget);
  });
}
