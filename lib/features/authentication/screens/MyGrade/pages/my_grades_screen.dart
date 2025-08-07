import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stu_buddy/common/widgets/custom_shape/container/sprimary_header_container.dart';
import 'package:stu_buddy/common/widgets/custom_shape/curved_shap/subjectCircular.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/MyGradeController.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_sub_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_subject_detail_controller.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/pages/add_subject_screen.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/pages/grade_subject_detail_screen.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_analytics_card.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class MyGradesScreen extends StatelessWidget {
  const MyGradesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyGradesController controller = Get.put(MyGradesController());

    return Scaffold(
      body: Stack(
        children: [
          SprimaryHeaderContainer(height: 180),
          Positioned(
            top: 425,
            left: 16,
            child: Row(
              children: [
                Icon(Icons.subject),
                SizedBox(width: SSizes.sm),
                Text(
                  "All Subjects (${controller.gradeSubjects.length})",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'MyGrades',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.apply(color: SColors.white),
                    ),
                  ],
                ),
                Icon(CupertinoIcons.chart_bar_alt_fill, color: Colors.white),
              ],
            ),
          ),

          Obx(
            () =>
                controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        SizedBox(height: 100),
                        GradeAnalyticsCard(
                          subjectAverageGrades:
                              controller.gradeSubjectAverageGrades,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.gradeSubjects.length,
                            itemBuilder: (context, index) {
                              final subject = controller.gradeSubjects[index];
                              final avgGrade = controller
                                  .gradeSubjectAverageGrades
                                  .firstWhere(
                                    (element) =>
                                        element[DBHelper.COL_GRADE_SUB_ID] ==
                                        subject.id,
                                    orElse:
                                        () => {
                                          DBHelper.COL_GRADE_SUB_ID: subject.id,
                                          DBHelper.COL_GRADE_SUB_NAME:
                                              subject.name,
                                          'averagePercentage': 0,
                                        },
                                  );
                              final controller1 = Get.put(
                                GradeSubjectDetailController(subject: subject),
                              );
                              return SCard(
                                avgGrade:
                                    controller1.overallPercentage.value.round(),
                                subject: subject,
                                controller: controller,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => const AddSubjectScreen());
          if (result is bool && result == true) {
            controller.loadData();
            Get.snackbar(
              'Success',
              'Grade Subject added successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          } else if (result is bool && result == false) {
            Get.snackbar(
              'Error',
              'Failed to add grade subject.',
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

class SCard extends StatelessWidget {
  const SCard({
    super.key,
    required this.avgGrade,
    required this.subject,
    required this.controller,
  });

  final int avgGrade;
  final GradeSubjectModel subject;
  final MyGradesController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (subject.id != null) {
          final result = await Get.to(
            () => GradeSubjectDetailScreen(subject: subject),
          );
          if (result == true) {
            controller.loadData();
          }
        } else {
          Get.snackbar(
            'Error',
            'Cannot show details: Subject ID is null.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: SColors.secondary.withOpacity(0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Subjectcircular(percentCurrent: avgGrade),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.book_1),
                        SizedBox(width: SSizes.sm),
                        Text(
                          subject.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_2_outlined),
                        SizedBox(width: SSizes.sm),
                        Text(
                          subject.teacher != null && subject.teacher!.isNotEmpty
                              ? 'Teacher: ${subject.teacher}'
                              : 'Teacher: N/A',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  if (subject.id != null) {
                    controller.deleteGradeSubject(subject.id!);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Cannot delete subject: ID is null.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
