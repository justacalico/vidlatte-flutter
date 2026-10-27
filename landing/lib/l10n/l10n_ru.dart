// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Vidlatte';

  @override
  String get tagline => 'Ваша студия ComfyUI в одном приложении.';

  @override
  String get heroSub =>
      'Генерируйте изображения на своих серверах ComfyUI. Полный контроль над моделями, LoRA, ControlNet и инпейнтингом в спокойном интерфейсе тонов латте.';

  @override
  String get getStarted => 'Открыть приложение';

  @override
  String get download => 'Скачать';

  @override
  String get featuresTitle => 'Для тех, кто генерирует много';

  @override
  String get featureServers => 'Несколько серверов ComfyUI';

  @override
  String get featureServersSub =>
      'Подключите один или несколько инстансов ComfyUI и переключайтесь между ними.';

  @override
  String get featureAuto => 'Режим Auto Image';

  @override
  String get featureAutoSub =>
      'Поручите генерацию промптов LLM и получайте бесконечные вариации.';

  @override
  String get featureGallery => 'Галерея, которая успевает';

  @override
  String get featureGallerySub =>
      'Поиск, плейлисты и скрытые изображения, не выходя из приложения.';

  @override
  String get featureStudio => 'Студийные сессии';

  @override
  String get featureStudioSub =>
      'Группируйте генерации по проектам и продолжайте с того же места.';

  @override
  String get downloadsTitle => 'Скачать Vidlatte';

  @override
  String get downloadsSub => 'Свежий релиз прямо с GitLab.';

  @override
  String get openOnGitLab => 'Релизы на GitLab';

  @override
  String versionLabel(String version) {
    return 'Версия $version';
  }

  @override
  String publishedOn(String date) {
    return 'Выпущено $date';
  }

  @override
  String get noReleases => 'Пока нет релизов. Загляните позже.';

  @override
  String get releasesError => 'Не удалось загрузить релизы.';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeOled => 'OLED';

  @override
  String get language => 'Язык';

  @override
  String get platformsNote => 'Android, iOS, Linux, Windows, macOS и веб.';

  @override
  String flatpakNote(String url) {
    return 'Linux через Flatpak: flatpak install $url';
  }

  @override
  String get galleryTitle => 'Взгляд внутрь';

  @override
  String get footerSource => 'Исходный код на GitLab';

  @override
  String get downloadApp => 'Скачать';

  @override
  String get prerelease => 'Предрелиз';
}
