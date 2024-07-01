import 'package:flutter/material.dart';
import 'custom_theme.dart';

class BackgroundPainter extends CustomPainter {
  final ThemeMode themeMode;

  BackgroundPainter({required this.themeMode});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [themeMode == ThemeMode.dark ? Colors.black : Colors.white, Color.fromARGB(255, 145, 45, 162)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}