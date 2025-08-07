import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/controllers/TT/add_class_controller.dart';
import 'package:stu_buddy/utils/constants/colors.dart';
import 'package:stu_buddy/utils/constants/sizes.dart';

class AddClassScreen extends StatelessWidget {
  const AddClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddClassController controller = Get.put(AddClassController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Class'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: Get.back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              _buildSectionTitle(context, 'Subject'),
              TextFormField(
                controller: controller.subjectController,
                decoration: const InputDecoration(
                  hintText: 'Enter subject name',
                  prefixIcon: Icon(Iconsax.book, color: SColors.buttonPrimary),
                ),
                validator: controller.validateSubject,
              ),
              const SizedBox(height: SSizes.spaceBtwItems),

              _buildSectionTitle(context, 'Time & Day'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectStartTime(context),
                      child: AbsorbPointer(
                        child: Obx(
                          () => TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: controller.startTime.value.format(context),
                            ),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: SColors.buttonPrimary,
                              ),
                              hintText: 'From',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SSizes.spaceBtwItems),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectEndTime(context),
                      child: AbsorbPointer(
                        child: Obx(
                          () => TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: controller.endTime.value.format(context),
                            ),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: SColors.buttonPrimary,
                              ),
                              hintText: 'To',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SSizes.spaceBtwItems),
              GestureDetector(
                onTap: () => controller.selectDate(context),
                child: AbsorbPointer(
                  child: Obx(
                    () => TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat(
                          'EEEE',
                        ).format(controller.selectedDate.value),
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: SColors.buttonPrimary,
                        ),
                        hintText: 'Select Day',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              _buildSectionTitle(context, 'Room Number'),
              TextFormField(
                controller: controller.roomController,
                decoration: const InputDecoration(
                  hintText: 'Enter room name',
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: SColors.buttonPrimary,
                  ),
                ),
                validator: controller.validateRoomNumber,
              ),
              const SizedBox(height: 24.0),

              _buildSectionTitle(context, 'Instructor'),
              TextFormField(
                controller: controller.instructorController,
                decoration: const InputDecoration(
                  hintText: 'Enter instructor name',
                  prefixIcon: Icon(Icons.person, color: SColors.buttonPrimary),
                ),
                validator: controller.validateInstructor,
              ),
              const SizedBox(height: 40.0),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SColors.buttonPrimary,
                  side: const BorderSide(color: SColors.buttonPrimary),
                ),
                onPressed: controller.addClass,
                child: const Text('Add Class'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
