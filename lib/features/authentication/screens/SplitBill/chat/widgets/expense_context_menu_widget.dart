import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/widgets/custom_icon_widget.dart';

/// Context menu widget for expense bubbles
/// Shows options like Edit, Delete, Add Note, Split Details
class ExpenseContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> expense;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddNote;
  final VoidCallback? onSplitDetails;
  final VoidCallback onDismiss;

  const ExpenseContextMenuWidget({
    super.key,
    required this.expense,
    this.onEdit,
    this.onDelete,
    this.onAddNote,
    this.onSplitDetails,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expense info header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: _getCategoryIcon(
                          expense['category'] as String? ?? 'other',
                        ),
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${(expense['amount'] as double).toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (expense['description'] != null &&
                                (expense['description'] as String).isNotEmpty)
                              Text(
                                expense['description'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                // Action buttons
                Column(
                  children: [
                    _buildActionButton(
                      context,
                      icon: 'edit',
                      label: 'Edit Expense',
                      onTap: () {
                        onDismiss();
                        onEdit?.call();
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: 'note_add',
                      label: 'Add Note',
                      onTap: () {
                        onDismiss();
                        onAddNote?.call();
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: 'info_outline',
                      label: 'Split Details',
                      onTap: () {
                        onDismiss();
                        onSplitDetails?.call();
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: 'delete_outline',
                      label: 'Delete',
                      onTap: () {
                        onDismiss();
                        _showDeleteConfirmation(context);
                      },
                      isDestructive: true,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onDismiss,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color:
                    isDestructive
                        ? colorScheme.error
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isDestructive ? colorScheme.error : colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'restaurant';
      case 'transport':
        return 'directions_car';
      case 'rent':
        return 'home';
      case 'entertainment':
        return 'movie';
      case 'shopping':
        return 'shopping_bag';
      case 'bills':
        return 'receipt_long';
      default:
        return 'attach_money';
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Expense',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this expense? This action cannot be undone.',
              style: theme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete?.call();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
