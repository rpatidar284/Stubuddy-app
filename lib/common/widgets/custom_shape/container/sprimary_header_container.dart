import 'package:flutter/material.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/scircular_container.dart';
import 'package:stu_buddy/common/widgets/custom_shape/curved_shap/scurved_edge_widget.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class SprimaryHeaderContainer extends StatelessWidget {
  const SprimaryHeaderContainer({super.key, this.height = 300});
  final double height;

  @override
  Widget build(BuildContext context) {
    return ScurvedEdgeWidget(
      child: Container(
        color: SColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: -200,
                right: -250,
                child: ScircularContainer(
                  backgroundColor: SColors.textWhite.withOpacity(0.1),
                ),
              ),
              Positioned(
                top: 50,
                right: -300,
                child: ScircularContainer(
                  backgroundColor: SColors.textWhite.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
