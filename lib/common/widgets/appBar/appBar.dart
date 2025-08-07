import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/device/deviceUtility.dart';

class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackArrow = false,
    this.showProfileAvatar = false,
    this.profileImagePath,
    this.leadingOnPressed,
  });

  final Widget? title;
  final List<Widget>? actions;
  final bool showBackArrow;
  final bool showProfileAvatar;
  final String? profileImagePath;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 50,
        leading:
            showBackArrow
                ? IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Iconsax.arrow_left),
                )
                : showProfileAvatar && profileImagePath != null
                ? GestureDetector(
                  onTap: leadingOnPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(profileImagePath!),
                  ),
                )
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(SDeviceUtils.getAppBarHeight());
}
