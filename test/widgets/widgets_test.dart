import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/generation_job.dart';
import 'package:vidlatte/presentation/widgets/common/empty_state.dart';
import 'package:vidlatte/presentation/widgets/common/error_state.dart';
import 'package:vidlatte/presentation/widgets/common/image_grid.dart';
import 'package:vidlatte/presentation/widgets/common/model_dropdown.dart';
import 'package:vidlatte/presentation/widgets/create/controlnet_input.dart';
import 'package:vidlatte/presentation/widgets/create/generation_controls.dart';
import 'package:vidlatte/presentation/widgets/create/img2img_input.dart';
import 'package:vidlatte/presentation/widgets/create/progress_card.dart';
import 'package:vidlatte/presentation/widgets/create/prompt_input.dart';
import 'package:vidlatte/presentation/widgets/create/queue_card.dart';

import '../helpers.dart';

final _img = GeneratedImage(id: 'i', prompt: 'p', model: 'm', createdAt: DateTime(2024));
final _job = GenerationJob(id: 'j', prompt: 'p', model: 'm', serverId: 's', createdAt: DateTime(2024));
final _server = ComfyServer(id: 's', name: 'srv', url: 'http://x', createdAt: DateTime(2024));

Future<void> pump(WidgetTester t, Widget w) =>
    pumpPage(t, Scaffold(body: w), size: const Size(1000, 800));

void main() {
  setUpAll(registerFallbacks);

  testWidgets('EmptyState renders and acts', (t) async {
    var tapped = false;
    await pump(t, EmptyState(
      icon: Icons.image, title: 'T', message: 'M',
      action: TextButton(onPressed: () => tapped = true, child: const Text('Go')),
    ));
    expect(find.text('T'), findsOneWidget);
    await t.tap(find.text('Go'));
    await t.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('ErrorState renders and retries', (t) async {
    var retried = false;
    await pump(t, ErrorState(message: 'oops', onRetry: () => retried = true));
    await t.tap(find.text('Retry'));
    await t.pumpAndSettle();
    expect(retried, isTrue);
  });

  testWidgets('ImageGrid renders cards and taps', (t) async {
    var tapped = false;
    await pump(t, ImageGrid(
      images: [_img], onTap: (_) => tapped = true,
      onFavorite: (_) {}, onDelete: (_) {},
    ));
    await t.tap(find.byType(GestureDetector).first);
    await t.pump();
    await t.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('ModelDropdown renders', (t) async {
    await pumpPage(t, Scaffold(body: ModelDropdown(
      models: const ['a', 'b'], selectedModel: 'a',
      onChanged: (_) {}, label: 'M', onRefresh: () {}, refreshing: true,
    )), size: const Size(1000, 800), settle: false);
    expect(find.byType(ModelDropdown), findsOneWidget);
  });

  testWidgets('PromptInput types text', (t) async {
    final c = TextEditingController();
    await pump(t, PromptInput(controller: c, negativeController: TextEditingController()));
    await t.enterText(find.byType(TextField).first, 'a cat');
    expect(c.text, 'a cat');
  });

  testWidgets('ProgressCard renders job', (t) async {
    await pumpPage(t, Scaffold(body: ProgressCard(job: _job, onCancel: () {}, onRetry: () {})), size: const Size(1000, 800), settle: false);
    expect(find.byType(ProgressCard), findsOneWidget);
  });

  testWidgets('QueueCard renders job', (t) async {
    await pump(t, QueueCard(job: _job, position: 1, onCancel: () {}));
    expect(find.byType(QueueCard), findsOneWidget);
  });

  testWidgets('ControlNetInput renders', (t) async {
    await pump(t, ControlNetInput(
      controlnetModels: const ['cn1'], strength: 0.8,
      onModelChanged: (_) {}, onImageChanged: (_) {}, onStrengthChanged: (_) {},
    ));
    expect(find.byType(ControlNetInput), findsOneWidget);
  });

  testWidgets('Img2ImgInput renders', (t) async {
    await pump(t, Img2ImgInput(
      denoise: 0.5, onImageChanged: (_) {}, onDenoiseChanged: (_) {},
    ));
    expect(find.byType(Img2ImgInput), findsOneWidget);
  });

  testWidgets('GenerationControls renders', (t) async {
    await pump(t, GenerationControls(
      models: const ['m1'], loras: const ['l1'], maxLoras: 3,
      selectedModel: 'm1', selectedLoras: const [],
      creativity: Creativity.normal, customSteps: null, customHiresFix: null,
      width: 512, height: 512, servers: [_server], selectedServerId: 's',
      onModelChanged: (_) {}, onLorasChanged: (_) {}, onLoraWeightsChanged: (_) {},
      onCreativityChanged: (_) {}, onCfgChanged: (_) {}, onStepsChanged: (_) {},
      onHiresFixChanged: (_) {}, onDimensionsChanged: (_) {}, onServerChanged: (_) {},
    ));
    expect(find.byType(GenerationControls), findsOneWidget);
  });
}
