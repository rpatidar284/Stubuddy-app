// File: lib/features/my_grades/presentation/add_grade_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/pages/grade_calculator.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_repository.dart';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:stu_buddy/utils/constants/colors.dart'; // For debug prints

class AddGradeController extends GetxController {
  final GradeRepository _gradeRepository = Get.find<GradeRepository>();
  final int subjectId;
  final GradeModel? gradeToEdit;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController weightageController = TextEditingController();
  final TextEditingController totalMarksController = TextEditingController();
  final TextEditingController marksObtainedController = TextEditingController();

  RxDouble calculatedPercentage = 0.0.obs;

  AddGradeController({required this.subjectId, this.gradeToEdit});

  @override
  void onInit() {
    super.onInit();
    if (gradeToEdit != null) {
      weightageController.text = gradeToEdit!.weightage.toString();
      totalMarksController.text = gradeToEdit!.totalMarks.toString();
      marksObtainedController.text = gradeToEdit!.marksObtained.toString();
      calculatedPercentage.value = gradeToEdit!.percentage;
    }

    marksObtainedController.addListener(_calculatePercentage);
    totalMarksController.addListener(_calculatePercentage);
  }

  void _calculatePercentage() {
    final double? marksObtained = double.tryParse(marksObtainedController.text);
    final double? totalMarks = double.tryParse(totalMarksController.text);
    final double weightage = double.parse(weightageController.text);

    if (marksObtained != null && totalMarks != null && totalMarks > 0) {
      calculatedPercentage.value = GradeCalculator.calculatePercentage(
        marksObtained,
        totalMarks,
        weightage,
      );
    } else {
      calculatedPercentage.value = 0.0;
    }
  }

  Future<void> saveGrade() async {
    if (formKey.currentState!.validate()) {
      final double weightage = double.parse(weightageController.text);
      final double totalMarks = double.parse(totalMarksController.text);
      final double marksObtained = double.parse(marksObtainedController.text);

      final GradeModel newGrade = GradeModel(
        id: gradeToEdit?.id,
        subjectId: subjectId,
        weightage: weightage,
        totalMarks: totalMarks,
        marksObtained: marksObtained,
        percentage: calculatedPercentage.value,
      );

      try {
        if (kDebugMode) {
          print(
            "AddGradeController: Attempting to save grade: ${newGrade.toMap()}",
          );
        }
        if (gradeToEdit == null) {
          await _gradeRepository.addGrade(newGrade);
          if (kDebugMode) {
            print("AddGradeController: Grade added successfully.");
          }
        } else {
          await _gradeRepository.updateGrade(newGrade);
          if (kDebugMode) {
            print("AddGradeController: Grade updated successfully.");
          }
        }
        Get.back(result: true); // Signal success and navigate back
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print("AddGradeController: Failed to save grade: $e");
          print("StackTrace: $stackTrace");
        }
        Get.back(result: false); // Signal failure and navigate back
      }
    } else {
      if (kDebugMode) {
        print("AddGradeController: Form validation failed.");
      }
    }
  }

  @override
  void onClose() {
    weightageController.dispose();
    totalMarksController.dispose();
    marksObtainedController.dispose();
    super.onClose();
  }
}

// Remainder of AddGradeScreen StatelessWidget is unchanged.
/* ... (Rest of the AddGradeScreen StatelessWidget code remains unchanged) ... */
class AddGradeScreen extends StatelessWidget {
  final int subjectId;
  final GradeModel? gradeToEdit;

  const AddGradeScreen({Key? key, required this.subjectId, this.gradeToEdit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddGradeController controller = Get.put(
      AddGradeController(subjectId: subjectId, gradeToEdit: gradeToEdit),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(gradeToEdit == null ? 'Add Grade' : 'Edit Grade'),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Weightage (from 100%)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.weightageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weightage',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weightage';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Total Marks',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.totalMarksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Marks*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total marks';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Marks Obtained',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.marksObtainedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Marks Obtained',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks obtained';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Obx(
                () => Text(
                  'Calculated Percentage: ${controller.calculatedPercentage.value.round()}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24.0),
              GFButton(
                onPressed: controller.saveGrade,
                text: gradeToEdit == null ? 'ADD' : 'UPDATE',
                shape: GFButtonShape.pills,
                size: GFSize.LARGE,
                color: SColors.buttonPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
