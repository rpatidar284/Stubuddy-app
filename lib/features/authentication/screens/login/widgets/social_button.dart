import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/imageString.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class socialButton extends StatelessWidget {
  const socialButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = SHelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: dark ? SColors.textPrimary : SColors.grey,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: SSizes.iconMd,
              height: SSizes.iconMd,
              image: AssetImage(SImages.google),
            ),
          ),
        ),
      ],
    );
  }
}
