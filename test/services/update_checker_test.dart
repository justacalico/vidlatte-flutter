import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vidlatte/data/models/app_update.dart';
import 'package:vidlatte/services/update_checker.dart';

class _MockClient extends Mock implements http.Client {}

final _info = PackageInfo(appName: 'a', packageName: 'p', version: '1.0.0', buildNumber: '1');

UpdateChecker _checker(String body, {int code = 200, String version = '1.0.0'}) {
  final c = _MockClient();
  when(() => c.get(any())).thenAnswer((_) async => http.Response(body, code));
  return UpdateChecker(
    client: c,
    packageInfo: () async => PackageInfo(appName: 'a', packageName: 'p', version: version, buildNumber: '1'),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  test('no releases -> up to date', () async {
    final u = _checker('[]');
    final r = await u.check();
    expect(u.status, UpdateCheckStatus.upToDate);
    expect(r!.releaseUrl, UpdateChecker.releasesUrl);
    expect(r.updateAvailable, isFalse);
  });

  test('newer release -> update available with tag url', () async {
    final u = _checker('[{"tag_name": "v2.0.0"}]');
    final r = await u.check();
    expect(u.status, UpdateCheckStatus.updateAvailable);
    expect(r!.latestVersion, '2.0.0');
    expect(r.releaseUrl, contains('/-/releases/v2.0.0'));
  });

  test('older release -> up to date', () async {
    final u = _checker('[{"tag_name": "v0.9.0"}]', version: '1.0.0');
    final r = await u.check();
    expect(r!.updateAvailable, isFalse);
  });

  test('non-200 -> failed', () async {
    final u = _checker('x', code: 500);
    expect(await u.check(), isNull);
    expect(u.status, UpdateCheckStatus.failed);
  });

  test('invalid json -> failed', () async {
    final u = _checker('{"a":1}');
    expect(await u.check(), isNull);
    expect(u.status, UpdateCheckStatus.failed);
  });

  test('concurrent checks dedupe to one request', () async {
    final c = _MockClient();
    when(() => c.get(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 20));
      return http.Response('[]', 200);
    });
    final u = UpdateChecker(client: c, packageInfo: () async => _info);
    final results = await Future.wait([u.check(), u.check()]);
    verify(() => c.get(any())).called(1);
    expect(results[0], results[1]);
  });

  test('installedVersion reads package info', () async {
    expect(await _checker('[]').installedVersion(), '1.0.0');
  });

  test('AppUpdate equality and copyWith', () {
    const a = AppUpdate(currentVersion: '1', latestVersion: '2', updateAvailable: true, releaseUrl: 'u');
    expect(a, a.copyWith());
    expect(a, isNot(a.copyWith(latestVersion: '3')));
    expect(a.hashCode, a.copyWith().hashCode);
  });
}
