import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// ---------------------------------------------------------------------------
/// PLATFORM HELPERS
/// ---------------------------------------------------------------------------

class PlatformHelpers {
  PlatformHelpers._(); // private constructor (static-only class)

  /// True if running on iOS or macOS (not web)
  static bool get isApple {
    if (kIsWeb) return false;
    try {
      return Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  static bool get isAndroid {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  static bool get isMobile => isAndroid || isApple;

  /// Returns an Apple-safe audio URL
  ///
  /// - Converts `.webm` → `.m4a`
  /// - Forces AAC format using Cloudinary-style `/upload/f_aac/`
  /// - No-op on non-Apple platforms
  static String appleSafeUrl(String url) {
    if (!isApple) return url;
    if (!url.contains('/upload/')) return url;

    final bool isWebm = url.endsWith('.webm');

    final String transformed =
    url.replaceFirst('/upload/', '/upload/f_aac/');

    return isWebm
        ? transformed.replaceFirst('.webm', '.m4a')
        : transformed;
  }


}
