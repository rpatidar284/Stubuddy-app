import 'package:flutter/material.dart';

import 'package:stu_buddy/features/authentication/screens/login/widgets/loginForm_divider.dart';
import 'package:stu_buddy/features/authentication/screens/login/widgets/social_button.dart';
import 'package:stu_buddy/features/authentication/screens/signup/widgets/signupForm.dart';

import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                Stext.signUpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: SSizes.spaceBtwSections),

              // Form
              const signupForm(),
              const SizedBox(height: SSizes.spaceBtwSections),

              formDivider(dividerText: Stext.orSignUpWith),
              const SizedBox(height: SSizes.spaceBtwSections),

              const socialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
