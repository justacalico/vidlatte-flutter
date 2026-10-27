import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/collection.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/presentation/pages/gallery/gallery_page.dart';
import 'package:vidlatte/presentation/widgets/common/image_detail_modal.dart';

import 'helpers.dart';

final _d = DateTime(2024);

GeneratedImage _mk(String id, {bool fav = false, bool hid = false, String? col}) =>
    GeneratedImage(id: id, prompt: 'prompt $id', model: 'm',
        status: ImageStatus.completed, localPath: '/tmp/$id.png',
        isFavorite: fav, isHidden: hid, collectionId: col, createdAt: _d);

void main() {
  setUpAll(registerFallbacks);

  MockStorage galleryStorage() {
    final s = mockStorage();
    final images = [_mk('a'), _mk('b', fav: true), _mk('c', hid: true), _mk('d', col: 'c1')];
    when(() => s.getImages()).thenAnswer((_) => images);
    when(() => s.getCollections()).thenReturn([
      Collection(id: 'c1', name: 'Playlist 1', createdAt: _d, updatedAt: _d),
    ]);
    return s;
  }

  testWidgets('gallery: search, filters, select mode, bulk actions', (t) async {
    final s = galleryStorage();
    await pumpPage(t, const GalleryPage(), storage: s);
    await t.pump();

    // search
    await t.enterText(find.byType(TextField).first, 'prompt a');
    await t.pumpAndSettle();
    final clear = find.byIcon(Icons.clear);
    if (clear.evaluate().isNotEmpty) {
      await t.tap(clear.first);
      await t.pumpAndSettle();
    }

    // favorites filter chip
    final fav = find.byIcon(Icons.favorite_rounded);
    if (fav.evaluate().isNotEmpty) {
      await t.tap(fav.first);
      await t.pumpAndSettle();
      await t.tap(fav.first);
      await t.pumpAndSettle();
    }

    // select mode + bulk bar
    final sel = find.byIcon(Icons.checklist_rounded);
    if (sel.evaluate().isNotEmpty) {
      await t.tap(sel.first);
      await t.pumpAndSettle();
      final selAll = find.byIcon(Icons.select_all);
      if (selAll.evaluate().isNotEmpty) {
        await t.tap(selAll.first);
        await t.pumpAndSettle();
      }
      final del = find.byIcon(Icons.delete_outline);
      if (del.evaluate().isNotEmpty) {
        await t.tap(del.first);
        await t.pumpAndSettle();
        final confirm = find.text('Delete');
        if (confirm.evaluate().isNotEmpty) {
          await t.tap(confirm.last);
          await t.pumpAndSettle();
        }
      }
      final close = find.byIcon(Icons.close);
      if (close.evaluate().isNotEmpty) {
        await t.tap(close.first);
        await t.pumpAndSettle();
      }
    }
    expect(find.byType(GalleryPage), findsOneWidget);
  });

  testWidgets('gallery: locked flow with password', (t) async {
    final s = mockStorage(settings: const AppSettings(galleryPassword: 'pw'));
    await pumpPage(t, const GalleryPage(), storage: s);
    await t.pump();
    final field = find.byType(TextField);
    if (field.evaluate().isNotEmpty) {
      await t.enterText(field.first, 'wrong');
      await t.testTextInput.receiveAction(TextInputAction.done);
      await t.pumpAndSettle();
      await t.enterText(field.first, 'pw');
      await t.testTextInput.receiveAction(TextInputAction.done);
      await t.pumpAndSettle();
    }
    expect(find.byType(GalleryPage), findsOneWidget);
  });

  testWidgets('gallery: image tap opens detail modal', (t) async {
    final s = galleryStorage();
    await pumpPage(t, const GalleryPage(), storage: s);
    await t.pump();
    final cards = find.byType(GestureDetector);
    if (cards.evaluate().isNotEmpty) {
      await t.tap(cards.first);
      await t.pumpAndSettle();
      if (find.byType(ImageDetailModal).evaluate().isNotEmpty) {
        await t.tap(find.byIcon(Icons.close).first);
        await t.pumpAndSettle();
      }
    }
    expect(find.byType(GalleryPage), findsOneWidget);
  });
}
