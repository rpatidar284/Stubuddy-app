// File: lib/presentation/to_do_list_screen/widgets/filter_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/task_controller.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({Key? key}) : super(key: key);

  final TaskController controller = Get.find<TaskController>();

  final List<Map<String, dynamic>> _filterOptions = [
    {'value': 'All', 'label': 'All Tasks', 'icon': 'list'},
    {'value': 'Pending', 'label': 'Pending', 'icon': 'radio_button_unchecked'},
    {'value': 'Completed', 'label': 'Completed', 'icon': 'check_circle'},
    {
      'value': 'High Priority',
      'label': 'High Priority',
      'icon': 'priority_high',
    },
    {'value': 'Due Today', 'label': 'Due Today', 'icon': 'today'},
    {'value': 'Overdue', 'label': 'Overdue', 'icon': 'warning'},
  ];

  final List<Map<String, dynamic>> _sortOptions = [
    {'value': 'Due Date', 'label': 'Due Date', 'icon': 'schedule'},
    {'value': 'Priority', 'label': 'Priority', 'icon': 'flag'},
    {'value': 'Created Date', 'label': 'Created Date', 'icon': 'access_time'},
    {'value': 'Alphabetical', 'label': 'Alphabetical', 'icon': 'sort_by_alpha'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      controller.setFilter('All');
                      controller.setSort('Due Date');
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Filter Section
              Text(
                'Filter by',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryPurple,
                ),
              ),
              SizedBox(height: 2.h),

              Obx(
                () => Column(
                  children:
                      _filterOptions
                          .map(
                            (option) => _buildFilterOption(
                              value: option['value'],
                              label: option['label'],
                              icon: option['icon'],
                              isSelected:
                                  controller.currentFilter.value ==
                                  option['value'],
                              onTap:
                                  () => controller.setFilter(option['value']),
                            ),
                          )
                          .toList(),
                ),
              ),

              SizedBox(height: 2.h),

              // Sort Section
              Text(
                'Sort by',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryPurple,
                ),
              ),
              SizedBox(height: 2.h),

              Obx(
                () => Column(
                  children:
                      _sortOptions
                          .map(
                            (option) => _buildFilterOption(
                              value: option['value'],
                              label: option['label'],
                              icon: option['icon'],
                              isSelected:
                                  controller.currentSort.value ==
                                  option['value'],
                              onTap: () => controller.setSort(option['value']),
                            ),
                          )
                          .toList(),
                ),
              ),

              SizedBox(height: 2.h),

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
                      onPressed: () {
                        Get.back();
                      },
                      text: 'Apply',
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
    );
  }

  Widget _buildFilterOption({
    required String value,
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.5.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppTheme.primaryPurple.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border:
                isSelected
                    ? Border.all(color: AppTheme.primaryPurple, width: 1)
                    : null,
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color:
                    isSelected
                        ? AppTheme.primaryPurple
                        : AppTheme.textSecondary,
                size: 5.w,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color:
                        isSelected
                            ? AppTheme.primaryPurple
                            : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.primaryPurple,
                  size: 5.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
