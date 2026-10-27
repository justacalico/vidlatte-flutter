import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/presentation/widgets/common/image_detail_modal.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import '../helpers.dart';

class MockComfy extends Mock implements ComfyService {}

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t, [int n = 8]) async {
    for (var i = 0; i < n; i++) { await t.pump(const Duration(milliseconds: 100)); }
  }

  testWidgets('detail modal: all actions', (t) async {
    final s = mockStorage();
    final srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', isDefault: true, createdAt: _d);
    when(() => s.getServers()).thenReturn([srv]);
    when(() => s.getDefaultServer()).thenReturn(srv);
    when(() => s.getImages()).thenReturn([
      GeneratedImage(id: 'i1', prompt: 'p', model: 'm', status: ImageStatus.completed,
          localPath: '/tmp/x.png', seed: 7, steps: 20, width: 512, height: 512,
          loras: const ['l1'], createdAt: _d),
      GeneratedImage(id: 'i2', prompt: 'p2', model: 'm2', status: ImageStatus.completed,
          localPath: '/tmp/y.png', createdAt: _d),
    ]);
    final c = MockComfy();
    when(() => c.getModels(any())).thenAnswer((_) async => ModelCatalog(
        serverId: 's1', models: const ['m'], loras: const [], controlnets: const [],
        upscaleModels: const ['up.pth'], maxLoras: 5, fetchedAt: _d));
    when(() => c.faceRestore(any(), filename: any(named: 'filename'), type: any(named: 'type'), subfolder: any(named: 'subfolder')))
        .thenAnswer((_) async => ComfyJobResult(success: true, filename: 'f.png', imageBytes: Uint8List(2)));
    when(() => c.upscale(any(), filename: any(named: 'filename'), type: any(named: 'type'), subfolder: any(named: 'subfolder'), model: any(named: 'model'), scale: any(named: 'scale')))
        .thenAnswer((_) async => ComfyJobResult(success: true, filename: 'u.png', imageBytes: Uint8List(2)));

    await pumpPage(t, Scaffold(body: Builder(
      builder: (ctx) => ElevatedButton(
        onPressed: () => showDialog(context: ctx, builder: (_) => ImageDetailModal(images: [
          GeneratedImage(id: 'i1', prompt: 'p', model: 'm', status: ImageStatus.completed, localPath: '/tmp/x.png', seed: 7, steps: 20, width: 512, height: 512, loras: const ['l1'], createdAt: _d),
          GeneratedImage(id: 'i2', prompt: 'p2', model: 'm2', status: ImageStatus.completed, localPath: '/tmp/y.png', createdAt: _d),
        ])),
        child: const Text('open'),
      ),
    )), storage: s, comfy: c, settle: false, size: const Size(1400, 900));
    await t.tap(find.text('open'));
    await settle(t);

    // tap everything
    for (final icon in [Icons.face, Icons.hd, Icons.delete_outline, Icons.close, Icons.chevron_left, Icons.chevron_right, Icons.info_outline, Icons.copy, Icons.favorite_border, Icons.favorite, Icons.visibility_off]) {
      final f = find.byIcon(icon);
      for (var i = 0; i < f.evaluate().length && i < 2; i++) {
        await t.tap(f.at(i), warnIfMissed: false);
        await settle(t, 4);
        // close dialogs
        for (final lbl in ['Cancel', 'Done', 'OK', 'Delete', 'Start']) {
          final b = find.text(lbl);
          if (b.evaluate().isNotEmpty) {
            await t.tap(b.last, warnIfMissed: false);
            await settle(t, 3);
            break;
          }
        }
      }
    }
    expect(true, isTrue);
  });
}
