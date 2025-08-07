import 'package:flutter/material.dart';
import 'package:stu_buddy/common/widgets/custom_shape/curved_shap/curved_edge.dart';

class ScurvedEdgeWidget extends StatelessWidget {
  const ScurvedEdgeWidget({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: SCustomCurvedEdges(), child: child);
  }
}
