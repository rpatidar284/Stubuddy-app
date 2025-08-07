import 'package:flutter/material.dart';
import 'dart:math';

class Subjectcircular extends StatelessWidget {
  final int percentCurrent;

  const Subjectcircular({
    Key? key,
    required this.percentCurrent,
    this.h = 80,
    this.w = 80,
  }) : super(key: key);
  final double h;
  final double w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: h,
      height: w,
      child: CustomPaint(
        painter: _CirclePainter(percentCurrent),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentCurrent.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'CURRENT',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter for the circular progress indicator
class _CirclePainter extends CustomPainter {
  final int percent; // 0–100
  _CirclePainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // background circle
    final bgPaint =
        Paint()
          ..color = Colors.white12
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // progress arc
    final fgPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.redAccent, Colors.greenAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;
    final sweepAngle = 2 * pi * (percent.clamp(0, 100) / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // start at top
      sweepAngle, // how much to sweep
      false, // stroke only
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter old) => old.percent != percent;
}
