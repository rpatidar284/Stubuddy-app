import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/controllers/schedule_controller.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/constants.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/schedule_event_model.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class AddEventModal extends StatelessWidget {
  final ScheduleController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _tagController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _roomController = TextEditingController();
  final _instructorController = TextEditingController();

  AddEventModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: AppColors.cardBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _subjectController,
                label: 'Event Title',
                icon: Icons.event,
              ),
              _buildTextField(
                controller: _tagController,
                label: 'Tag (e.g., Data Science)',
                icon: Icons.label,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _showTimePicker(context, _startTimeController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _startTimeController,
                          label: 'Start Time',
                          icon: Icons.access_time,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showTimePicker(context, _endTimeController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _endTimeController,
                          label: 'End Time',
                          icon: Icons.access_time,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTextField(
                controller: _roomController,
                label: 'Location/Room',
                icon: Icons.location_on,
              ),
              _buildTextField(
                controller: _instructorController,
                label: 'Instructor/Organizer',
                icon: Icons.person,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: GFButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newEvent = ScheduleEventModel(
                        subject: _subjectController.text,
                        tag: _tagController.text,
                        startTime: _startTimeController.text,
                        endTime: _endTimeController.text,
                        room: _roomController.text,
                        instructor: _instructorController.text,
                        date: DateFormat(
                          'yyyy-MM-dd',
                        ).format(_controller.selectedDay.value!),
                      );
                      _controller.addEvent(newEvent);
                      Get.back(); // Go back after adding event
                    }
                  },
                  text: 'Add Event',
                  shape: GFButtonShape.pills,
                  size: GFSize.LARGE,
                  color: SColors.buttonPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: SColors.buttonPrimary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _showTimePicker(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      controller.text = selectedTime.format(context);
    }
  }
}
