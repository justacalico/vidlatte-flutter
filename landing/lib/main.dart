import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'l10n/l10n.dart';

const kGitLabProject = 'HttpAnimations/vidlatte-flutter';
const kGitLabReleasesUrl = 'https://gitlab.com/$kGitLabProject/-/releases';
const kPagesBase = 'https://httpanimations.gitlab.io/vidlatte-flutter';

void main() {
  runApp(const LandingApp());
}

ThemeData _theme(Brightness brightness, {bool oled = false}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFB5663D),
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: oled && brightness == Brightness.dark
        ? scheme.copyWith(surface: Colors.black)
        : scheme,
    scaffoldBackgroundColor:
        oled && brightness == Brightness.dark ? Colors.black : null,
  );
}

class LandingApp extends StatefulWidget {
  const LandingApp({super.key});

  @override
  State<LandingApp> createState() => _LandingAppState();
}

class _LandingAppState extends State<LandingApp> {
  String _theme = 'system';
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _theme = prefs.getString('landing_theme') ?? 'system';
        final lang = prefs.getString('landing_lang');
        _locale = lang == null || lang == 'system' ? null : _localeFromTag(lang);
      });
    });
  }

  void _setTheme(String theme) {
    setState(() => _theme = theme);
    SharedPreferences.getInstance()
        .then((p) => p.setString('landing_theme', theme));
  }

  void _setLocale(String tag) {
    setState(() => _locale = tag == 'system' ? null : _localeFromTag(tag));
    SharedPreferences.getInstance()
        .then((p) => p.setString('landing_lang', tag));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidlatte',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark, oled: _theme == 'oled'),
      highContrastDarkTheme: _theme(Brightness.dark, oled: _theme == 'oled'),
      themeMode: switch (_theme) {
        'light' => ThemeMode.light,
        'dark' || 'oled' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      locale: _locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.localizationsDelegates,
      home: LandingPage(
        theme: _theme,
        onTheme: _setTheme,
        onLocale: _setLocale,
      ),
    );
  }
}

Locale _localeFromTag(String tag) => switch (tag) {
      'en' || 'en-GB' => const Locale('en', 'GB'),
      'zh' => const Locale('zh'),
      'ru' => const Locale('ru'),
      'ga' => const Locale('ga'),
      _ => const Locale('en'),
    };

class LandingPage extends StatefulWidget {
  final String theme;
  final ValueChanged<String> onTheme;
  final ValueChanged<String> onLocale;

  const LandingPage({
    super.key,
    required this.theme,
    required this.onTheme,
    required this.onLocale,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<List<Map<String, dynamic>>> _releases;

  @override
  void initState() {
    super.initState();
    _releases = fetchReleases();
  }

  @override
  Widget build(BuildContext context) {
    final s = L10n.of(context);
    final wide = MediaQuery.sizeOf(context).width > 720;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset('assets/icon.png', width: 26, height: 26),
            ),
            const SizedBox(width: 10),
            Text(s.appName),
          ],
        ),
        actions: [
          _ThemePicker(theme: widget.theme, onChanged: widget.onTheme),
          _LangPicker(onChanged: widget.onLocale),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: wide ? 96 : 20,
          vertical: 32,
        ),
        children: [
          Text(
            s.tagline,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            s.heroSub,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(s.getStarted),
                onPressed: () => launchUrl(Uri.parse('$kPagesBase/app/')),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.code),
                label: Text(s.footerSource),
                onPressed: () =>
                    launchUrl(Uri.parse('https://gitlab.com/$kGitLabProject')),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Text(s.featuresTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _FeatureCard(icon: Icons.dns_outlined, title: s.featureServers, sub: s.featureServersSub, wide: wide),
              _FeatureCard(icon: Icons.auto_awesome, title: s.featureAuto, sub: s.featureAutoSub, wide: wide),
              _FeatureCard(icon: Icons.photo_library_outlined, title: s.featureGallery, sub: s.featureGallerySub, wide: wide),
              _FeatureCard(icon: Icons.dashboard_outlined, title: s.featureStudio, sub: s.featureStudioSub, wide: wide),
            ],
          ),
          const SizedBox(height: 48),
          Text(s.galleryTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          const _ScreensRow(),
          const SizedBox(height: 48),
          Text(s.downloadsTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(s.downloadsSub),
          const SizedBox(height: 16),
          _ReleasesList(releases: _releases),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: Text(s.openOnGitLab),
            onPressed: () => launchUrl(Uri.parse(kGitLabReleasesUrl)),
          ),
          const SizedBox(height: 24),
          Text(s.platformsNote,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          SelectableText(
            s.flatpakNote('$kPagesBase/vidlatte.flatpakref'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchReleases([http.Client? client]) async {
  final c = client ?? http.Client();
  try {
    final res = await c.get(Uri.parse(
        'https://gitlab.com/api/v4/projects/${Uri.encodeComponent(kGitLabProject)}/releases?per_page=20&order_by=released_at&sort=desc'));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final decoded = jsonDecode(res.body);
    if (decoded is! List) throw Exception('unexpected');
    return decoded.whereType<Map<String, dynamic>>().toList();
  } finally {
    if (client == null) c.close();
  }
}

class _ReleasesList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> releases;

  const _ReleasesList({required this.releases});

  @override
  Widget build(BuildContext context) {
    final s = L10n.of(context);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: releases,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) return Text(s.releasesError);
        final list = snap.data ?? const [];
        if (list.isEmpty) return Text(s.noReleases);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final r in list.take(5))
              Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: Text(s.versionLabel('${r['tag_name']}')),
                  subtitle: Text(s.publishedOn(
                      '${r['released_at']}'.substring(0, 10))),
                  children: [
                    for (final link
                        in (r['assets']?['links'] as List? ?? const [])
                            .whereType<Map>())
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.download),
                        title: Text('${link['name']}'),
                        onTap: () =>
                            launchUrl(Uri.parse('${link['direct_asset_url'] ?? link['url']}')),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ScreensRow extends StatelessWidget {
  const _ScreensRow();

  static const _shots = [
    'assets/screens/create.png',
    'assets/screens/gallery.png',
    'assets/screens/settings.png',
    'assets/screens/studio.png',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _shots.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            _shots[i],
            height: 320,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final bool wide;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.sub,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: wide ? 300 : double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(sub, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final String theme;
  final ValueChanged<String> onChanged;

  const _ThemePicker({required this.theme, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = L10n.of(context);
    return PopupMenuButton<String>(
      icon: const Icon(Icons.brightness_6_outlined),
      tooltip: s.theme,
      onSelected: onChanged,
      itemBuilder: (context) => [
        ('system', s.themeSystem),
        ('light', s.themeLight),
        ('dark', s.themeDark),
        ('oled', s.themeOled),
      ]
          .map((e) => PopupMenuItem(
                value: e.$1,
                child: Row(
                  children: [
                    if (e.$1 == theme)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(e.$2),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _LangPicker extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _LangPicker({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = L10n.of(context);
    const langs = [
      ('system', 'System'),
      ('en-GB', 'Traditional English'),
      ('zh', '简体中文'),
      ('ru', 'Русский'),
      ('ga', 'Gaeilge'),
    ];
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: s.language,
      onSelected: onChanged,
      itemBuilder: (context) => langs
          .map((e) => PopupMenuItem(value: e.$1, child: Text(e.$2)))
          .toList(),
    );
  }
}
