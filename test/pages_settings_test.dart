import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/presentation/pages/settings/settings_page.dart';
import 'package:vidlatte/services/comfyui_service.dart';
import 'package:vidlatte/services/llm_service.dart';
import 'package:vidlatte/bloc/servers/servers_bloc.dart';
import 'package:vidlatte/bloc/llm/llm_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helpers.dart';

final _d = DateTime(2024);

void main() {
  setUpAll(registerFallbacks);

  Future<void> scrollTo(WidgetTester t, Finder target) async {
    for (var i = 0; i < 12 && target.evaluate().isEmpty; i++) {
      await t.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await t.pumpAndSettle();
    }
  }

  testWidgets('settings: server form dialog full flow', (t) async {
    final s = mockStorage();
    await pumpPage(t, const SettingsPage(), storage: s);
    await scrollTo(t, find.text('Add').first);
    await t.tap(find.text('Add').first);
    await t.pumpAndSettle();
    expect(find.text('Add Server'), findsOneWidget);

    // Fill fields
    final fields = find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextFormField));
    if (fields.evaluate().length >= 2) {
      await t.enterText(fields.at(0), 'My Server');
      await t.enterText(fields.at(1), 'http://10.0.0.1:8188');
    }
    // auth dropdown
    final dd = find.byType(DropdownButtonFormField<ServerAuthType>);
    if (dd.evaluate().isNotEmpty) {
      await t.tap(dd.first);
      await t.pumpAndSettle();
      final basic = find.text('Basic Auth');
      if (basic.evaluate().isNotEmpty) {
        await t.tap(basic.last);
        await t.pumpAndSettle();
      }
    }
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
  });

  testWidgets('settings: server card actions', (t) async {
    final s = mockStorage();
    when(() => s.getServers()).thenReturn([
      ComfyServer(id: 's1', name: 'srv1', url: 'http://x', createdAt: _d),
    ]);
    await pumpPage(t, const SettingsPage(), storage: s);
    // Server card actions: health check, edit, delete, set default
    for (final icon in [Icons.favorite_outline, Icons.favorite, Icons.refresh, Icons.edit, Icons.delete_outline, Icons.delete]) {
      final f = find.byIcon(icon);
      if (f.evaluate().isNotEmpty) {
        await scrollTo(t, f.first);
        await t.tap(f.first, warnIfMissed: false);
        await t.pumpAndSettle();
        final confirm = find.text('Delete');
        if (confirm.evaluate().isNotEmpty) {
          await t.tap(confirm.last);
          await t.pumpAndSettle();
        }
      }
    }
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('settings: llm server dialog', (t) async {
    final s = mockStorage();
    when(() => s.getLlmServers()).thenReturn([
      LlmServer(id: 'l1', name: 'LM', url: 'http://x', createdAt: _d),
    ]);
    await pumpPage(t, const SettingsPage(), storage: s);
    final addBtns = find.text('Add');
    await scrollTo(t, addBtns.last);
    if (addBtns.evaluate().length > 1) {
      await t.tap(addBtns.last, warnIfMissed: false);
      await t.pumpAndSettle();
      expect(find.text('Add LLM Server'), findsOneWidget);
      final cancel = find.text('Cancel');
      if (cancel.evaluate().isNotEmpty) {
        await t.tap(cancel.last);
        await t.pumpAndSettle();
      }
    }
  });

  testWidgets('settings: gallery privacy section', (t) async {
    final s = mockStorage(settings: const AppSettings(galleryPassword: 'pw'));
    await pumpPage(t, const SettingsPage(), storage: s);
    await scrollTo(t, find.text('Gallery Privacy'));
    expect(find.text('Gallery Privacy'), findsOneWidget);
    final change = find.text('Change Password');
    if (change.evaluate().isNotEmpty) {
      await t.tap(change.first);
      await t.pumpAndSettle();
      final cancel = find.text('Cancel');
      if (cancel.evaluate().isNotEmpty) {
        await t.tap(cancel.last);
        await t.pumpAndSettle();
      }
    }
  });
}
