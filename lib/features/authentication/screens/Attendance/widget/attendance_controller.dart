import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_record.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject_controller.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class AttendanceController extends GetxController {
  var attendanceHistory = <AttendanceRecord>[].obs;

  void getAttendanceHistory(int subjectId) async {
    var db = DBHelper.getInstance;
    var records = await db.getAttendanceRecordsBySubject(subjectId);
    attendanceHistory.value =
        records.map((map) => AttendanceRecord.fromMap(map)).toList();
  }

  void addAttendanceRecord(AttendanceRecord record) async {
    var db = DBHelper.getInstance;
    await db.insertAttendanceRecord(record.toMap());
    getAttendanceHistory(record.subjectId);

    final subjectController = Get.find<SubjectController>();
    subjectController.updateSubjectAttendance(
      record.subjectId,
      record.isPresent,
    );
  }

  Future<void> deleteAttendanceRecord(
    int recordId,
    int subjectId,
    bool wasPresent,
  ) async {
    var db = DBHelper.getInstance;
    await db.deleteAttendanceRecord(recordId);

    final subjectController = Get.find<SubjectController>();

    Subject? subject = subjectController.subjects.firstWhereOrNull(
      (s) => s.id == subjectId,
    );
    if (subject != null) {
      int newTotal = subject.totalClasses - 1;
      int newAttended = subject.attendedClasses;
      if (wasPresent) {
        newAttended--;
      }

      await db.updateSubject({
        DBHelper.COL_SUB_TOTAL_CLASSES: newTotal >= 0 ? newTotal : 0,
        DBHelper.COL_SUB_ATTENDED_CLASSES: newAttended >= 0 ? newAttended : 0,
      }, subjectId);
    }

    getAttendanceHistory(subjectId);
    subjectController.fetchSubjects();
  }

  // NEW: Method to check if a subject has any attendance records
  Future<int> getAttendanceRecordCountForSubject(int subjectId) async {
    return await DBHelper.getInstance.countAttendanceRecordsForSubject(
      subjectId,
    );
  }
}
