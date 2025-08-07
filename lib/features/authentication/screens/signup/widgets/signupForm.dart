import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/features/authentication/controllers/signupController.dart';
import 'package:stu_buddy/features/authentication/screens/signup/widgets/term_and_condition.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';
import 'package:stu_buddy/utils/validators/validation.dart';

class signupForm extends StatelessWidget {
  const signupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final controller1 = Get.put(PasswordCon());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstname,
                  validator:
                      (value) =>
                          SValidator.validateEmtyText('First Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: Stext.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),

              const SizedBox(width: SSizes.spaceBtwInputFields),

              Expanded(
                child: TextFormField(
                  controller: controller.lastname,
                  validator:
                      (value) =>
                          SValidator.validateEmtyText('Last Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: Stext.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: SSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.username,
            validator:
                (value) => SValidator.validateEmtyText('User Name', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: Stext.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),

          const SizedBox(height: SSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.email,
            validator: (value) => SValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: Stext.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),

          const SizedBox(height: SSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.phoneNum,
            validator: (value) => SValidator.validatePhoneNumber(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: Stext.phoneNumber,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),

          const SizedBox(height: SSizes.spaceBtwInputFields),

          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => SValidator.validatePassword(value),
              obscureText: controller1.obscureText.value,
              decoration: InputDecoration(
                labelText: Stext.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller1.obscureText.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                  onPressed: () {
                    controller1.obscureText.toggle();
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: SSizes.spaceBtwSections),

          /// T and Con
          const termAndCondition(),

          const SizedBox(height: SSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: Text(Stext.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordCon extends GetxController {
  var obscureText = true.obs;
  final password = TextEditingController();
}
