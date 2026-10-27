// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Vidlatte';

  @override
  String get tagline => '你的 ComfyUI 工作室，浓缩于一杯拿铁。';

  @override
  String get heroSub =>
      '使用你自己的 ComfyUI 服务器生成图像。完全掌控模型、LoRA、ControlNet 和局部重绘，一切尽在安静的拿铁色调界面中。';

  @override
  String get getStarted => '打开应用';

  @override
  String get download => '下载';

  @override
  String get featuresTitle => '为高频生成而生';

  @override
  String get featureServers => '多个 ComfyUI 服务器';

  @override
  String get featureServersSub => '将 Vidlatte 指向一个或多个 ComfyUI 实例，随时切换。';

  @override
  String get featureAuto => '自动图像模式';

  @override
  String get featureAutoSub => '把提示词交给 LLM，让 Vidlatte 生成无穷变体。';

  @override
  String get featureGallery => '跟得上的画廊';

  @override
  String get featureGallerySub => '无需离开应用即可搜索、整理歌单和锁定收藏。';

  @override
  String get featureStudio => '工作室会话';

  @override
  String get featureStudioSub => '按项目分组生成记录，随时继续。';

  @override
  String get downloadsTitle => '获取 Vidlatte';

  @override
  String get downloadsSub => '直接从 GitLab 拉取的最新发布。';

  @override
  String get openOnGitLab => 'GitLab 发布页';

  @override
  String versionLabel(String version) {
    return '版本 $version';
  }

  @override
  String publishedOn(String date) {
    return '发布于 $date';
  }

  @override
  String get noReleases => '暂无发布，稍后再来看看。';

  @override
  String get releasesError => '无法加载发布。';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeOled => 'OLED';

  @override
  String get language => '语言';

  @override
  String get platformsNote => 'Android、iOS、Linux、Windows、macOS 和网页版。';

  @override
  String flatpakNote(String url) {
    return 'Linux Flatpak：flatpak install $url';
  }

  @override
  String get galleryTitle => '界面一览';

  @override
  String get footerSource => 'GitLab 源代码';

  @override
  String get downloadApp => '下载';

  @override
  String get prerelease => '预发布';
}
