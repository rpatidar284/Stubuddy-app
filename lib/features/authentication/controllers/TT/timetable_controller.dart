import 'package:get/get.dart';

import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class TimetableController extends GetxController {
  var selectedDay = 'MON'.obs;
  var classes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClassesForDay(selectedDay.value);
  }

  void setSelectedDay(String day) async {
    selectedDay.value = day;
    await fetchClassesForDay(day);
  }

  Future<void> fetchClassesForDay(String day) async {
    final data = await DBHelper.getInstance.getClassesByDay(day);
    classes.assignAll(data);
  }

  Future<void> addClass(Map<String, dynamic> newClass) async {
    await DBHelper.getInstance.insertClass(newClass);
    await fetchClassesForDay(selectedDay.value);
  }

  Future<void> deleteClass(int id) async {
    await DBHelper.getInstance.deleteClass(id);
    await fetchClassesForDay(selectedDay.value);
  }
}
