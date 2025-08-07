import 'package:flutter/material.dart';

class WaveCurvedBackground extends StatelessWidget {
  final double height;
  final Color color;

  const WaveCurvedBackground({
    super.key,
    required this.height,
    this.color = const Color(0xFF8F67E8),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _CombinedPainter(color)),
    );
  }
}

class _CombinedPainter extends CustomPainter {
  final Color color;

  _CombinedPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path =
        Path()
          ..lineTo(0, size.height * 0.2)
          ..quadraticBezierTo(
            0,
            size.height * 0.35,
            size.width * 0.2,
            size.height * 0.35,
          )
          ..lineTo(size.width * 0.8, size.height * 0.35)
          ..quadraticBezierTo(
            size.width,
            size.height * 0.35,
            size.width,
            size.height * 0.5,
          )
          ..lineTo(size.width, 0)
          ..close();

    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw blue background
    canvas.drawPath(path, paint);

    // Clip the canvas to curved shape before drawing wave lines
    canvas.save();
    canvas.clipPath(path);

    final wavePaint =
        Paint()
          ..color = const Color(0xFF4A4B8F).withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Wave 1
    final path1 =
        Path()
          ..moveTo(0, size.height * 0.15)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * 0.20,
            size.width * 0.5,
            size.height * 0.15,
          )
          ..quadraticBezierTo(
            size.width * 0.75,
            size.height * 0.10,
            size.width,
            size.height * 0.15,
          );
    canvas.drawPath(path1, wavePaint);

    // Wave 2
    final path2 =
        Path()
          ..moveTo(0, size.height * 0.30)
          ..quadraticBezierTo(
            size.width * 0.2,
            size.height * 0.25,
            size.width * 0.4,
            size.height * 0.30,
          )
          ..quadraticBezierTo(
            size.width * 0.6,
            size.height * 0.35,
            size.width * 0.8,
            size.height * 0.30,
          )
          ..quadraticBezierTo(
            size.width * 0.95,
            size.height * 0.25,
            size.width,
            size.height * 0.30,
          );
    canvas.drawPath(path2, wavePaint);

    canvas.restore(); // Restore the canvas after clipping
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
