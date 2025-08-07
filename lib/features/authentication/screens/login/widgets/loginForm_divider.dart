import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class formDivider extends StatelessWidget {
  const formDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final bool dark = SHelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? SColors.darkGrey : SColors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          dividerText.capitalize!,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
          child: Divider(
            color: dark ? SColors.darkGrey : SColors.grey,
            thickness: 0.5,
            indent: 6,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}
