import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_sub_model.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart'; // NEW import for GradeSubjectModel

class GradeRepository {
  final DBHelper _dbHelper = DBHelper.getInstance;

  // Methods for GradeSubjectModel
  Future<int> addGradeSubject(GradeSubjectModel subject) async {
    return await _dbHelper.insertGradeSubject(subject.toMap());
  }

  Future<List<GradeSubjectModel>> getAllGradeSubjects() async {
    final List<Map<String, dynamic>> maps =
        await _dbHelper.getAllGradeSubjects();
    return List.generate(maps.length, (i) {
      return GradeSubjectModel.fromMap(maps[i]);
    });
  }

  Future<GradeSubjectModel?> getGradeSubjectById(int id) async {
    final Map<String, dynamic>? map = await _dbHelper.getGradeSubjectById(id);
    return map != null ? GradeSubjectModel.fromMap(map) : null;
  }

  Future<int> deleteGradeSubject(int id) async {
    return await _dbHelper.deleteGradeSubject(id);
  }

  // Methods for GradeModel
  Future<int> addGrade(GradeModel grade) async {
    return await _dbHelper.insertGrade(grade.toMap());
  }

  Future<List<GradeModel>> getGradesByGradeSubjectId(int gradeSubjectId) async {
    final List<Map<String, dynamic>> maps = await _dbHelper
        .getGradesBySubjectId(gradeSubjectId); // Changed method name
    return List.generate(maps.length, (i) {
      return GradeModel.fromMap(maps[i]);
    });
  }

  Future<int> updateGrade(GradeModel grade) async {
    return await _dbHelper.updateGrade(grade.toMap(), grade.id!);
  }

  Future<int> deleteGrade(int id) async {
    return await _dbHelper.deleteGrade(id);
  }

  // Method for grade analytics (now uses GradeSubjectModel)
  Future<List<Map<String, dynamic>>> getAverageGradeForGradeSubjects() async {
    return await _dbHelper.getAverageGradeForGradeSubjects();
  }
}
