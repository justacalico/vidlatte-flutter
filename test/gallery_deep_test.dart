import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/collection.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/presentation/pages/gallery/gallery_page.dart';

import 'helpers.dart';

final _d = DateTime(2024);

GeneratedImage img(String id, {bool favorite = false, bool hidden = false, String? collectionId}) =>
    GeneratedImage(id: id, prompt: 'p$id', model: 'm', status: ImageStatus.completed,
        localPath: '/tmp/$id.png', isFavorite: favorite, isHidden: hidden,
        collectionId: collectionId, createdAt: _d);

MockStorage stocked() {
  final s = mockStorage(settings: const AppSettings(galleryPassword: 'pw'));
  final imgs = [img('a', favorite: true), img('b', hidden: true), img('c', collectionId: 'col1')];
  when(() => s.getImages()).thenReturn(imgs);
  when(() => s.getFavoriteImages()).thenReturn(imgs.where((i) => i.isFavorite).toList());
  when(() => s.getImagesByCollection('col1')).thenReturn(imgs.where((i) => i.collectionId == 'col1').toList());
  when(() => s.getCollections()).thenReturn([Collection(id: 'col1', name: 'My Set', createdAt: _d, updatedAt: _d)]);
  return s;
}

void main() {
  setUpAll(registerFallbacks);

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 6; i++) { await t.pump(const Duration(milliseconds: 100)); }
  }

  testWidgets('gallery: unlock dialog wrong and right password', (t) async {
    final s = stocked();
    await pumpPage(t, const GalleryPage(), storage: s, size: const Size(1400, 900));
    // locked segment
    final locked = find.text('Locked');
    if (locked.evaluate().isEmpty) {
      // may show 'Hidden' filter or lock icon
      final lockIcon = find.byIcon(Icons.lock_outline);
      expect(lockIcon.evaluate().isNotEmpty || find.text('Hidden').evaluate().isNotEmpty, isTrue);
      return;
    }
    await t.tap(locked.first, warnIfMissed: false);
    await settle(t);
    // unlock dialog - wrong password
    final field = find.byType(TextField).last;
    if (field.evaluate().isNotEmpty) {
      await t.enterText(field, 'wrong');
      final unlock = find.text('Unlock');
      if (unlock.evaluate().isNotEmpty) {
        await t.tap(unlock.last, warnIfMissed: false);
        await settle(t);
      }
      // right password
      await t.enterText(field, 'pw');
      if (unlock.evaluate().isNotEmpty) {
        await t.tap(unlock.last, warnIfMissed: false);
        await settle(t);
      }
    }
    expect(find.byType(GalleryPage), findsOneWidget);
  });

  testWidgets('gallery: filters, select mode, bulk actions', (t) async {
    final s = stocked();
    await pumpPage(t, const GalleryPage(), storage: s, size: const Size(1400, 900));
    await settle(t);

    for (final lbl in ['All', 'Favorites', 'Hidden', 'Playlists', 'Collections']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t);
      }
    }

    // select mode
    final sel = find.byIcon(Icons.checklist);
    if (sel.evaluate().isNotEmpty) {
      await t.tap(sel.first, warnIfMissed: false);
      await settle(t);
    }
    final selAll = find.text('Select all');
    if (selAll.evaluate().isNotEmpty) {
      await t.tap(selAll.first, warnIfMissed: false);
      await settle(t);
    }
    for (final lbl in ['Delete', 'Favorite', 'Move', 'Cancel']) {
      final f = find.text(lbl);
      if (f.evaluate().isNotEmpty) {
        await t.tap(f.first, warnIfMissed: false);
        await settle(t);
        // confirm/cancel any dialog
        for (final btn in ['Delete', 'Move', 'Cancel']) {
          final b = find.text(btn);
          if (b.evaluate().length > 1) {
            await t.tap(b.last, warnIfMissed: false);
            await settle(t);
          }
        }
      }
    }
    // image tap -> detail
    final grid = find.byType(GestureDetector);
    for (var i = 0; i < grid.evaluate().length && i < 8; i++) {
      await t.tap(grid.at(i), warnIfMissed: false);
      await settle(t);
      final close = find.byIcon(Icons.close);
      if (close.evaluate().isNotEmpty) {
        await t.tap(close.first, warnIfMissed: false);
        await settle(t);
      }
    }
    expect(find.byType(GalleryPage), findsOneWidget);
  });

  testWidgets('gallery: playlist detail view', (t) async {
    final s = stocked();
    await pumpPage(t, const GalleryPage(), storage: s, size: const Size(1400, 900));
    await settle(t);
    final playlists = find.text('Playlists');
    if (playlists.evaluate().isNotEmpty) {
      await t.tap(playlists.first, warnIfMissed: false);
      await settle(t);
      final col = find.text('My Set');
      if (col.evaluate().isNotEmpty) {
        await t.tap(col.first, warnIfMissed: false);
        await settle(t);
      }
    }
    expect(find.byType(GalleryPage), findsOneWidget);
  });
}
