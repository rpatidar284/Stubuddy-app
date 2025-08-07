import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/sprimary_header_container.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/controllers/schedule_controller.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/constants.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/widgets/add_event_modal.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/widgets/schedule_entry_card.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatelessWidget {
  final ScheduleController _controller = Get.put(ScheduleController());

  SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SprimaryHeaderContainer(height: 180),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Calendar',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.apply(color: SColors.white),
                    ),
                  ],
                ),
                Icon(Iconsax.calendar, color: Colors.white),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100),
              _buildCalendar(),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Obx(() {
                        if (_controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        if (_controller.eventsForDate.isEmpty) {
                          return const Center(
                            child: Text(
                              "No events scheduled for this day.",
                              style: TextStyle(color: AppColors.secondaryText),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _controller.eventsForDate.length,
                          itemBuilder: (context, index) {
                            final event = _controller.eventsForDate[index];
                            return Dismissible(
                              key: Key(event.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                _controller.deleteEvent(event.id!);
                              },
                              child: ScheduleEventCard(eventModel: event),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEventModal());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: SColors.primary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(
        () => TableCalendar(
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            leftChevronIcon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
              size: 15,
            ),
            rightChevronIcon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 15,
            ),
          ),
          calendarStyle: CalendarStyle(
            weekendTextStyle: TextStyle(color: Colors.grey[600]),
            todayDecoration: BoxDecoration(
              color: AppColors.dateSelected.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.dateSelected,
              shape: BoxShape.circle,
            ),
          ),
          selectedDayPredicate:
              (day) => isSameDay(_controller.selectedDay.value, day),
          focusedDay: _controller.focusedDay.value,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDay, focusedDay) {
            _controller.onDaySelected(selectedDay, focusedDay);
          },
          onPageChanged: (focusedDay) {
            _controller.onPageChanged(focusedDay);
          },
          // NEW: Event indicator
          eventLoader: _controller.getEventsForDay,
        ),
      ),
    );
  }
}
