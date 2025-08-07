// File: lib/data/local/db/models/grade_subject_model.dart
// This model is specifically for My Grades subjects.
class GradeSubjectModel {
  int? id;
  String name;
  String? teacher;

  GradeSubjectModel({this.id, required this.name, this.teacher});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'teacher': teacher};
  }

  factory GradeSubjectModel.fromMap(Map<String, dynamic> map) {
    return GradeSubjectModel(
      id: map['id'],
      name: map['name'] as String,
      teacher: map['teacher'] as String?,
    );
  }
}
