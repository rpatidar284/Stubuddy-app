import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class ScircularContainer extends StatelessWidget {
  const ScircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.backgroundColor = SColors.white,
  });
  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: SColors.textWhite.withOpacity(0.1),
      ),
      child: child,
    );
  }
}
