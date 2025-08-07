import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class SubjectController extends GetxController {
  var subjects = <Subject>[].obs;
  var lowAttendanceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
  }

  void fetchSubjects() async {
    var db = DBHelper.getInstance;
    var subjectMaps = await db.getAllSubjects();
    subjects.value = subjectMaps.map((map) => Subject.fromMap(map)).toList();
    calculateLowAttendance();
  }

  void calculateLowAttendance() {
    lowAttendanceCount.value =
        subjects.where((s) {
          if (s.totalClasses == 0) return false;
          double percentage = (s.attendedClasses / s.totalClasses) * 100;
          return percentage < 80;
        }).length;
  }

  void addSubject(Subject subject) async {
    var db = DBHelper.getInstance;
    await db.insertSubject(subject.toMap());
    fetchSubjects();
  }

  void deleteSubject(int id) async {
    var db = DBHelper.getInstance;
    await db.deleteSubject(id);
    fetchSubjects();
  }

  void updateSubjectAttendance(int subjectId, bool isPresent) async {
    var db = DBHelper.getInstance;
    Subject? subject = subjects.firstWhereOrNull(
      (s) => s.id == subjectId,
    ); // Use firstWhereOrNull for safety

    if (subject == null) return; // Should not happen if UI is consistent

    int newAttended = subject.attendedClasses;
    if (isPresent) {
      newAttended++;
    }

    await db.updateSubject({
      DBHelper.COL_SUB_TOTAL_CLASSES: subject.totalClasses + 1, // Use constants
      DBHelper.COL_SUB_ATTENDED_CLASSES: newAttended, // Use constants
    }, subjectId);

    fetchSubjects(); // Refresh the list to update UI
  }
}
