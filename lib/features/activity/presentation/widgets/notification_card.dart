import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/features/activity/domain/entities/notification_type.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.type, required this.body, required this.time});

  final String type;
  final String body;
  final DateTime time;

  static Widget _iconFromType(NotificationType type) {
    switch (type) {
      case NotificationType.meeting:
        return const Padding(
          padding: EdgeInsets.all(1),
          child: Icon(Icons.calendar_month, color: Colors.white, size: 27),
        );
      case NotificationType.people:
        return const Icon(TranquilIcons.profile, color: Colors.white, size: 29);
      case NotificationType.message:
        return const Padding(
          padding: EdgeInsets.all(2.5),
          child: Icon(TranquilIcons.message, color: Colors.white),
        );
      case NotificationType.payment:
        return const Padding(
          padding: EdgeInsets.all(2.5),
          child: Icon(TranquilIcons.card, color: Colors.white),
        );
      default:
        return const Icon(TranquilIcons.bell, size: 28, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MyDefaultTextStyle(
                  style: TextStyle(fontSize: 12.5, height: 1.4, fontFamily: AppFonts.josefinSansRegular),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(timeago.format(time), style: TextStyle(fontSize: 10),),
                      SizedBox(height: 8),
                      Text(
                        body
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
        ),
        Positioned(
          right: 24,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ColorPalette.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _iconFromType(NotificationType.fromValue(type)),
          ),
        ),
      ],
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon({required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: ColorPalette.blue,
            child: const Icon(
              TranquilIcons.trash,
              size: 26,
              color: Colors.white,
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkResponse(
                containedInkWell: true,
                highlightShape: BoxShape.rectangle,
                onTap: onPressed,
              ),
            ),
          )
        ],
      ),
    );
  }
}
