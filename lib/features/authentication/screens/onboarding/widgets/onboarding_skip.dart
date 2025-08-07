import 'package:flutter/material.dart';
import 'package:stu_buddy/features/authentication/controllers/onBoardingCon.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/device/deviceUtility.dart';

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: SDeviceUtils.getAppBarHeight(),
      right: SSizes.defaultSpace,

      child: TextButton(
        onPressed: () => OnBoardingController.instance.skidPage(),
        child: const Text('Skip'),
      ),
    );
  }
}
