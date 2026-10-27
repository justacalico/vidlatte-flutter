import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_ga.dart';
import 'l10n_ru.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'GB'),
    Locale('ga'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Vidlatte'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your ComfyUI studio, distilled.'**
  String get tagline;

  /// No description provided for @heroSub.
  ///
  /// In en, this message translates to:
  /// **'Generate images with your own ComfyUI servers. Full control over models, LoRAs, ControlNet and inpainting, wrapped in a calm latte-toned interface.'**
  String get heroSub;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Open the app'**
  String get getStarted;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Made for people who generate a lot'**
  String get featuresTitle;

  /// No description provided for @featureServers.
  ///
  /// In en, this message translates to:
  /// **'Multiple ComfyUI servers'**
  String get featureServers;

  /// No description provided for @featureServersSub.
  ///
  /// In en, this message translates to:
  /// **'Point Vidlatte at one or more ComfyUI instances and switch between them.'**
  String get featureServersSub;

  /// No description provided for @featureAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto Image mode'**
  String get featureAuto;

  /// No description provided for @featureAutoSub.
  ///
  /// In en, this message translates to:
  /// **'Hand prompt generation to an LLM and let Vidlatte produce endless variations.'**
  String get featureAutoSub;

  /// No description provided for @featureGallery.
  ///
  /// In en, this message translates to:
  /// **'A gallery that keeps up'**
  String get featureGallery;

  /// No description provided for @featureGallerySub.
  ///
  /// In en, this message translates to:
  /// **'Search, playlist and lock your favourites without leaving the app.'**
  String get featureGallerySub;

  /// No description provided for @featureStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio sessions'**
  String get featureStudio;

  /// No description provided for @featureStudioSub.
  ///
  /// In en, this message translates to:
  /// **'Group generations by project and pick up where you left off.'**
  String get featureStudioSub;

  /// No description provided for @downloadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Vidlatte'**
  String get downloadsTitle;

  /// No description provided for @downloadsSub.
  ///
  /// In en, this message translates to:
  /// **'Latest release pulled straight from GitLab.'**
  String get downloadsSub;

  /// No description provided for @openOnGitLab.
  ///
  /// In en, this message translates to:
  /// **'GitLab releases'**
  String get openOnGitLab;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @publishedOn.
  ///
  /// In en, this message translates to:
  /// **'Released {date}'**
  String publishedOn(String date);

  /// No description provided for @noReleases.
  ///
  /// In en, this message translates to:
  /// **'No releases yet. Check back soon.'**
  String get noReleases;

  /// No description provided for @releasesError.
  ///
  /// In en, this message translates to:
  /// **'Could not load releases.'**
  String get releasesError;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeOled.
  ///
  /// In en, this message translates to:
  /// **'OLED'**
  String get themeOled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @platformsNote.
  ///
  /// In en, this message translates to:
  /// **'Android, iOS, Linux, Windows, macOS and web.'**
  String get platformsNote;

  /// No description provided for @flatpakNote.
  ///
  /// In en, this message translates to:
  /// **'Linux via Flatpak: flatpak install {url}'**
  String flatpakNote(String url);

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'A look inside'**
  String get galleryTitle;

  /// No description provided for @footerSource.
  ///
  /// In en, this message translates to:
  /// **'Source on GitLab'**
  String get footerSource;

  /// No description provided for @downloadApp.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadApp;

  /// No description provided for @prerelease.
  ///
  /// In en, this message translates to:
  /// **'Pre-release'**
  String get prerelease;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ga', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return L10nEnGb();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ga':
      return L10nGa();
    case 'ru':
      return L10nRu();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
