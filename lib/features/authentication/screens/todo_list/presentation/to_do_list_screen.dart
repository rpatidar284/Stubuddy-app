// File: lib/presentation/to_do_list_screen/to_do_list_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/add_task_screen.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/empty_state_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/filter_bottom_sheet.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/search_bar_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/task_controller.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/task_item_widget.dart';
import 'package:stu_buddy/utils/constants/colors.dart'; // Import GetX

class ToDoListScreen extends StatelessWidget {
  ToDoListScreen({Key? key}) : super(key: key) {
    // Initialize TaskController if it's not already put
    if (!Get.isRegistered<TaskController>()) {
      Get.put(TaskController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: AppTheme.surfaceGray,
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          SearchBarWidget(), // SearchBarWidget now directly interacts with controller
          Obx(
            () =>
                controller.isMultiSelectMode.value
                    ? _buildMultiSelectBar(controller)
                    : const SizedBox.shrink(),
          ), // Conditionally show multi-select bar
          Expanded(
            child: Obx(() {
              if (controller.filteredTasks.isEmpty &&
                  controller.searchQuery.isEmpty &&
                  controller.currentFilter.value == 'All') {
                return EmptyStateWidget(
                  onAddTask: () => Get.to(() => AddTaskScreen()),
                ); // Navigate to AddTaskScreen
              } else if (controller.filteredTasks.isEmpty) {
                return Center(
                  child: Text(
                    'No tasks found for the current filter/search.',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: controller.fetchTasks, // Refresh from DB
                  color: AppTheme.primaryPurple,
                  child: ListView.builder(
                    itemCount: controller.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = controller.filteredTasks[index];

                      return Obx(
                        () => TaskItemWidget(
                          task: task, // Pass Task object directly
                          isSelected: controller.selectedTaskIds.contains(
                            task.id,
                          ),
                          onToggleComplete:
                              () => controller.toggleTaskComplete(task.id!),
                          onEdit:
                              () => Get.to(
                                () => AddTaskScreen(taskToEdit: task),
                              ), // Pass Task object
                          onDelete: () => controller.deleteTask(task.id!),
                          onDuplicate: () => controller.duplicateTask(task),
                          onSetReminder: () => controller.setReminder(task),
                          onLongPress:
                              () => controller.toggleMultiSelect(task.id!),
                          onTap:
                              controller.isMultiSelectMode.value
                                  ? () => controller.toggleMultiSelect(task.id!)
                                  : null,
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () =>
            controller.isMultiSelectMode.value
                ? const SizedBox.shrink()
                : FloatingActionButton(
                  onPressed:
                      () => Get.to(
                        () => AddTaskScreen(),
                      ), // Navigate to AddTaskScreen
                  backgroundColor: AppTheme.primaryPurple,
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.backgroundWhite,
                    size: 6.w,
                  ),
                ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(TaskController controller) {
    return AppBar(
      backgroundColor: SColors.primary,
      foregroundColor: AppTheme.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.backgroundWhite,
          size: 6.w,
        ),
      ),
      title: Obx(
        () => Text(
          controller.isMultiSelectMode.value
              ? '${controller.selectedTaskIds.length} selected'
              : 'To-Do List',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.backgroundWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        Obx(
          () =>
              controller.isMultiSelectMode.value
                  ? IconButton(
                    onPressed: controller.exitMultiSelectMode,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.backgroundWhite,
                      size: 6.w,
                    ),
                  )
                  : IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        FilterBottomSheet(),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      );
                    },
                    icon: Stack(
                      children: [
                        CustomIconWidget(
                          iconName: 'filter_list',
                          color: AppTheme.backgroundWhite,
                          size: 6.w,
                        ),
                        if (controller.currentFilter.value != 'All')
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: const BoxDecoration(
                                color: AppTheme.warningOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectBar(TaskController controller) {
    return Container(
      color: AppTheme.primaryPurple.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  controller.selectedTaskIds.isEmpty
                      ? null
                      : controller.markSelectedComplete,
              icon: CustomIconWidget(
                iconName: 'check',
                color: AppTheme.backgroundWhite,
                size: 4.w,
              ),
              label: const Text('Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successGreen,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  controller.selectedTaskIds.isEmpty
                      ? null
                      : controller.deleteSelectedTasks,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.backgroundWhite,
                size: 4.w,
              ),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
