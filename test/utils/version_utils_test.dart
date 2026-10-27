import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/utils/version_utils.dart';

void main() {
  group('Version.parse', () {
    test('parses plain semver', () {
      final v = Version.parse('1.2.3')!;
      expect(v.core, [1, 2, 3]);
      expect(v.pre, isNull);
      expect(v.toString(), '1.2.3');
    });
    test('strips v prefix and build metadata', () {
      expect(Version.parse('v2.0.1')!.core, [2, 0, 1]);
      expect(Version.parse('v1.0.0+42')!.toString(), '1.0.0');
    });
    test('parses prerelease', () {
      final v = Version.parse('1.2.3-beta.2')!;
      expect(v.pre, ['beta', '2']);
      expect(v.toString(), '1.2.3-beta.2');
    });
    test('rejects invalid input', () {
      expect(Version.parse(null), isNull);
      expect(Version.parse(''), isNull);
      expect(Version.parse('1.2'), isNull);
      expect(Version.parse('1.2.3.4'), isNull);
      expect(Version.parse('a.b.c'), isNull);
      expect(Version.parse('01.2.3'), isNull);
      expect(Version.parse('1.2.3-'), isNull);
      expect(Version.parse('1.2.3-!!'), isNull);
      expect(Version.parse('1.2.3-01'), isNull);
    });
  });

  group('Version.compareTo', () {
    test('compares cores', () {
      expect(Version.parse('1.0.0')!.compareTo(Version.parse('2.0.0')!), lessThan(0));
      expect(Version.parse('1.0.0')!.compareTo(Version.parse('1.0.0')!), 0);
      expect(Version.parse('1.10.0')!.compareTo(Version.parse('1.2.0')!), greaterThan(0));
    });
    test('prerelease ordering', () {
      expect(Version.parse('1.0.0-alpha')!.compareTo(Version.parse('1.0.0')!), lessThan(0));
      expect(Version.parse('1.0.0')!.compareTo(Version.parse('1.0.0-alpha')!), greaterThan(0));
      expect(Version.parse('1.0.0-1')!.compareTo(Version.parse('1.0.0-alpha')!), lessThan(0));
      expect(Version.parse('1.0.0-alpha')!.compareTo(Version.parse('1.0.0-alpha.1')!), lessThan(0));
      expect(Version.parse('1.0.0-alpha')!.compareTo(Version.parse('1.0.0-alpha')!), 0);
    });
  });

  group('Version equality', () {
    test('equal and hash', () {
      expect(Version.parse('1.2.3'), Version.parse('v1.2.3'));
      expect(Version.parse('1.2.3').hashCode, Version.parse('1.2.3').hashCode);
      expect(Version.parse('1.2.3'), isNot(Version.parse('1.2.4')));
      expect(Version.parse('1.2.3-a'), isNot(Version.parse('1.2.3')));
    });
  });
}
