// File: lib/features/my_grades/utils/grade_calculator.dart
class GradeCalculator {
  static double calculatePercentage(
    double marksObtained,
    double totalMarks,
    double weightage,
  ) {
    if (totalMarks <= 0) {
      return 0.0;
    }
    return (marksObtained / totalMarks) * weightage;
  }

  static double calculateWeightedAverage(List<Map<String, dynamic>> grades) {
    double totalWeightedMarksObtained = 0.0;

    for (var grade in grades) {
      double weightage = grade['weightage'] ?? 0.0;
      double marksObtained = grade['marksObtained'] ?? 0.0;
      double totalMarks = grade['totalMarks'] ?? 0.0;

      if (totalMarks > 0) {
        totalWeightedMarksObtained += (marksObtained / totalMarks) * weightage;
      }
    }

    if (totalWeightedMarksObtained <= 0) {
      return 0.0;
    }
    return (totalWeightedMarksObtained);
  }
}
