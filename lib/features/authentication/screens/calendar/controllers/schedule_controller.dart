import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/schedule_event_model.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/services/schedule_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleController extends GetxController {
  final ScheduleService _scheduleService = ScheduleService();

  var focusedDay = DateTime.now().obs;
  var selectedDay = Rxn<DateTime>(DateTime.now());
  var isLoading = false.obs;
  var eventsForDate = <ScheduleEventModel>[].obs;

  // NEW: Reactive variable to hold all events for the calendar view
  var allEvents = <ScheduleEventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllEvents();
    fetchEventsForSelectedDay();
    _startAutoDeleteTimer();
  }

  void fetchAllEvents() async {
    final List<ScheduleEventModel> events =
        await _scheduleService.getAllEvents();
    allEvents.assignAll(events);
  }

  void fetchEventsForSelectedDay() async {
    isLoading(true);
    if (selectedDay.value != null) {
      final List<ScheduleEventModel> events = await _scheduleService
          .getEventsForDate(selectedDay.value!);
      eventsForDate.assignAll(events);
    } else {
      eventsForDate.clear();
    }
    isLoading(false);
  }

  // New method to be used by eventLoader
  List<ScheduleEventModel> getEventsForDay(DateTime day) {
    return allEvents
        .where(
          (event) => isSameDay(DateFormat('yyyy-MM-dd').parse(event.date), day),
        )
        .toList();
  }

  void onDaySelected(DateTime day, DateTime focused) {
    if (selectedDay.value?.day != day.day ||
        selectedDay.value?.month != day.month) {
      selectedDay.value = day;
      focusedDay.value = focused;
      fetchEventsForSelectedDay();
    }
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
    fetchAllEvents(); // Refresh events when the month changes
  }

  void addEvent(ScheduleEventModel event) async {
    await _scheduleService.insertEvent(event);
    fetchAllEvents(); // Refresh all events after adding
    fetchEventsForSelectedDay();
    Get.back();
  }

  void deleteEvent(int id) async {
    await _scheduleService.deleteEvent(id);
    eventsForDate.removeWhere((e) => e.id == id);
    fetchAllEvents(); // Refresh all events after deleting
    Get.snackbar(
      "Event Deleted",
      "The event has been successfully deleted.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _startAutoDeleteTimer() {
    Future.delayed(const Duration(minutes: 1), () async {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final eventsForToday = await _scheduleService.getEventsForDate(now);

      for (var event in eventsForToday) {
        try {
          final endTimeString = event.endTime;
          final endTime = DateFormat(
            'yyyy-MM-dd h:mm a',
          ).parse('$formattedDate $endTimeString');

          if (now.isAfter(endTime)) {
            await _scheduleService.deleteEvent(event.id!);
          }
        } catch (e) {
          print("Error parsing time for auto-delete: $e");
        }
      }

      _startAutoDeleteTimer();
      if (DateFormat('yyyy-MM-dd').format(selectedDay.value!) ==
          formattedDate) {
        fetchEventsForSelectedDay();
      }
    });
  }
}
