import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/controllers/TT/timetable_controller.dart';
import 'package:stu_buddy/features/authentication/screens/sccreeTest/homePage.dart';
import 'package:stu_buddy/features/authentication/screens/timeTable/add_class_screen.dart';
import 'package:stu_buddy/features/authentication/screens/timeTable/class_card.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TimetableController controller = Get.put(TimetableController());
    return Scaffold(
      body: Stack(
        children: [
          BackgroundPage(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        Text(
                          'Timetable',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .apply(color: SColors.white),
                        ),
                      ],
                    ),
                    Icon(Iconsax.timer_1, color: Colors.white),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Schedule • ${DateFormat('EEE, MMMM dd').format(DateTime.now())}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SSizes.lg),
              _buildDayTabs(context, controller),
              Expanded(
                child: Obx(
                  () =>
                      controller.classes.isEmpty
                          ? Center(
                            child: Text(
                              'No classes scheduled for this day.',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: controller.classes.length,
                            itemBuilder: (context, index) {
                              final classData = controller.classes[index];
                              return Dismissible(
                                key: Key(classData['id'].toString()),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed:
                                    (_) =>
                                        controller.deleteClass(classData['id']),
                                child: ClassCard(
                                  time: classData['time'],
                                  subject: classData['subject'],
                                  room: classData['room'],
                                  instructor: classData['instructor'],
                                ),
                              );
                            },
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddClassScreen());
        },
        backgroundColor: SColors.buttonPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDayTabs(BuildContext context, TimetableController controller) {
    final List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SSizes.sm),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: SColors.primary.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              days.map((day) {
                return Expanded(
                  child: Obx(() {
                    final isSelected = day == controller.selectedDay.value;
                    return InkWell(
                      onTap: () => controller.setSelectedDay(day),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? SColors.buttonPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(SSizes.lg),
                        ),
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }).toList(),
        ),
      ),
    );
  }
}
