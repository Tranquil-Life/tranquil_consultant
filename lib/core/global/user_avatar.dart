import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tl_consultant/core/global/pulsing_widget.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum AvatarSource { file, url, bitmojiUrl }


class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.size = 48,
    this.imageUrl,        // full http(s) URL (optional; legacy)
    this.storagePath,     // Firebase Storage path (recommended)
    this.source,          // file/url/bitmojiUrl (ignored if storagePath provided)
    this.decoration,
    this.filePath,        // local file path if using AvatarSource.file
  });

  final double size;
  final String? imageUrl;       // ex: https://firebasestorage.googleapis.com/...
  final String? storagePath;    // ex: profile_image/user123.jpg
  final String? filePath;       // ex: /data/user/0/.../cache/avatar.jpg
  final AvatarSource? source;
  final BoxDecoration? decoration;

  static const Widget _placeHolder = Center(
    child: Padding(
      padding: EdgeInsets.all(12),
      child: FittedBox(fit: BoxFit.contain, child: Icon(Icons.person, color: ColorPalette.grey,)),
    ),
  );

  // Show placeholder until first decoded frame arrives
  Widget _frameBuilder(BuildContext _, Widget child, int? frame, bool wasSync) =>
      frame == null ? _placeHolder : child;

  // Show placeholder while bytes are loading (network only)
  Widget _loadingBuilder(BuildContext _, Widget child, ImageChunkEvent? prog) =>
      prog == null ? child : _placeHolder;

  // Fallback UI on errors
  Widget _errorBuilder(BuildContext _, Object __, StackTrace? ___) =>
      const Padding(
        padding: EdgeInsets.all(8),
        child: FittedBox(fit: BoxFit.contain, child: Icon(Icons.person_outline)),
      );

  // ---- Helpers --------------------------------------------------------------

// Preflight: for Firebase URLs use Storage metadata; otherwise HEAD request.
  Future<bool> _urlSeemsReachable(String url) async {
    try {
      final clean = url.trim().replaceAll('\n', '');
      if (clean.isEmpty) return false;

      if (clean.contains('firebasestorage.googleapis.com')) {
        await FirebaseStorage.instance.refFromURL(clean).getMetadata();
        return true;
      }

      final res = await http.head(Uri.parse(clean));
      return res.statusCode >= 200 && res.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  Widget _buildNetworkChecked(String url) {
    final clean = url.trim().replaceAll('\n', '');
    if (!clean.startsWith('http')) return _placeHolder;

    return FutureBuilder<bool>(
      future: _urlSeemsReachable(clean),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done || snap.data != true) {
          return _placeHolder;
        }
        // Only build Image.network when we know it should succeed — this prevents noisy 404 logs.
        return Image.network(
          clean,
          fit: BoxFit.cover,
          loadingBuilder: _loadingBuilder, // OK for network
          frameBuilder: _frameBuilder,
          errorBuilder: _errorBuilder,
        );
      },
    );
  }

  Widget _buildFromStoragePath(String path) {
    final p = path.trim();
    if (p.isEmpty) return _placeHolder;

    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref(p).getDownloadURL(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done || !(snap.hasData)) {
          return _placeHolder;
        }
        return _buildNetworkChecked(snap.data!);
      },
    );
  }

  Widget _buildFromFile(String path) {
    if (path.trim().isEmpty) return _placeHolder;
    final file = File(path);
    if (!file.existsSync()) return _placeHolder;

    return Image.file(
      file,
      fit: BoxFit.cover,
      frameBuilder: _frameBuilder,
      errorBuilder: _errorBuilder,
      // NOTE: Image.file in your SDK likely doesn't support loadingBuilder
    );
  }

  Widget _buildFromSvgString(String svg) {
    try {
      return SvgPicture.string(svg, fit: BoxFit.cover, placeholderBuilder: (_) => _placeHolder);
    } catch (_) {
      return _placeHolder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if ((storagePath ?? '').trim().isNotEmpty) {
      content = _buildFromStoragePath(storagePath!);
    } else {
      switch (source) {
        case AvatarSource.url:
          content = _buildNetworkChecked(imageUrl ?? '');
          break;
        case AvatarSource.file:
          content = _buildFromFile(filePath ?? '');
          break;
        case AvatarSource.bitmojiUrl:
          content = _buildFromSvgString(imageUrl ?? '');
          break;
        default:
          final val = (imageUrl ?? '').trim();
          content = val.startsWith('http') ? _buildNetworkChecked(val) : _placeHolder;
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



class MyAvatarWidget extends StatelessWidget {
  const MyAvatarWidget({
    super.key,
    required this.size,
    this.decoration,
  });

  final double size;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;

    return Obx(() {
      final value = profileController.profilePic.value.trim();

      // Heuristic: if it starts with http(s), treat as full URL; else assume storage path.
      final isUrl = value.startsWith('http://') || value.startsWith('https://');

      return UserAvatar(
        size: size,
        decoration: decoration,
        imageUrl: isUrl ? value : null,
        storagePath: isUrl ? null : value, // preferred path usage
        source: isUrl ? AvatarSource.url : null,
      );
    });
  }
}