// File: lib/features/my_grades/presentation/pages/grade_subject_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/MyGradeController.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_sub_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_subject_detail_controller.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/pages/add_grade_screen.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_entry_card.dart';

class GradeSubjectDetailScreen extends StatelessWidget {
  final GradeSubjectModel subject;

  const GradeSubjectDetailScreen({Key? key, required this.subject})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inject the controller for this screen
    final controller = Get.put(GradeSubjectDetailController(subject: subject));

    return Scaffold(
      appBar: AppBar(
        title: Text('${subject.name} Grades'),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructor: ${subject.teacher ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'Overall Percentage: ${controller.overallPercentage.value.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      controller.overallPercentage.value < 50
                          ? Colors.red
                          : Colors.green,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(
                () =>
                    controller.isLoadingGrades.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.gradesList.isEmpty
                        ? const Center(child: Text('No grades added yet.'))
                        : ListView.builder(
                          itemCount: controller.gradesList.length,
                          itemBuilder: (context, index) {
                            final grade = controller.gradesList[index];
                            return GradeEntryCard(
                              grade: grade,
                              onEdit: () async {
                                // Navigate to AddGradeScreen as a new page for editing
                                final result = await Get.to(
                                  () => AddGradeScreen(
                                    subjectId: subject.id!,
                                    gradeToEdit: grade,
                                  ),
                                );
                                // Handle result from AddGradeScreen (page)
                                if (result is bool && result == true) {
                                  controller
                                      .loadGrades(); // Refresh grades on this page
                                  Get.find<MyGradesController>()
                                      .loadData(); // Refresh main screen's overall data
                                  Get.snackbar(
                                    'Success',
                                    'Grade updated successfully!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 2),
                                  );
                                } else if (result is bool && result == false) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to update grade.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    duration: const Duration(seconds: 3),
                                  );
                                }
                              },
                              onDelete:
                                  () => controller.deleteGrade(
                                    grade.id!,
                                  ), // Call controller's delete
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (subject.id == null) {
            Get.snackbar(
              'Error',
              'Cannot add grade: Subject ID is null.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          // Navigate to AddGradeScreen as a new page for adding
          final result = await Get.to(
            () => AddGradeScreen(subjectId: subject.id!),
          );
          // Handle result from AddGradeScreen (page)
          if (result is bool && result == true) {
            controller.loadGrades(); // Refresh grades on this page
            Get.find<MyGradesController>()
                .loadData(); // Refresh data on main MyGradesScreen too
            Get.snackbar(
              'Success',
              'Grade added successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          } else if (result is bool && result == false) {
            Get.snackbar(
              'Error',
              'Failed to add grade.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
