import 'package:flutter/material.dart';

class BrokenVerticalLine extends StatelessWidget {
  const BrokenVerticalLine({super.key, this.width, this.height});

  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        final double t = index / 6;
        return Container(
          width: width ?? 2,
          height: height ?? 2,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: gradientColor(t),
          ),
        );
      }),
    );
  }

  Color gradientColor(double t) {
    // Interpolate between green and black based on parameter t
    const int startRed = 0x00;  // Green has no red component
    const int startGreen = 0xFF;  // Full green
    const int startBlue = 0x00;  // Green has no blue component

    const int endRed = 0x00;  // Black has no red component
    const int endGreen = 0x00;  // Black has no green component
    const int endBlue = 0x00;  // Black has no blue component

    final int red = ((endRed - startRed) * t + startRed).toInt();
    final int green = ((endGreen - startGreen) * t + startGreen).toInt();
    final int blue = ((endBlue - startBlue) * t + startBlue).toInt();

    return Color.fromARGB(255, red, green, blue);
  }

}
