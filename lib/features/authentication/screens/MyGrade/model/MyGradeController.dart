// File: lib/features/authentication/screens/MyGrade/pages/my_grades_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_sub_model.dart';

import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_repository.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class MyGradesController extends GetxController {
  final GradeRepository _gradeRepository = Get.find<GradeRepository>();

  RxList<GradeSubjectModel> gradeSubjects = <GradeSubjectModel>[].obs;
  RxList<Map<String, dynamic>> gradeSubjectAverageGrades =
      <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final fetchedGradeSubjects = await _gradeRepository.getAllGradeSubjects();
      final fetchedAverageGrades =
          await _gradeRepository.getAverageGradeForGradeSubjects();

      if (kDebugMode) {
        print("MyGradesController: --- loadData() called ---");
        print(
          "MyGradesController: Fetched Grade Subjects: ${fetchedGradeSubjects.map((s) => s.toMap()).toList()}",
        );
        print(
          "MyGradesController: Fetched Average Grades: $fetchedAverageGrades",
        );
      }

      gradeSubjects.assignAll(fetchedGradeSubjects);
      gradeSubjectAverageGrades.assignAll(fetchedAverageGrades);

      if (kDebugMode) {
        print(
          "MyGradesController: gradeSubjects RxList updated: ${gradeSubjects.map((s) => s.toMap()).toList()}",
        );
        print(
          "MyGradesController: gradeSubjectAverageGrades RxList updated: $gradeSubjectAverageGrades",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("MyGradesController: Error loading data: $e");
      }
      Get.snackbar(
        'Error',
        'Failed to load grades data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      if (kDebugMode) {
        print(
          "MyGradesController: isLoading set to false. --- loadData() finished ---",
        );
      }
    }
  }

  // --- showGradeSubjectDetails is now removed and replaced by direct navigation ---
  // The logic for displaying details and adding grades for a subject is now
  // within the GradeSubjectDetailScreen itself.

  void deleteGradeSubject(int subjectId) {
    Get.defaultDialog(
      title: 'Delete Subject',
      content: const Text(
        'Are you sure you want to delete this grade subject and all its grades?',
      ),
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: SColors.buttonPrimary,
      onConfirm: () async {
        Get.back();
        try {
          await _gradeRepository.deleteGradeSubject(subjectId);
          loadData();
          Get.snackbar(
            'Success',
            'Grade Subject deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'Failed to delete grade subject: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      },
    );
  }
}
