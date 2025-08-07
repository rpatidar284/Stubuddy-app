import 'package:flutter/material.dart';
import 'package:stu_buddy/utils/constants/imageString.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class loginHeader extends StatelessWidget {
  const loginHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final bool dark = SHelperFunctions.isDarkMode(context);
    print(dark);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(dark ? SImages.darkAppLogo : SImages.lightAppLogo),
        ),
        Text(
          Stext.logoTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SSizes.sm),
        Text(Stext.logoSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
