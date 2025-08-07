import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/widgets/custom_icon_widget.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/core/app_theme.dart';

class ExpenseBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> expense;
  final bool isCurrentUser;
  final VoidCallback? onLongPress;

  const ExpenseBubbleWidget({
    super.key,
    required this.expense,
    required this.isCurrentUser,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        constraints: BoxConstraints(maxWidth: 75.w, minWidth: 40.w),
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isCurrentUser ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCategoryIcon(
                      expense['category'] as String? ?? 'other',
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        '₹${(expense['amount'] as double).toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color:
                              isCurrentUser
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (expense['description'] != null &&
                    (expense['description'] as String).isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Text(
                    expense['description'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isCurrentUser
                              ? colorScheme.onPrimary.withValues(alpha: 0.9)
                              : colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // FIX: Convert Timestamp to DateTime using .toDate()
                      _formatTime((expense['timestamp'] as Timestamp).toDate()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isCurrentUser
                                ? colorScheme.onPrimary.withValues(alpha: 0.7)
                                : colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                    if (isCurrentUser && expense['isRead'] == true)
                      CustomIconWidget(
                        iconName: 'done_all',
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                        size: 12,
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

  Widget _buildCategoryIcon(String category) {
    String iconName;
    switch (category.toLowerCase()) {
      case 'food':
        iconName = 'restaurant';
        break;
      case 'transport':
        iconName = 'directions_car';
        break;
      case 'rent':
        iconName = 'home';
        break;
      case 'entertainment':
        iconName = 'movie';
        break;
      case 'shopping':
        iconName = 'shopping_bag';
        break;
      case 'bills':
        iconName = 'receipt_long';
        break;
      default:
        iconName = 'attach_money';
    }

    return CustomIconWidget(
      iconName: iconName,
      color:
          isCurrentUser
              ? Colors.white.withValues(alpha: 0.9)
              : AppTheme.lightTheme.primaryColor,
      size: 16,
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
