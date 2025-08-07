// File: lib/presentation/to_do_list_screen/widgets/task_item_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/models/task_model.dart'; // For date formatting

class TaskItemWidget extends StatelessWidget {
  final Task task; // Now accepts a Task object directly
  final bool isSelected;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onSetReminder;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.isSelected,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
    required this.onSetReminder,
    required this.onLongPress,
    this.onTap,
  }) : super(key: key);

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningOrange;
      case 'low':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  // Updated _formatDueDate to show actual date + relative time
  String _formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    String relativeText;
    if (taskDate.isAtSameMomentAs(today)) {
      relativeText = 'Today';
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      relativeText = 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      relativeText = '$difference day${difference > 1 ? 's' : ''} overdue';
    } else {
      final difference = taskDate.difference(today).inDays;
      relativeText = 'In $difference day${difference > 1 ? 's' : ''}';
    }

    // Include the actual date
    final String formattedDate = DateFormat('MMM d, yyyy').format(dueDate);

    return '$relativeText ($formattedDate)';
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted =
        task.isCompleted; // Directly access bool from Task object
    final String priority = task.priority;
    final DateTime? dueDate = task.dueDate;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border:
              isSelected
                  ? Border.all(color: AppTheme.primaryPurple, width: 2)
                  : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Dismissible(
            key: ValueKey(task.id), // Use task.id
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                _showTaskActions(context);
                return false;
              } else if (direction == DismissDirection.endToStart) {
                onDelete();
                return true;
              }
              return false;
            },
            background: Container(
              color: AppTheme.successGreen,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.backgroundWhite,
                    size: 8.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Actions',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: AppTheme.errorLight,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.backgroundWhite,
                    size: 8.w,
                  ),
                ],
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Priority indicator
                  Container(
                    width: 1.5.w,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onToggleComplete,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isCompleted
                                        ? AppTheme.successGreen
                                        : Colors.transparent,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppTheme.primaryPurple
                                          : (isCompleted
                                              ? AppTheme.successGreen
                                              : AppTheme.borderSubtle),
                                  width: 2,
                                ),
                              ),
                              child:
                                  isSelected
                                      ? Center(
                                        child: CustomIconWidget(
                                          iconName: 'check',
                                          color: AppTheme.backgroundWhite,
                                          size: 4.w,
                                        ),
                                      )
                                      : (isCompleted
                                          ? Center(
                                            child: CustomIconWidget(
                                              iconName: 'check',
                                              color: AppTheme.backgroundWhite,
                                              size: 4.w,
                                            ),
                                          )
                                          : null),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title, // Access title directly from Task object
                                  style: AppTheme
                                      .lightTheme
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        decoration:
                                            isCompleted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (task.description != null &&
                                    task.description!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 0.5.h),
                                    child: Text(
                                      task.description!, // Access description directly
                                      style: AppTheme
                                          .lightTheme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                            decoration:
                                                isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'schedule',
                                      color:
                                          isCompleted
                                              ? AppTheme.textSecondary
                                              : (dueDate != null &&
                                                      dueDate.isBefore(
                                                        DateTime.now(),
                                                      )
                                                  ? AppTheme.errorLight
                                                  : AppTheme.textSecondary),
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      _formatDueDate(
                                        dueDate,
                                      ), // Pass dueDate directly
                                      style: AppTheme
                                          .lightTheme
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color:
                                                isCompleted
                                                    ? AppTheme.textSecondary
                                                    : (dueDate != null &&
                                                            dueDate.isBefore(
                                                              DateTime.now(),
                                                            )
                                                        ? AppTheme.errorLight
                                                        : AppTheme
                                                            .textSecondary),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    if (task.subject != null &&
                                        task.subject!.isNotEmpty) ...[
                                      SizedBox(width: 3.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                          vertical: 0.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryPurple
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          task.subject!, // Access subject directly
                                          style: AppTheme
                                              .lightTheme
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: AppTheme.primaryPurple,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          if (!isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(
                                  priority,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                priority,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                      color: _getPriorityColor(priority),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    task.title, // Access title directly
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(color: AppTheme.borderSubtle, height: 1.h),
                _buildActionTile(
                  context,
                  iconName: 'edit',
                  label: 'Edit Task',
                  onTap: () {
                    Get.back();
                    onEdit();
                  },
                ),
                _buildActionTile(
                  context,
                  iconName: 'copy',
                  label: 'Duplicate Task',
                  onTap: () {
                    Get.back();
                    onDuplicate();
                  },
                ),
                _buildActionTile(
                  context,
                  iconName: 'notifications_active',
                  label: 'Set Reminder',
                  onTap: () {
                    Get.back();
                    onSetReminder();
                  },
                ),
                _buildActionTile(
                  context,
                  iconName: 'delete',
                  label: 'Delete Task',
                  textColor: AppTheme.errorLight,
                  iconColor: AppTheme.errorLight,
                  onTap: () {
                    Get.back();
                    onDelete();
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String iconName,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: iconColor ?? AppTheme.textSecondary,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: textColor ?? AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
