import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../data/models/app_update.dart';
import '../utils/version_utils.dart';

class UpdateCheckException implements Exception {
  final String message;

  const UpdateCheckException(this.message);

  @override
  String toString() => 'UpdateCheckException: $message';
}

enum UpdateCheckStatus { idle, checking, upToDate, updateAvailable, failed }

class UpdateChecker extends ChangeNotifier {
  static const _host = 'gitlab.com';
  static const _projectPath = 'HttpAnimations%2Fvidlatte-flutter';
  static const _perPage = 100;
  static const _maxPages = 10;
  static const releasesUrl =
      'https://$_host/HttpAnimations/vidlatte-flutter/-/releases';

  final http.Client _client;
  final bool _ownsClient;
  final Future<PackageInfo> Function() _packageInfo;

  UpdateCheckStatus _status = UpdateCheckStatus.idle;
  AppUpdate? _lastResult;
  Future<AppUpdate?>? _inFlight;

  UpdateChecker({
    http.Client? client,
    Future<PackageInfo> Function()? packageInfo,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null,
        _packageInfo = packageInfo ?? PackageInfo.fromPlatform;

  UpdateCheckStatus get status => _status;
  AppUpdate? get lastResult => _lastResult;

  Future<String> installedVersion() async =>
      (await _packageInfo()).version;

  Future<AppUpdate?> check() {
    final existing = _inFlight;
    if (existing != null) return existing;
    return _inFlight = _runCheck().whenComplete(() => _inFlight = null);
  }

  Future<AppUpdate?> _runCheck() async {
    _status = UpdateCheckStatus.checking;
    notifyListeners();
    try {
      final info = await _packageInfo();
      final latest = await _fetchLatestRelease();
      final current = Version.parse(info.version);
      late final AppUpdate update;
      if (latest == null) {
        update = AppUpdate(
          currentVersion: info.version,
          releaseUrl: releasesUrl,
        );
      } else {
        update = AppUpdate(
          currentVersion: info.version,
          latestVersion: latest.version.toString(),
          updateAvailable:
              current == null || latest.version.compareTo(current) > 0,
          releaseUrl: _releaseUrl(latest.tag),
        );
      }
      _lastResult = update;
      _status = update.updateAvailable
          ? UpdateCheckStatus.updateAvailable
          : UpdateCheckStatus.upToDate;
      notifyListeners();
      return update;
    } catch (_) {
      _status = UpdateCheckStatus.failed;
      notifyListeners();
      return null;
    }
  }

  Future<({Version version, String tag})?> _fetchLatestRelease() async {
    Version? maxVersion;
    String? maxTag;
    for (var page = 1; page <= _maxPages; page++) {
      try {
        final uri = Uri.https(
          _host,
          '/api/v4/projects/$_projectPath/releases',
          {
            'per_page': '$_perPage',
            'order_by': 'released_at',
            'sort': 'desc',
            'page': '$page',
          },
        );
        final response = await _client.get(uri);
        if (response.statusCode != 200) {
          throw UpdateCheckException('HTTP ${response.statusCode}');
        }
        final decoded = jsonDecode(response.body);
        if (decoded is! List<dynamic>) {
          throw const UpdateCheckException('unexpected response shape');
        }
        for (final release in decoded) {
          if (release is! Map<String, dynamic>) continue;
          final tag = release['tag_name'];
          if (tag is! String) continue;
          final version = Version.parse(tag);
          if (version == null) continue;
          if (maxVersion == null || version.compareTo(maxVersion) > 0) {
            maxVersion = version;
            maxTag = tag;
          }
        }
        if (decoded.length < _perPage) break;
      } catch (e) {
        if (e is UpdateCheckException) rethrow;
        throw UpdateCheckException('$e');
      }
    }
    if (maxVersion == null || maxTag == null) return null;
    return (version: maxVersion, tag: maxTag);
  }

  String _releaseUrl(String tag) => '$releasesUrl/${Uri.encodeComponent(tag)}';

  @override
  void dispose() {
    if (_ownsClient) _client.close();
    super.dispose();
  }
}

class NoNetworkUpdateChecker extends UpdateChecker {
  NoNetworkUpdateChecker() : super(client: http.Client());

  @override
  Future<AppUpdate?> check() async => null;
}
