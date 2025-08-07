import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/common/widgets/loader/animationLoader.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';
import '../constants/colors.dart';

/// A utility class for managing a full-screen loading dialog.
class TFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context:
          Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible:
          false, // The dialog can't be dismissed by tapping outside it
      builder:
          (_) => PopScope(
            canPop: false, // Disable popping with the back button
            child: Container(
              color:
                  SHelperFunctions.isDarkMode(Get.context!)
                      ? SColors.dark
                      : SColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 250), // Adjust the spacing as needed
                  SAnimationLoaderWidget(text: text, animation: animation),
                ],
              ),
            ),
          ),
    );
  }
}
