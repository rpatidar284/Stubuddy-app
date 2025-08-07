// File: lib/utils/navigation_menu.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/pages/my_grades_screen.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/chat/pages/split_bill_home.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/chat/widgets/analyticsTotal.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/schedule_page.dart';
import 'package:stu_buddy/features/authentication/screens/home/home_screen.dart';
import 'package:stu_buddy/features/authentication/screens/profile/profile_screen.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/helpers/helperFunction.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = SHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected:
              (index) => controller.selectedIndex.value = index,
          backgroundColor: dark ? SColors.black : SColors.white,
          indicatorColor:
              dark
                  ? SColors.white.withOpacity(0.1)
                  : SColors.black.withOpacity(0.2),
          destinations: [
            const NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.money_send),
              label: 'Split Bill',
            ),
            const NavigationDestination(
              icon: Icon(Iconsax.calendar),
              label: 'Calendar',
            ),
            const NavigationDestination(
              icon: Icon(CupertinoIcons.chart_bar),
              label: 'MyGrades',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_2_outlined),
              label: 'Account',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  // IMPORTANT: Ensure the order of screens matches the order of NavigationDestinations
  final screens = [
    const HomeScreen(),
    const SplitBillHome(), // The new landing page for Split Bill
    SchedulePage(),
    const MyGradesScreen(),
    const ProfileScreen(),
  ];
}
