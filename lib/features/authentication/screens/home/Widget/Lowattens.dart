import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/customcard.dart';
import 'package:stu_buddy/common/widgets/custom_shape/curved_shap/subjectCircular.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class Attencard extends StatelessWidget {
  final String subjectName;
  final String subjectCode;
  final int attendancePercentage;

  const Attencard({
    super.key,
    required this.subjectName,
    required this.subjectCode,
    required this.attendancePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return customcard(
      height: 250,
      width: 200,
      elevation: 0,
      color: SColors.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(SSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/FreCard/lowatten.jpg',
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(width: SSizes.sm),
                Text(
                  'Low atten.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: SSizes.spaceBtwItems),
            Subjectcircular(percentCurrent: attendancePercentage, h: 83, w: 83),
            const SizedBox(height: SSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.book_1),
                SizedBox(width: SSizes.sm),
                Text(
                  subjectName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: SSizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline),
                SizedBox(width: SSizes.sm),
                Text(
                  subjectCode,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
