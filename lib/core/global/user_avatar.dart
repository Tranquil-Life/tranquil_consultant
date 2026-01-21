import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AvatarSource { url, storagePath, svgString }

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.size = 48,
    this.imageUrl,      // full http(s) URL
    this.storagePath,   // firebase storage path: profile_image/xxx.jpg
    this.source,
    this.decoration,
  });

  final double size;
  final String? imageUrl;
  final String? storagePath;
  final AvatarSource? source;
  final BoxDecoration? decoration;

  static const Widget _placeHolder = Center(
    child: Padding(
      padding: EdgeInsets.all(12),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Icon(Icons.person, color: Colors.grey),
      ),
    ),
  );

  Widget _networkImage(String url) {
    final clean = url.trim().replaceAll('\n', '');
    if (!clean.startsWith('http')) return _placeHolder;

    return Image.network(
      clean,
      fit: BoxFit.cover,
      // helpful on web
      loadingBuilder: (context, child, progress) =>
      progress == null ? child : _placeHolder,
      errorBuilder: (context, error, stack) {
        debugPrint("Avatar image load error: $error");
        return _placeHolder;
      },
    );
  }

  Widget _fromStoragePath(String path) {
    final p = path.trim();
    if (p.isEmpty) return _placeHolder;

    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(p).getDownloadURL(),
      builder: (context, snap) {
        if (!snap.hasData) return _placeHolder;
        return _networkImage(snap.data!);
      },
    );
  }

  Widget _fromSvgString(String svg) {
    try {
      return SvgPicture.string(
        svg,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => _placeHolder,
      );
    } catch (_) {
      return _placeHolder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;

    // If storagePath is provided, always prefer it.
    if ((storagePath ?? '').trim().isNotEmpty) {
      content = _fromStoragePath(storagePath!);
    } else {
      switch (source) {
        case AvatarSource.url:
          content = _networkImage(imageUrl ?? '');
          break;
        case AvatarSource.svgString:
          content = _fromSvgString(imageUrl ?? '');
          break;
        default:
          final v = (imageUrl ?? '').trim();
          content = v.startsWith('http') ? _networkImage(v) : _placeHolder;
      }
    }

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: decoration ?? const BoxDecoration(shape: BoxShape.circle),
      child: content,
    );
  }
}
