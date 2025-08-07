import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageInxex = 0.obs;

  void updatePageIndicator(index) => currentPageInxex.value = index;

  void dotNavigationClick(index) {
    currentPageInxex.value = index;
    pageController.jumpTo(index);
  }

  void nextPage() {
    if (currentPageInxex.value == 2) {
      Get.offAll(const loginScreen());
    } else {
      int page = currentPageInxex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skidPage() {
    currentPageInxex.value = 2;
    pageController.jumpToPage(2);
  }
}
