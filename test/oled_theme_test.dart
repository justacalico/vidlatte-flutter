import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/bloc/settings/settings_bloc.dart';
import 'package:vidlatte/config/theme.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/presentation/pages/settings/settings_page.dart';

import 'helpers.dart';

void main() {
  setUpAll(registerFallbacks);

  test('oledTheme uses pure black background', () {
    final t = AppTheme.oledTheme;
    expect(t.brightness, Brightness.dark);
    expect(t.scaffoldBackgroundColor, Colors.black);
    expect(t.colorScheme.surface, const Color(0xFF0A0A0A));
    final ext = t.extension<AppColors>()!;
    expect(ext.surfaceElevated, const Color(0xFF0D0D0D));
    expect(ext.border, const Color(0xFF1E1E1E));
    expect(t.inputDecorationTheme.fillColor, const Color(0xFF0A0A0A));
    expect(t.chipTheme.backgroundColor, const Color(0xFF111111));
  });

  testWidgets('settings: oled option dispatches ThemeModeChanged', (t) async {
    final s = mockStorage();
    await pumpPage(t, const SettingsPage(), storage: s);
    await t.tap(find.text('OLED'));
    await t.pumpAndSettle();
    expect(AppTheme.modeFor('oled'), ThemeMode.dark);
    expect(AppTheme.darkVariantFor('oled').scaffoldBackgroundColor, Colors.black);
    expect(AppTheme.darkVariantFor('dark').scaffoldBackgroundColor,
        AppTheme.darkTheme.scaffoldBackgroundColor);
    expect(AppTheme.darkVariantFor('light').scaffoldBackgroundColor,
        AppTheme.darkTheme.scaffoldBackgroundColor);
    expect(AppTheme.modeFor('light'), ThemeMode.light);
    expect(AppTheme.modeFor('dark'), ThemeMode.dark);
    expect(AppTheme.modeFor('system'), ThemeMode.system);
    expect(
      t.element(find.byType(SettingsPage))
          .read<SettingsBloc>()
          .state
          .settings
          .themeMode,
      'oled',
    );
  });

  testWidgets('settings: oled selected state renders', (t) async {
    final s = mockStorage(settings: const AppSettings(themeMode: 'oled'));
    await pumpPage(t, const SettingsPage(), storage: s);
    await t.pumpAndSettle();
    expect(find.text('OLED'), findsOneWidget);
  });
}
