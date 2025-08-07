import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/features/authentication/controllers/profile_controller.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final bool dark = SHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSizes.defaultSpace),
          child: Obx(() {
            if (controller.isLoading.value || controller.user.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = controller.user.value!;
            final profilePicture =
                user.profilePicture.isNotEmpty
                    ? MemoryImage(base64Decode(user.profilePicture))
                    : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor:
                          dark ? Colors.grey[700] : Colors.grey[200],
                      backgroundImage: profilePicture,
                      child:
                          profilePicture == null
                              ? Icon(
                                Iconsax.user,
                                size: 60,
                                color: dark ? Colors.white : Colors.black,
                              )
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: controller.selectAndSaveImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: SColors.buttonPrimary,
                          child: const Icon(
                            Iconsax.camera,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SSizes.spaceBtwItems),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: SSizes.xs),
                Text(
                  user.username,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: SSizes.lg),

                // User Details Section
                const Divider(),
                const SizedBox(height: SSizes.spaceBtwItems),

                ListTile(
                  leading: const Icon(Iconsax.user, size: 28),
                  title: Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  subtitle: Text(
                    '${user.firstName} ${user.lastName}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.edit),
                    onPressed: () {
                      final firstNameController = TextEditingController(
                        text: user.firstName,
                      );
                      final lastNameController = TextEditingController(
                        text: user.lastName,
                      );
                      Get.defaultDialog(
                        title: 'Edit Name',
                        content: Column(
                          children: [
                            TextField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                              ),
                            ),
                            const SizedBox(height: SSizes.spaceBtwItems),
                            TextField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                              ),
                            ),
                            const SizedBox(height: SSizes.spaceBtwItems),
                            GFButton(
                              onPressed: () {
                                controller.updateName(
                                  firstNameController.text,
                                  lastNameController.text,
                                );
                                Get.back();
                              },
                              text: 'Save',
                              shape: GFButtonShape.pills,

                              size: GFSize.LARGE,
                              color: SColors.buttonPrimary,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                ListTile(
                  leading: const Icon(Iconsax.direct, size: 28),
                  title: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  subtitle: Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
