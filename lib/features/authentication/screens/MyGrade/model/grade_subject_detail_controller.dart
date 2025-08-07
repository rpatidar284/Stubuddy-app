// File: lib/features/my_grades/presentation/controllers/grade_subject_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_sub_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/pages/grade_calculator.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_repository.dart';

class GradeSubjectDetailController extends GetxController {
  final GradeRepository _gradeRepository = Get.find<GradeRepository>();
  final GradeSubjectModel subject; // The subject whose details are being shown

  RxList<GradeModel> gradesList = <GradeModel>[].obs;
  RxDouble overallPercentage = 0.0.obs;
  RxBool isLoadingGrades = true.obs;

  GradeSubjectDetailController({required this.subject});

  @override
  void onInit() {
    super.onInit();
    loadGrades();
  }

  Future<void> loadGrades() async {
    isLoadingGrades.value = true;
    try {
      if (subject.id == null) {
        Get.snackbar(
          'Error',
          'Subject ID is null, cannot load grades.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      final fetchedGrades = await _gradeRepository.getGradesByGradeSubjectId(
        subject.id!,
      );

      if (kDebugMode) {
        print(
          "GradeSubjectDetailController: Fetched grades for ${subject.name}: ${fetchedGrades.map((g) => g.toMap()).toList()}",
        );
      }

      gradesList.assignAll(fetchedGrades);
      overallPercentage.value = GradeCalculator.calculateWeightedAverage(
        fetchedGrades.map((g) => g.toMap()).toList(),
      );

      if (kDebugMode) {
        print(
          "GradeSubjectDetailController: Overall percentage for ${subject.name}: ${overallPercentage.value.round()}%",
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("GradeSubjectDetailController: Error loading grades: $e");
        print("StackTrace: $stackTrace");
      }
      Get.snackbar(
        'Error',
        'Failed to load grades for subject: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingGrades.value = false;
    }
  }

  // Method to handle grade deletion directly from this controller
  Future<void> deleteGrade(int gradeId) async {
    try {
      await _gradeRepository.deleteGrade(gradeId);
      Get.snackbar(
        'Success',
        'Grade deleted!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      loadGrades(); // Refresh the list after deletion
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("GradeSubjectDetailController: Error deleting grade: $e");
        print("StackTrace: $stackTrace");
      }
      Get.snackbar(
        'Error',
        'Failed to delete grade: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
