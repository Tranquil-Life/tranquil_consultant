import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle});

  final IconData icon;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.grey[200]!, // Background color of the container
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!, // Lighter color for outer shadow
              offset: const Offset(4.0, 4.0),
              blurRadius: 8.0,
            ),
            BoxShadow(
              color: Colors.grey[100]!, // Darker color for inner shadow
              offset: const Offset(-4.0, -4.0),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.green,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),

            const SizedBox(width: 16),

            Column(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: ColorPalette.green[800],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 270,
                  child: Text(
                    subTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,

                      color: ColorPalette.green[800],
                    ),
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
}