import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/controllers/TT/timetable_controller.dart';

class AddClassController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final subjectController = TextEditingController();
  final roomController = TextEditingController();
  final instructorController = TextEditingController();

  final Rx<TimeOfDay> startTime = TimeOfDay(hour: 8, minute: 0).obs;
  final Rx<TimeOfDay> endTime = TimeOfDay(hour: 9, minute: 0).obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  String? validateSubject(String? value) =>
      value == null || value.isEmpty ? 'Please enter a subject' : null;

  String? validateRoomNumber(String? value) =>
      value == null || value.isEmpty ? 'Please enter a room number' : null;

  String? validateInstructor(String? value) =>
      value == null || value.isEmpty ? 'Please enter an instructor' : null;

  Future<void> selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value,
    );
    if (picked != null) startTime.value = picked;
  }

  Future<void> selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime.value,
    );
    if (picked != null) endTime.value = picked;
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> addClass() async {
    if (formKey.currentState!.validate()) {
      final String day =
          DateFormat('EEE').format(selectedDate.value).toUpperCase();

      final formattedStart = DateFormat('HH:mm').format(
        DateTime(2000, 1, 1, startTime.value.hour, startTime.value.minute),
      );
      final formattedEnd = DateFormat(
        'HH:mm',
      ).format(DateTime(2000, 1, 1, endTime.value.hour, endTime.value.minute));

      final formattedTime = "$formattedStart - $formattedEnd";

      final newClass = {
        'subject': subjectController.text.trim(),
        'time': formattedTime,
        'room': roomController.text.trim(),
        'instructor': instructorController.text.trim(),
        'day': day,
      };

      await Get.find<TimetableController>().addClass(newClass);
      Get.back();
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    roomController.dispose();
    instructorController.dispose();
    super.onClose();
  }
}
