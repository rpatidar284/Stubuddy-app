import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_record.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_controller.dart';

class AttendanceAnalyticsController extends GetxController {
  var dailyAttendancePercentages = <String, double>{}.obs;
  var averageAttendance = 0.0.obs;
  var bestDay = 'N/A'.obs;

  // New observables for overall class counts
  var totalClassesThisWeek = 0.obs;
  var totalAttendedClassesThisWeek = 0.obs;
  var totalMissedClassesThisWeek = 0.obs; // This will replace "Trend"

  // Helper map to store total classes per day for analytics calculations (for daily breakdown)
  var totalClassesPerDayInAnalytics =
      <String, int>{
        'Mon': 0,
        'Tue': 0,
        'Wed': 0,
        'Thu': 0,
        'Fri': 0,
        'Sat': 0,
        'Sun': 0,
      }.obs;

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<SubjectController>().subjects, (_) => fetchAttendanceData());
    ever(
      Get.find<AttendanceController>().attendanceHistory,
      (_) => fetchAttendanceData(),
    );
    fetchAttendanceData(); // Initial fetch
  }

  Future<void> fetchAttendanceData() async {
    final db = DBHelper.getInstance;
    List<Map<String, dynamic>> allRecordsMap =
        await db.getAllAttendanceRecords();
    List<AttendanceRecord> allRecords =
        allRecordsMap.map((map) => AttendanceRecord.fromMap(map)).toList();

    _calculateDailyAttendance(
      allRecords,
    ); // This also populates totalClassesPerDayInAnalytics
    _calculateOverallStats(allRecords); // New method for overall counts
    _calculateAverageAttendance(); // Now uses overall stats
    _calculateBestDay();
  }

  void _calculateDailyAttendance(List<AttendanceRecord> records) {
    Map<String, List<bool>> dailyStats = {
      'Mon': [],
      'Tue': [],
      'Wed': [],
      'Thu': [],
      'Fri': [],
      'Sat': [],
      'Sun': [],
    };
    totalClassesPerDayInAnalytics.value = {
      // Reset for current calculation cycle
      'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0,
    };

    for (var record in records) {
      String dayOfWeek = DateFormat('EEE').format(record.date);
      if (dailyStats.containsKey(dayOfWeek)) {
        dailyStats[dayOfWeek]!.add(record.isPresent);
        totalClassesPerDayInAnalytics[dayOfWeek] =
            (totalClassesPerDayInAnalytics[dayOfWeek] ?? 0) + 1;
      }
    }

    Map<String, double> calculatedPercentages = {};
    dailyStats.forEach((day, statusList) {
      int totalClasses = totalClassesPerDayInAnalytics[day] ?? 0;
      if (totalClasses == 0) {
        calculatedPercentages[day] = 0.0;
      } else {
        int presentCount = statusList.where((p) => p).length;
        calculatedPercentages[day] = (presentCount / totalClasses) * 100;
      }
    });

    dailyAttendancePercentages.value = calculatedPercentages;
  }

  // NEW: Calculate overall classes attended and conducted for the week
  void _calculateOverallStats(List<AttendanceRecord> allRecords) {
    int conducted = 0;
    int attended = 0;
    for (var record in allRecords) {
      conducted++;
      if (record.isPresent) {
        attended++;
      }
    }
    totalClassesThisWeek.value = conducted;
    totalAttendedClassesThisWeek.value = attended;
    totalMissedClassesThisWeek.value =
        conducted - attended; // Calculate missed classes
  }

  void _calculateAverageAttendance() {
    if (totalClassesThisWeek.value == 0) {
      averageAttendance.value = 0.0;
    } else {
      averageAttendance.value =
          (totalAttendedClassesThisWeek.value / totalClassesThisWeek.value) *
          100;
    }
  }

  void _calculateBestDay() {
    if (dailyAttendancePercentages.isEmpty) {
      bestDay.value = 'N/A';
      return;
    }

    double maxPercentage = -1;
    String bestDayName = 'N/A';

    List<String> orderedDays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    for (String day in orderedDays) {
      if (totalClassesPerDayInAnalytics[day]! > 0) {
        if (dailyAttendancePercentages.containsKey(day) &&
            dailyAttendancePercentages[day]! > maxPercentage) {
          maxPercentage = dailyAttendancePercentages[day]!;
          bestDayName = day;
        }
      }
    }
    if (maxPercentage == -1) {
      bestDay.value = 'N/A';
    } else {
      bestDay.value = bestDayName;
    }
  }
}
