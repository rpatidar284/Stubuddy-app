import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/features/authentication/controllers/login_controller.dart';
import 'package:stu_buddy/features/authentication/screens/passwordConfiguration/forgetPassword.dart';
import 'package:stu_buddy/features/authentication/screens/signup/signup.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';

class loginForm extends StatelessWidget {
  const loginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final controller1 = Get.put(PasswordController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: controller.email,
              validator:
                  (value) => value!.isEmpty ? 'Email cannot be empty' : null,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: Stext.email,
              ),
            ),
            SizedBox(height: SSizes.spaceBtwInputFields),
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Password cannot be empty' : null,
                obscureText: controller1.obscureText.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: Stext.password,
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
            SizedBox(height: SSizes.spaceBtwInputFields / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(Stext.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => const Forgetpassword()),
                  child: const Text(Stext.forgotPassword),
                ),
              ],
            ),
            SizedBox(height: SSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SColors.buttonPrimary,

                  side: const BorderSide(color: SColors.buttonPrimary),
                ),

                onPressed: () => controller.login(),
                child: Text(Stext.signIn),
              ),
            ),
            const SizedBox(height: SSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: SColors.buttonPrimary),
                ),
                onPressed: () => Get.to(() => const SignupScreen()),
                child: Text(Stext.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordController extends GetxController {
  var obscureText = true.obs;
  final password = TextEditingController();
}
