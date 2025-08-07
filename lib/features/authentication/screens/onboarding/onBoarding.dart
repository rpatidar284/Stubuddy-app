import 'package:flutter/material.dart';
import 'package:stu_buddy/features/authentication/controllers/onBoardingCon.dart';
import 'package:stu_buddy/features/authentication/screens/onboarding/widgets/onBoNextButton.dart';
import 'package:stu_buddy/features/authentication/screens/onboarding/widgets/on_bo_dot_navigation.dart';
import 'package:stu_buddy/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:stu_buddy/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';

import 'package:stu_buddy/utils/constants/imageString.dart';

import 'package:stu_buddy/utils/constants/textString.dart';

import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnboardingPage(
                image: SImages.onBo1,
                title: Stext.onBoardingTitlte1,
                subtitle: Stext.onBoardingSubTitlte1,
              ),
              OnboardingPage(
                image: SImages.onBo2,
                title: Stext.onBoardingTitlte2,
                subtitle: Stext.onBoardingSubTitlte2,
              ),
              OnboardingPage(
                image: SImages.onBo3,
                title: Stext.onBoardingTitlte3,
                subtitle: Stext.onBoardingSubTitlte3,
              ),
            ],
          ),
          OnboardingSkip(),

          OnBoDotNavigation(),
          CircularButton(),
        ],
      ),
    );
  }
}
