import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class customcard extends StatelessWidget {
  const customcard({
    super.key,
    this.elevation = 4,
    this.borderRadius = SSizes.lg,
    this.color = Colors.white,
    this.height = 100,
    this.width = double.infinity,
    required this.child,
  });

  final double elevation;
  final double borderRadius;
  final Color color;
  final double height;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: color,
      child: SizedBox(height: height, width: width, child: child),
    );
  }
}
