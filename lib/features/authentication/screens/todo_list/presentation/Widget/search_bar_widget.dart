// File: lib/presentation/to_do_list_screen/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/filter_bottom_sheet.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/presentation/Widget/task_controller.dart'; // Import GetX

class SearchBarWidget extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();
  final TextEditingController _searchController = TextEditingController();

  SearchBarWidget({Key? key}) : super(key: key) {
    _searchController.text =
        controller.searchQuery.value; // Initialize with current search query
    _searchController.addListener(() {
      controller.setSearchQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search tasks by title or subject...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: Obx(
                    () =>
                        controller.searchQuery.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                controller.setSearchQuery('');
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme.textSecondary,
                                size: 5.w,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ), // Use SizedBox.shrink for no icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryPurple,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Filter Button
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color:
                    controller.currentFilter.value != 'All'
                        ? AppTheme.primaryPurple
                        : AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      FilterBottomSheet(),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    child: Stack(
                      children: [
                        CustomIconWidget(
                          iconName: 'filter_list',
                          color:
                              controller.currentFilter.value != 'All'
                                  ? AppTheme.backgroundWhite
                                  : AppTheme.textSecondary,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
