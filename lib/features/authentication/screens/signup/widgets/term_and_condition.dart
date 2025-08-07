import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/controllers/signupController.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class termAndCondition extends StatelessWidget {
  const termAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final bool dark = SHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value = value!,
            ),
          ),
        ),
        const SizedBox(width: SSizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${Stext.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${Stext.privacyPolicy}',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark ? SColors.white : SColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark ? SColors.white : SColors.primary,
                ),
              ),
              TextSpan(
                text: ' and ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${Stext.termsOfUse}',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark ? SColors.white : SColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark ? SColors.white : SColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
