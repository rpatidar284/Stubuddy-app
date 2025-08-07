// File: lib/presentation/to_do_list_screen/widgets/empty_state_widget.dart
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/custom_icon_widget.dart';
import 'package:stu_buddy/utils/constants/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddTask;

  const EmptyStateWidget({Key? key, required this.onAddTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // Keep SingleChildScrollView
        padding: EdgeInsets.all(8.w), // Use consistent padding with sizer
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Ensure column only takes needed space
          children: [
            // Illustration
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 5.h,
                horizontal: 5.w,
              ), // Added internal padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Essential for nested columns
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'assignment',
                      color: AppTheme.primaryPurple,
                      size: 10.w,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Simulated text lines within illustration
                  Container(
                    width: 40.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 30.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 35.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Title
            Text(
              'No Tasks Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Description
            Text(
              'Start organizing your academic life by adding your first task. Keep track of assignments, projects, and study goals all in one place.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // CTA Button
            GFButton(
              onPressed: onAddTask,
              text: 'Add Your First Task',
              shape: GFButtonShape.pills,

              size: GFSize.LARGE,
              color: SColors.buttonPrimary,
            ),
            SizedBox(height: 3.h),

            // Tips
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: AppTheme.warningOrange,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Pro Tips',
                        style: AppTheme.lightTheme.textTheme.titleSmall
                            ?.copyWith(
                              color: AppTheme.warningOrange,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildTip('Set due dates to stay on track'),
                  _buildTip('Use priority levels to focus on important tasks'),
                  _buildTip('Organize tasks by subject for better clarity'),
                  _buildTip('Swipe for quick actions like edit and delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.5.w,
            height: 1.5.w,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
