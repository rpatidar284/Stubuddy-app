import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/customcard.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/sprimary_header_container.dart';
import 'package:stu_buddy/features/authentication/controllers/profile_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/Attendance_screen.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/findLowatten.dart';
import 'package:stu_buddy/features/authentication/screens/home/Widget/featurecard.dart';
import 'package:stu_buddy/features/authentication/screens/home/Widget/splitBill.dart';
import 'package:stu_buddy/features/authentication/screens/home/Widget/upcoming/UpcomingClass.dart';
import 'package:stu_buddy/features/authentication/screens/timeTable/timetable_screen.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/to_do_list_screen.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/imageString.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    // Add safety null-check
    final user = controller.user.value;
    final profilePicture =
        user?.profilePicture.isNotEmpty == true
            ? MemoryImage(base64Decode(user!.profilePicture))
            : null;

    return Scaffold(
      body: Stack(
        children: [
          SprimaryHeaderContainer(height: 290),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Logo and Profile Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(
                              height: 50,
                              image: AssetImage(SImages.darkAppLogo),
                            ),
                            SizedBox(width: SSizes.sm),
                            Text(
                              'StuBuddy',
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .apply(color: SColors.white),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: profilePicture,
                              child:
                                  profilePicture == null
                                      ? Icon(
                                        Iconsax.user,
                                        size: 60,
                                        color: Colors.black,
                                      )
                                      : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: controller.selectAndSaveImage,
                                child: CircleAvatar(
                                  radius: 15,
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
                      ],
                    ),
                    SizedBox(height: SSizes.spaceBtwItems),

                    /// Greeting
                    Padding(
                      padding: const EdgeInsets.only(left: SSizes.sm),
                      child: Text(
                        user != null ? 'Hi ${user.firstName}' : 'Hi Student',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge!.apply(color: SColors.white),
                      ),
                    ),
                    SizedBox(height: SSizes.spaceBtwSections),

                    /// Feature Cards
                    customcard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FeatureCard(
                              title: 'TimeTable',
                              iconPath: 'assets/images/FreCard/TT.jpeg',
                              onTap: () => Get.to(() => TimetableScreen()),
                            ),
                            FeatureCard(
                              title: 'ToDoList',
                              iconPath: 'assets/images/FreCard/todo.jpeg',
                              onTap: () => Get.to(() => ToDoListScreen()),
                            ),
                            FeatureCard(
                              title: 'Attendance',
                              iconPath: 'assets/images/FreCard/atten.jpg',
                              onTap:
                                  () => Get.to(() => AttendanceTrackingView()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Scrollable Body Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: SSizes.sm),
                      const UpcomingClass(),
                      const SizedBox(height: SSizes.sm),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: const [
                              SplitbillTracker(),
                              SizedBox(width: SSizes.sm),
                              SingleLowestAttendanceSubjectCard(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
