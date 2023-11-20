import 'package:flutter/material.dart';

class ReactionPath extends CustomPainter {
  bool isSender = false;

  ReactionPath({required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1616771, size.height * 0.06666667);
    path_0.cubicTo(size.width * 0.1616771, size.height * 0.02984762,
        size.width * 0.2640114, 0, size.width * 0.3902486, 0);
    path_0.lineTo(size.width * 0.7714286, 0);
    path_0.cubicTo(size.width * 0.8976657, 0, size.width,
        size.height * 0.02984767, size.width, size.height * 0.06666667);
    path_0.lineTo(size.width, size.height * 0.9333333);
    path_0.cubicTo(size.width, size.height * 0.9701542, size.width * 0.8976657,
        size.height, size.width * 0.7714286, size.height);
    path_0.lineTo(size.width * 0.3902486, size.height);
    path_0.cubicTo(
        size.width * 0.2640114,
        size.height,
        size.width * 0.1616771,
        size.height * 0.9701542,
        size.width * 0.1616771,
        size.height * 0.9333333);
    path_0.lineTo(size.width * 0.1616771, size.height * 0.8685375);
    path_0.cubicTo(
        size.width * 0.1616771,
        size.height * 0.8500250,
        size.width * 0.1238946,
        size.height * 0.8332875,
        size.width * 0.06558814,
        size.height * 0.8259750);
    path_0.lineTo(size.width * 0.02709171, size.height * 0.8211458);
    path_0.cubicTo(
        size.width * 0.01733343,
        size.height * 0.8199208,
        size.width * 0.009384629,
        size.height * 0.8177250,
        size.width * 0.004664486,
        size.height * 0.8149500);
    path_0.lineTo(size.width * 0.004446086, size.height * 0.8148208);
    path_0.cubicTo(size.width * 0.001521657, size.height * 0.8131000, 0,
        size.height * 0.8112083, 0, size.height * 0.8092875);
    path_0.lineTo(0, size.height * 0.8079042);
    path_0.cubicTo(
        0,
        size.height * 0.8061250,
        size.width * 0.001966800,
        size.height * 0.8043917,
        size.width * 0.005608600,
        size.height * 0.8029667);
    path_0.cubicTo(
        size.width * 0.009713271,
        size.height * 0.8013583,
        size.width * 0.01568200,
        size.height * 0.8002375,
        size.width * 0.02240486,
        size.height * 0.7998167);
    path_0.lineTo(size.width * 0.05952471, size.height * 0.7974875);
    path_0.cubicTo(
        size.width * 0.1191184,
        size.height * 0.7937500,
        size.width * 0.1616771,
        size.height * 0.7783833,
        size.width * 0.1616771,
        size.height * 0.7606042);
    path_0.lineTo(size.width * 0.1616771, size.height * 0.06666667);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffE0F3E5).withOpacity(1.0);

    if (isSender) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}