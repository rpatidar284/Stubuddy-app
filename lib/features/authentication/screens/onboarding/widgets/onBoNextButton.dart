import 'package:flutter/material.dart';
import 'package:stu_buddy/features/authentication/controllers/onBoardingCon.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/device/deviceUtility.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Positioned(
      right: SSizes.defaultSpace,
      bottom: SDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor:
              dark ? SColors.primary : const Color.fromARGB(216, 0, 0, 0),
        ),
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
