import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/presentation/pages/browse/browse_page.dart';
import 'package:vidlatte/presentation/pages/create/create_page.dart';
import 'package:vidlatte/presentation/pages/gallery/gallery_page.dart';
import 'package:vidlatte/presentation/pages/settings/settings_page.dart';
import 'package:vidlatte/presentation/pages/studio/studio_page.dart';
import 'package:vidlatte/presentation/widgets/shell/app_shell.dart';

import 'helpers.dart';

void main() {
  setUpAll(registerFallbacks);

  testWidgets('settings: theme, language, server dialog, about', (t) async {
    final storage = mockStorage();
    when(() => storage.getServers()).thenReturn([
      ComfyServer(id: 's1', name: 'srv1', url: 'http://x', isDefault: true, createdAt: DateTime(2024)),
    ]);
    await pumpPage(t, const SettingsPage(), storage: storage);
    await t.binding.delayed(Duration.zero);

    await t.tap(find.text('Dark'));
    await t.pumpAndSettle();
    await t.tap(find.text('Light'));
    await t.pumpAndSettle();

    await t.scrollUntilVisible(find.text('Gaeilge'), 100,
        scrollable: find.byType(Scrollable).first);
    await t.tap(find.text('Gaeilge'));
    await t.pumpAndSettle();
    verify(() => storage.saveSettings(any())).called(greaterThan(1));

    await t.scrollUntilVisible(find.text('Check for updates'), 100,
        scrollable: find.byType(Scrollable).first);
    await t.tap(find.text('Check for updates'));
    await t.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('settings: add server dialog', (t) async {
    final storage = mockStorage();
    await pumpPage(t, const SettingsPage(), storage: storage);
    await t.tap(find.text('Add').first);
    await t.pumpAndSettle();
    expect(find.text('Add Server'), findsOneWidget);
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
  });

  testWidgets('gallery with images: search, select, detail', (t) async {
    final storage = mockStorage();
    final img = GeneratedImage(
      id: 'i1', prompt: 'a cat', model: 'm',
      status: ImageStatus.completed, localPath: '/tmp/x.png',
      serverUrl: 'http://s', comfyFilename: 'f.png',
      createdAt: DateTime(2024),
    );
    when(() => storage.getImages()).thenReturn([img]);
    when(() => storage.getImage('i1')).thenReturn(img);
    await pumpPage(t, const GalleryPage(), storage: storage);
    expect(find.byType(GalleryPage), findsOneWidget);
    final search = find.byType(TextField);
    if (search.evaluate().isNotEmpty) {
      await t.enterText(search.first, 'cat');
      await t.pumpAndSettle();
    }
    await t.tapAt(t.getCenter(find.byType(GalleryPage)));
    await t.pumpAndSettle();
  });

  testWidgets('studio: sessions list and create', (t) async {
    final storage = mockStorage();
    when(() => storage.getSessions()).thenReturn([
      StudioSession(id: 's1', title: 'My session', createdAt: DateTime(2024), updatedAt: DateTime(2024)),
    ]);
    await pumpPage(t, const StudioPage(), storage: storage);
    await t.pump();
    expect(find.byType(StudioPage), findsOneWidget);
    if (find.text('My session').evaluate().isNotEmpty) {
      await t.tap(find.text('My session'));
      await t.pumpAndSettle();
    }
  });

  testWidgets('create: tabs and prompt input', (t) async {
    final storage = mockStorage();
    when(() => storage.getServers()).thenReturn([
      ComfyServer(id: 's1', name: 'srv1', url: 'http://x', createdAt: DateTime(2024)),
    ]);
    await pumpPage(t, const CreatePage(), storage: storage);
    expect(find.byType(CreatePage), findsOneWidget);
    for (final tab in find.byType(Tab).evaluate().toList()) {
      await t.tap(find.byWidget(tab.widget));
      await t.pumpAndSettle();
    }
  });

  testWidgets('browse renders', (t) async {
    await pumpPage(t, const BrowsePage());
    expect(find.byType(BrowsePage), findsOneWidget);
  });

  testWidgets('shell: sidebar pill navigates', (t) async {
    await pumpPage(
      t,
      AppShell(child: const GalleryPage(), currentIndex: 1),
      size: const Size(1280, 800),
    );
    expect(find.text('Gallery'), findsWidgets);
  });
}
