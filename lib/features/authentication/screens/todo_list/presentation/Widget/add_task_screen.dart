// File: lib/presentation/to_do_list_screen/add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/models/task_model.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/task_controller.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class AddTaskScreen extends StatelessWidget {
  final Task? taskToEdit; // Now a full Task object
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController =
      TextEditingController(); // New controller for subject input
  final _formKey = GlobalKey<FormState>();

  // Use Rx variables for state that needs to be reactive within this page
  final Rx<DateTime?> _selectedDueDate = Rx<DateTime?>(null);
  final RxString _selectedPriority = 'Medium'.obs;

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  AddTaskScreen({Key? key, this.taskToEdit}) : super(key: key) {
    // Initialize controllers and Rx variables with taskToEdit data
    if (taskToEdit != null) {
      _titleController.text = taskToEdit!.title;
      _descriptionController.text = taskToEdit!.description ?? '';
      _selectedDueDate.value = taskToEdit!.dueDate;
      _selectedPriority.value = taskToEdit!.priority;
      _subjectController.text = taskToEdit!.subject ?? '';
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppTheme.primaryPurple),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectedDueDate.value = picked;
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final taskController =
          Get.find<TaskController>(); // Get the controller instance

      final task = Task(
        id: taskToEdit?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDueDate.value,
        priority: _selectedPriority.value,
        subject:
            _subjectController.text.trim().isEmpty
                ? null
                : _subjectController.text.trim(), // Use text input
        isCompleted: taskToEdit?.isCompleted ?? false,
        createdAt: taskToEdit?.createdAt ?? now,
        updatedAt: now,
      );

      if (taskToEdit != null) {
        taskController.updateTask(task);
      } else {
        taskController.addTask(task);
      }
      Get.back(); // Close the page
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return AppTheme.warningOrange;
      case 'low':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: SColors.primary,
        foregroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          taskToEdit != null ? 'Edit Task' : 'Add New Task',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.backgroundWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.backgroundWhite,
            size: 6.w,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Task Title
                Text(
                  'Task Title *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter task title',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),

                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter task description (optional)',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 2.h),

                // Due Date
                Text(
                  'Due Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 1.h),
                Obx(
                  () => InkWell(
                    onTap: () => _selectDueDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ), // Adjust vertical padding for better look
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceGray,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme.primaryPurple,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _selectedDueDate.value != null
                                ? '${_selectedDueDate.value!.month}/${_selectedDueDate.value!.day}/${_selectedDueDate.value!.year}'
                                : 'Select due date',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                                  color:
                                      _selectedDueDate.value != null
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
                                ),
                          ),
                          const Spacer(),
                          if (_selectedDueDate.value != null)
                            GestureDetector(
                              onTap: () => _selectedDueDate.value = null,
                              child: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme.textSecondary,
                                size: 5.w,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Priority
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 1.h),
                Obx(
                  () => Row(
                    children:
                        _priorities.map((priority) {
                          final isSelected =
                              _selectedPriority.value == priority;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _selectedPriority.value = priority,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: priority != _priorities.last ? 3.w : 0,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? _getPriorityColor(
                                            priority,
                                          ).withOpacity(0.1)
                                          : AppTheme.surfaceGray,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? _getPriorityColor(priority)
                                            : AppTheme.borderSubtle,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 3.w,
                                      height: 3.w,
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor(priority),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      priority,
                                      style: AppTheme
                                          .lightTheme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                isSelected
                                                    ? _getPriorityColor(
                                                      priority,
                                                    )
                                                    : AppTheme.textSecondary,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 3.h),

                // Subject (changed from Dropdown to TextFormField)
                Text(
                  'Subject',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Enter subject (e.g., Physics, Math)',
                  ),
                ),
                SizedBox(height: 4.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GFButton(
                        onPressed: () => Get.back(),
                        text: 'Cancel',
                        shape: GFButtonShape.pills,
                        type: GFButtonType.outline2x,

                        size: GFSize.LARGE,
                        color: SColors.buttonPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: GFButton(
                        onPressed: _saveTask,
                        text: taskToEdit != null ? 'Update Task' : 'Add Task',
                        shape: GFButtonShape.pills,

                        size: GFSize.LARGE,
                        color: SColors.buttonPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
