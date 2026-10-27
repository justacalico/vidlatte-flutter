import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/presentation/widgets/common/image_detail_modal.dart';

import '../helpers.dart';

GeneratedImage _mk(String id) => GeneratedImage(
      id: id, prompt: 'p $id', model: 'm', status: ImageStatus.completed,
      localPath: '/tmp/$id.png', serverUrl: 'http://s', comfyFilename: 'f.png',
      createdAt: DateTime(2024),
    );

void main() {
  setUpAll(registerFallbacks);

  testWidgets('detail modal: nav, buttons, dialogs', (t) async {
    await pumpPage(
      t,
      Scaffold(body: ImageDetailModal(images: [_mk('a'), _mk('b'), _mk('c')])),
      size: const Size(1200, 900),
      settle: false,
    );
    await t.pump();

    final next = find.byIcon(Icons.chevron_right);
    if (next.evaluate().isNotEmpty) {
      await t.tap(next.first);
      await t.pump();
      await t.tap(next.first);
      await t.pump();
    }
    final prev = find.byIcon(Icons.chevron_left);
    if (prev.evaluate().isNotEmpty) {
      await t.tap(prev.first);
      await t.pump();
    }

    for (final icon in [Icons.face_retouching_natural, Icons.hd_outlined]) {
      final btn = find.byIcon(icon);
      if (btn.evaluate().isNotEmpty) {
        await t.tap(btn.first, warnIfMissed: false);
        for (var i = 0; i < 10; i++) {
          await t.pump(const Duration(milliseconds: 200));
        }
        final cancel = find.text('Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await t.tap(cancel.last);
          await t.pump();
        }
      }
    }
    expect(find.byType(ImageDetailModal), findsOneWidget);
  });
}
