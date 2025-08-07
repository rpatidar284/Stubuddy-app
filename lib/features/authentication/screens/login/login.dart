import 'package:flutter/material.dart';

import 'package:stu_buddy/common/styles/spacing_styles.dart';
import 'package:stu_buddy/features/authentication/screens/login/widgets/loginForm_divider.dart';
import 'package:stu_buddy/features/authentication/screens/login/widgets/login_form.dart';
import 'package:stu_buddy/features/authentication/screens/login/widgets/login_header.dart';
import 'package:stu_buddy/features/authentication/screens/login/widgets/social_button.dart';

import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/constants/textString.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SSpacingStyles.paddingWithAppBar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // logo title subtitle
              loginHeader(),

              const loginForm(),

              formDivider(dividerText: Stext.orSignInWith),

              const SizedBox(height: SSizes.spaceBtwItems),

              const socialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
