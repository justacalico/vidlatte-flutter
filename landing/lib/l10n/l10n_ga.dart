// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class L10nGa extends L10n {
  L10nGa([String locale = 'ga']) : super(locale);

  @override
  String get appName => 'Vidlatte';

  @override
  String get tagline => 'Do stiúideo ComfyUI, driogaillte.';

  @override
  String get heroSub =>
      'Gin íomhánna le do fhreastalaithe ComfyUI féin. Smacht iomlán ar mhúnlaí, LoRAanna, ControlNet agus ionphéinteáil i gcomhéadan suaimhneach laté.';

  @override
  String get getStarted => 'Oscail an aip';

  @override
  String get download => 'Íoslódáil';

  @override
  String get featuresTitle => 'Déanta do dhaoine a ghineann go minic';

  @override
  String get featureServers => 'Freastalaithe ComfyUI iolracha';

  @override
  String get featureServersSub =>
      'Dírigh Vidlatte ar aon chomhlacht ComfyUI amháin nó níos mó agus malartaigh eatarthu.';

  @override
  String get featureAuto => 'Mód Íomhá uathoibríoch';

  @override
  String get featureAutoSub =>
      'Tabhair giniúint leideanna do LLM agus lig do Vidlatte éagsúlachtaí gan deireadh a chruthú.';

  @override
  String get featureGallery => 'Gailearaí a choinníonn suas';

  @override
  String get featureGallerySub =>
      'Cuardaigh, eagraigh seinmliostaí agus glasáil do cheanáin gan an aip a fhágáil.';

  @override
  String get featureStudio => 'Seisiúin stiúideo';

  @override
  String get featureStudioSub =>
      'Grúpáil giniúintí de réir tionscadail agus tosaigh arís as an áit chéanna.';

  @override
  String get downloadsTitle => 'Faigh Vidlatte';

  @override
  String get downloadsSub => 'An eisiúint is déanaí díreach ó GitLab.';

  @override
  String get openOnGitLab => 'Eisiúintí ar GitLab';

  @override
  String versionLabel(String version) {
    return 'Leagan $version';
  }

  @override
  String publishedOn(String date) {
    return 'Eisithe $date';
  }

  @override
  String get noReleases => 'Gan eisiúintí fós. Fill ar ais go luath.';

  @override
  String get releasesError => 'Níorbh fhéidir eisiúintí a lódáil.';

  @override
  String get theme => 'Téama';

  @override
  String get themeSystem => 'Córas';

  @override
  String get themeLight => 'Geal';

  @override
  String get themeDark => 'Dorcha';

  @override
  String get themeOled => 'OLED';

  @override
  String get language => 'Teanga';

  @override
  String get platformsNote =>
      'Android, iOS, Linux, Windows, macOS agus an gréasán.';

  @override
  String flatpakNote(String url) {
    return 'Linux trí Flatpak: flatpak install $url';
  }

  @override
  String get galleryTitle => 'Súil isteach';

  @override
  String get footerSource => 'Foinse ar GitLab';

  @override
  String get downloadApp => 'Íoslódáil';

  @override
  String get prerelease => 'Réamheisiúint';
}
