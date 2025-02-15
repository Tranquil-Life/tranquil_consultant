import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/global/pulsing_widget.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';


 enum AvatarSource { file, url, bitmojiUrl }

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.imageUrl,
    this.size = 48,
    this.source,
    this.decoration,
  }) : super(key: key);

  final double? size;
  final String? imageUrl;
  final AvatarSource? source;
  final BoxDecoration? decoration;

  static const Widget _placeHolder = PulsingWidget(
    child: Padding(
      padding: EdgeInsets.all(12),
      child: FittedBox(fit: BoxFit.contain, child: Icon(Icons.image_search)),
    ),
  );

  Widget errorBuilder(_, __, ___) => Padding(
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Icon(TranquilIcons.profile, color: Colors.grey[600]),
        ),
      );

  Widget frameBuilder(_, img, val, ___) {
    return val == null ? _placeHolder : img;
  }

  @override
  Widget build(BuildContext context) {
    String value = imageUrl ?? '';
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: decoration ??
          const BoxDecoration(
            shape: BoxShape.circle,
          ),
      child: Builder(builder: (context) {
        switch (source) {
          case AvatarSource.url:
            return Image.network(
              value,
              fit: BoxFit.cover,
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
            );
          case AvatarSource.file:
            return Image.file(
              File(value),
              fit: BoxFit.cover,
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
            );
          case AvatarSource.bitmojiUrl:
            return SvgPicture.string(
              fluttermojiFunctions.decodeFluttermojifromString(value),
              fit: BoxFit.cover,
              placeholderBuilder: (_) => _placeHolder,
            );
          default:
            return _placeHolder;
        }
      }),
    );
  }
}

class MyAvatarWidget extends StatefulWidget {
  const MyAvatarWidget({super.key, required this.size, this.decoration});

  final double size;
  final BoxDecoration? decoration;

  @override
  State<MyAvatarWidget> createState() => _MyAvatarWidgetState();
}

class _MyAvatarWidgetState extends State<MyAvatarWidget> {
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>UserAvatar(
      size: widget.size,
      decoration: widget.decoration,
      imageUrl: profileController.profilePic.value,
      source: AvatarSource.url,
    ));
  }
}
