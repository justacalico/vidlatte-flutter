import 'dart:io';

import 'package:flutter/foundation.dart';

bool? debugDesktopPlatformOverride;

bool isDesktopPlatform() {
  final override = debugDesktopPlatformOverride;
  if (override != null) return override;
  // coverage:ignore-start
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  // coverage:ignore-end
}
