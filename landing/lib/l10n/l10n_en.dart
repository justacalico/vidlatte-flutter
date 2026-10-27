// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Vidlatte';

  @override
  String get tagline => 'Your ComfyUI studio, distilled.';

  @override
  String get heroSub =>
      'Generate images with your own ComfyUI servers. Full control over models, LoRAs, ControlNet and inpainting, wrapped in a calm latte-toned interface.';

  @override
  String get getStarted => 'Open the app';

  @override
  String get download => 'Download';

  @override
  String get featuresTitle => 'Made for people who generate a lot';

  @override
  String get featureServers => 'Multiple ComfyUI servers';

  @override
  String get featureServersSub =>
      'Point Vidlatte at one or more ComfyUI instances and switch between them.';

  @override
  String get featureAuto => 'Auto Image mode';

  @override
  String get featureAutoSub =>
      'Hand prompt generation to an LLM and let Vidlatte produce endless variations.';

  @override
  String get featureGallery => 'A gallery that keeps up';

  @override
  String get featureGallerySub =>
      'Search, playlist and lock your favourites without leaving the app.';

  @override
  String get featureStudio => 'Studio sessions';

  @override
  String get featureStudioSub =>
      'Group generations by project and pick up where you left off.';

  @override
  String get downloadsTitle => 'Get Vidlatte';

  @override
  String get downloadsSub => 'Latest release pulled straight from GitLab.';

  @override
  String get openOnGitLab => 'GitLab releases';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String publishedOn(String date) {
    return 'Released $date';
  }

  @override
  String get noReleases => 'No releases yet. Check back soon.';

  @override
  String get releasesError => 'Could not load releases.';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOled => 'OLED';

  @override
  String get language => 'Language';

  @override
  String get platformsNote => 'Android, iOS, Linux, Windows, macOS and web.';

  @override
  String flatpakNote(String url) {
    return 'Linux via Flatpak: flatpak install $url';
  }

  @override
  String get galleryTitle => 'A look inside';

  @override
  String get footerSource => 'Source on GitLab';

  @override
  String get downloadApp => 'Download';

  @override
  String get prerelease => 'Pre-release';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class L10nEnGb extends L10nEn {
  L10nEnGb() : super('en_GB');

  @override
  String get appName => 'Vidlatte';

  @override
  String get tagline => 'Your ComfyUI studio, distilled.';

  @override
  String get heroSub =>
      'Generate images with your own ComfyUI servers. Full control over models, LoRAs, ControlNet and inpainting, wrapped in a calm latte-toned interface.';

  @override
  String get getStarted => 'Open the app';

  @override
  String get download => 'Download';

  @override
  String get featuresTitle => 'Made for people who generate a lot';

  @override
  String get featureServers => 'Multiple ComfyUI servers';

  @override
  String get featureServersSub =>
      'Point Vidlatte at one or more ComfyUI instances and switch between them.';

  @override
  String get featureAuto => 'Auto Image mode';

  @override
  String get featureAutoSub =>
      'Hand prompt generation to an LLM and let Vidlatte produce endless variations.';

  @override
  String get featureGallery => 'A gallery that keeps up';

  @override
  String get featureGallerySub =>
      'Search, playlist and lock your favourites without leaving the app.';

  @override
  String get featureStudio => 'Studio sessions';

  @override
  String get featureStudioSub =>
      'Group generations by project and pick up where you left off.';

  @override
  String get downloadsTitle => 'Get Vidlatte';

  @override
  String get downloadsSub => 'Latest release pulled straight from GitLab.';

  @override
  String get openOnGitLab => 'GitLab releases';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String publishedOn(String date) {
    return 'Released $date';
  }

  @override
  String get noReleases => 'No releases yet. Check back soon.';

  @override
  String get releasesError => 'Could not load releases.';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOled => 'OLED';

  @override
  String get language => 'Language';

  @override
  String get platformsNote => 'Android, iOS, Linux, Windows, macOS and web.';

  @override
  String flatpakNote(String url) {
    return 'Linux via Flatpak: flatpak install $url';
  }

  @override
  String get galleryTitle => 'A look inside';

  @override
  String get footerSource => 'Source on GitLab';

  @override
  String get downloadApp => 'Download';

  @override
  String get prerelease => 'Pre-release';
}
