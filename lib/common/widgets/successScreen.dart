import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:stu_buddy/common/styles/spacing_styles.dart';
import 'package:stu_buddy/features/authentication/screens/login/login.dart';
import 'package:stu_buddy/utils/constants/imageString.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class Successscreen extends StatelessWidget {
  const Successscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SSpacingStyles.paddingWithAppBar * 2,
          child: Column(
            children: [
              Image(
                image: AssetImage(SImages.creAccS),
                width: SHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              Text(
                Stext.yourAccountCreatedTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              Text(
                Stext.yourAccountCreatedSubTitle,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const loginScreen()),
                  child: const Text(Stext.Continuet),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
