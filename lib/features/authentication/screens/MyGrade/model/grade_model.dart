// File: lib/data/local/db/models/grade_model.dart
class GradeModel {
  int? id;
  int subjectId; // This now refers to the ID from GradeSubjectModel
  double weightage;
  double totalMarks;
  double marksObtained;
  double percentage;

  GradeModel({
    this.id,
    required this.subjectId,
    required this.weightage,
    required this.totalMarks,
    required this.marksObtained,
    required this.percentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'weightage': weightage,
      'totalMarks': totalMarks,
      'marksObtained': marksObtained,
      'percentage': percentage,
    };
  }

  factory GradeModel.fromMap(Map<String, dynamic> map) {
    return GradeModel(
      id: map['id'],
      subjectId: map['subjectId'],
      weightage: map['weightage'],
      totalMarks: map['totalMarks'],
      marksObtained: map['marksObtained'],
      percentage: map['percentage'],
    );
  }
}
