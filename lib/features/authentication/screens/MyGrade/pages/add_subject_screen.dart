// File: lib/features/my_grades/presentation/add_subject_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/model/grade_sub_model.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_repository.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class AddSubjectController extends GetxController {
  final GradeRepository _gradeRepository = Get.find<GradeRepository>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController teacherController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addGradeSubject() async {
    if (formKey.currentState!.validate()) {
      if (kDebugMode) {
        print(
          "AddSubjectController: Form is valid. Attempting to add subject.",
        );
      }

      final subject = GradeSubjectModel(
        name: titleController.text,
        teacher:
            teacherController.text.isNotEmpty ? teacherController.text : null,
      );

      try {
        final int id = await _gradeRepository.addGradeSubject(subject);
        if (kDebugMode) {
          print(
            "AddSubjectController: Subject added successfully with ID: $id",
          );
          print("AddSubjectController: Signaling success and navigating back.");
        }

        // --- IMPORTANT CHANGE HERE ---
        // We navigate back immediately with a success signal.
        // The Snackbar will be handled by the *receiving* screen (MyGradesScreen)
        // after it has fully rendered and its controller is active.
        Get.back(result: true);
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print("AddSubjectController: Failed to add grade subject: $e");
          print("StackTrace: $stackTrace");
        }
        // Even on error, navigate back, but signal failure.
        Get.back(result: false); // Signal failure
      }
    } else {
      if (kDebugMode) {
        print("AddSubjectController: Form validation failed.");
      }
      // If validation fails, stay on screen, no snackbar needed for this simple validation.
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    teacherController.dispose();
    super.onClose();
  }
}

// The AddSubjectScreen StatelessWidget is unchanged from previous versions.
/* ... (Rest of the AddSubjectScreen StatelessWidget code remains unchanged) ... */
class AddSubjectScreen extends StatelessWidget {
  const AddSubjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddSubjectController controller = Get.put(AddSubjectController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject for Grades'),
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
                "Subject Name",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Subject Title*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Instructor",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: controller.teacherController,
                decoration: InputDecoration(
                  labelText: 'Instructor Name (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              GFButton(
                onPressed: controller.addGradeSubject,
                text: "ADD",
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
