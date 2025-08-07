import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class CircularProgressCard extends StatelessWidget {
  final int percentage;
  final double height;
  final double width;
  final double strokeWidth;
  final Color color;

  const CircularProgressCard({
    super.key,
    required this.percentage,
    this.height = 80,
    this.width = 80,
    this.strokeWidth = 5,
    this.color = SColors.buttonPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = (percentage.clamp(0, 100).toDouble()) / 100;
    final double fontSize = height * 0.25; // dynamic text scaling

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: progressValue),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, _) {
              return SizedBox(
                height: height,
                width: width,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.grey[300],
                  color: color,
                ),
              );
            },
          ),
          Text(
            "$percentage%",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
