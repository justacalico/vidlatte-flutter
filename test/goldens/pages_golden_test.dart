import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/presentation/pages/browse/browse_page.dart';
import 'package:vidlatte/presentation/pages/create/create_page.dart';
import 'package:vidlatte/presentation/pages/create/inpaint_page.dart';
import 'package:vidlatte/presentation/pages/gallery/gallery_page.dart';
import 'package:vidlatte/presentation/pages/settings/settings_page.dart';
import 'package:vidlatte/presentation/pages/studio/studio_page.dart';
import 'package:vidlatte/presentation/widgets/shell/app_shell.dart';

import '../helpers.dart';

void main() {
  setUpAll(registerFallbacks);

  const desktop = Size(1280, 800);
  const phone = Size(400, 800);

  final pages = <String, (int, Widget)>{
    'create': (0, const CreatePage()),
    'gallery': (1, const GalleryPage()),
    'studio': (2, const StudioPage()),
    'settings': (3, const SettingsPage()),
  };

  for (final entry in pages.entries) {
    for (final loc in [null, const Locale('ga')]) {
      final suffix = loc == null ? '' : '_ga';
      testWidgets('${entry.key} desktop golden$suffix', (tester) async {
        await pumpPage(
          tester,
          AppShell(child: entry.value.$2, currentIndex: entry.value.$1),
          size: desktop,
          locale: loc,
        );
        await expectLater(
          find.byType(AppShell),
          matchesGoldenFile('goldens/${entry.key}_desktop$suffix.png'),
        );
      });
    }

    testWidgets('${entry.key} phone golden', (tester) async {
      await pumpPage(
        tester,
        AppShell(child: entry.value.$2, currentIndex: entry.value.$1),
        size: phone,
      );
      await expectLater(
        find.byType(AppShell),
        matchesGoldenFile('goldens/${entry.key}_phone.png'),
      );
    });
  }

  testWidgets('browse golden', (tester) async {
    await pumpPage(tester, const BrowsePage(), size: desktop);
    await expectLater(
      find.byType(BrowsePage),
      matchesGoldenFile('goldens/browse_desktop.png'),
    );
  });

  testWidgets('inpaint golden', (tester) async {
    await pumpPage(tester, const InpaintPage(), size: desktop);
    await expectLater(
      find.byType(InpaintPage),
      matchesGoldenFile('goldens/inpaint_desktop.png'),
    );
  });
}
